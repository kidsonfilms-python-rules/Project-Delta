import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart' as g;
import 'package:project_delta/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'events.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userID;
  Timer _authTimer;
  bool otherAuth = false;
  bool get isAuth {
    //if (otherAuth == true) { return true;}
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAfXLxZRkJ-rB00Z9TCrBRdJizZ6AQriH4';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      print(response.body);
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password, String s) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAfXLxZRkJ-rB00Z9TCrBRdJizZ6AQriH4';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      print(response.body);
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String(),
        'email': email
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin(User user) async {
    String email = '';
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userID = extractedUserData['userId'];
    user.email = extractedUserData['email'];
    _expiryDate = expiryDate;
    notifyListeners();
    //_autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
    //Phoenix.rebirth(context);
  }
  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }

}

class AuthService {
  final g.GoogleSignIn _googleSignIn = g.GoogleSignIn();
  final f.FirebaseAuth _auth = f.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Observable<f.User> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = Observable(_auth.authStateChanges());

    profile = user.switchMap((f.User u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((snap) => snap.data());
      } else {
        return Observable.just({});
      }
    });
  }

  Future<f.User> googleSignIn(
      User userClass, Auth auth, BuildContext context) async {
    bool firstSignin;

    try {
      loading.add(true);
      g.GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      g.GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final f.AuthCredential credential = f.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      f.UserCredential result = await _auth.signInWithCredential(credential);
      f.User user = result.user;
      updateUserData(user, userClass, auth, firstSignin);
      print("user name: ${user.displayName}");

      if (firstSignin == true) {
        Navigator.of(context).pushNamed('/secondstep');
      } else {
        Navigator.of(context).pushNamed('/home');
      }

      loading.add(false);
      return user;
    } catch (error) {
      return error;
    }
  }

  void updateUserData(
      f.User user, User userClass, Auth auth, bool firstSignin) async {
    auth.otherAuth = true;
    userClass.email = user.email;
    userClass.profilePic = user.photoURL;
    userClass.name = user.displayName;
    DocumentReference ref = _db.collection('users').doc(user.email);
    var document = ref;
    document.get().then((document) {
      document = document;
    });

    if (document == null) {
      firstSignin = true;
    } else {
      firstSignin = false;
    }

    return ref.set({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoURL,
      'name': user.displayName,
      'lastSeen': DateTime.now()
    });
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }
}

// TODO refactor global to InheritedWidget
final AuthService authService = AuthService();
