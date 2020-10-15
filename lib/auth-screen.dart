import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_delta/http_exception.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'colortheme.dart';
import 'package:flutter/material.dart';
import 'events.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/signin';
  final User user;
  final Auth auth;

  AuthScreen(this.user, this.auth);

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    transformConfig.translate(-10.0);
    return Scaffold(
        backgroundColor: color.secondaryColor,
        resizeToAvoidBottomInset: false,
        body: AuthCard(user,
            auth) /*Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM')
            )
          ), child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', fit: BoxFit.fitHeight,)),
          //Column(
          //  children: <Widget>[
          //    Row(
          //      children: <Widget>[
          //        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, fit: BoxFit.cover),
          //        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, fit: BoxFit.cover),
          //        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1, height: 200, fit: BoxFit.cover),
          //        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, height: 243, width: 50,fit: BoxFit.cover),
          //      ],
          //    ),
          //    Row(
         //       children: <Widget>[
         //         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, fit: BoxFit.cover),
         //         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, fit: BoxFit.cover),
          //        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1, height: 200, fit: BoxFit.cover),
         // //        Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, height: 243, width: 50,fit: BoxFit.cover),
         //       ],
         //     ),
         ////     Row(
         //       children: <Widget>[
         //         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, height: 200, fit: BoxFit.cover),
         //         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, height: 200, fit: BoxFit.cover),
         //         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1, height: 200, fit: BoxFit.cover),
         //         Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTWFO7nd2futUGxUYtvlEi-uyoUrGa3_Z3oNk_9DcbPU_KdVlqM', scale: 1.25, height: 200, width: 50, fit: BoxFit.cover,),

          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    //  transform: Matrix4.rotationZ(-8 * pi / 180)
                    //    ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0x00),
                        //boxShadow: [
                        ///  BoxShadow(
                        //    blurRadius: 8,
                        //    color: Colors.black26,
                        //    offset: Offset(0, 2),
                        //  )
                        //],
                      ),
                      child: //Text(
                      //  'Utsav Events',
                      //  style: TextStyle(
                      //    color: Theme.of(context).accentTextTheme.title.color,
                      //    fontSize: 50,
                      //    fontFamily: 'Anton',
                      //    fontWeight: FontWeight.normal,
                      //  ),
                      //),
                        Image.network('https://static.wixstatic.com/media/dbb961_3a27950c32f24508a3dc92704146f863~mv2.gif')
                    ),
                  ),

                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ]
          )*/
        );
  }
}

class AuthCard extends StatefulWidget {
  final User user;
  final Auth auth;

  //const AuthCard({
  //  Key key, this.user
  //}) : super(key: key);

  AuthCard(this.user, this.auth);

  @override
  _AuthCardState createState() => _AuthCardState(user, auth);
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  User user;
  Auth auth;

  _AuthCardState(this.user, this.auth);

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _isGoogleLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  color: color.primaryColor,
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'],
            _authData['password'],
            'accounts:signInWithPassword');
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'], _authData['password'], 'accounts:signUp');
      }
      if (_authMode == AuthMode.Login) {
        user.email = _authData['email'];
        user.profilePic =
            'https://www.gyanbar.com/wp-content/uploads/2019/07/Facebook-Profile-Pictures-3.jpg';
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        user.email = _authData['email'];
        user.profilePic =
            'https://www.gyanbar.com/wp-content/uploads/2019/07/Facebook-Profile-Pictures-3.jpg';
        Navigator.of(context).pushReplacementNamed('/secondstep');
        await Firestore.instance
            .collection("users")
            .document(user.email)
            .setData({});
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Passwords have to be at least 6 characters long.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      //const errorMessage =
      //    'Could not authenticate you. Please try again later.';
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  //GoogleSignIn _googleSignIn = GoogleSignIn(
  //scopes: <String>[
  //  'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  //],
//);

  /*GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }*/
  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: color.secondaryColor,
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
                padding: EdgeInsets.only(top: 75),
                child: ListView(children: <Widget>[
                  Text(
                    'Welcome \n back.',
                    style: TextStyle(
                      color: color.secondaryTextColor,
                      fontSize: 45,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  /*Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 300),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child:*/
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: TextFormField(
                            style: TextStyle(color: color.secondaryTextColor),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: color.primaryLightColor,
                                  width: 2.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: color.primaryColor,
                                  width: 2.5,
                                ),
                              ),
                              labelText: 'enter e-mail',
                              labelStyle: TextStyle(
                                color: color.primaryColor,
                                fontWeight: FontWeight.w300,
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: color.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        //SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: TextFormField(
                            style: TextStyle(color: color.secondaryTextColor),
                            //decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: color.primaryLightColor,
                                  width: 2.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: color.primaryColor,
                                  width: 2.5,
                                ),
                              ),
                              labelText: 'enter password',
                              labelStyle: TextStyle(
                                color: color.primaryColor,
                                fontWeight: FontWeight.w300,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: color.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        if (_authMode == AuthMode.Signup)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              enabled: _authMode == AuthMode.Signup,
                              //decoration: InputDecoration(labelText: 'Confirm Password'),
                              obscureText: true,
                              validator: _authMode == AuthMode.Signup
                                  ? (value) {
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match!';
                                      }
                                    }
                                  : null,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Color(0xFFF25652),
                                    width: 2.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Color(0xFFF25652),
                                    width: 2.5,
                                  ),
                                ),
                                labelText: 'confirm password',
                                labelStyle: TextStyle(
                                  color: color.primaryColor,
                                  fontWeight: FontWeight.w300,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: color.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator(
                            backgroundColor: color.primaryDarkColor,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                color.primaryLightColor),
                          )
                        else
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 25),
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: color.primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FlatButton(
                              onPressed: _submit,
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                        /*if (_isLoading)
                            CircularProgressIndicator()
                          else
                            RaisedButton(
                              child: Text(_authMode == AuthMode.Login
                                  ? 'LOGIN'
                                  : 'SIGN UP'),
                              onPressed: _submit,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  .color,
                            ),*/
                        Center(
                          child: Text(
                            '- or -',
                            style: TextStyle(
                              color: color.secondaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (_isGoogleLoading)
                              Container(
                                  margin: EdgeInsets.only(right: 30, top: 15),
                                  child: CircularProgressIndicator(
                                    backgroundColor: color.primaryDarkColor,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            color.primaryLightColor),
                                  ))
                            else
                              Container(
                                margin: EdgeInsets.only(right: 30, top: 15),
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: color.primaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: FlatButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isGoogleLoading = true;
                                    });
                                    await authService.googleSignIn(
                                        user, auth, context);
                                    setState(() {
                                      _isGoogleLoading = false;
                                    });
                                  },
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: color.primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'f',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 55),
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: FlatButton(
                            onPressed: _switchAuthMode,
                            child: Text(
                              '${_authMode == AuthMode.Login ? 'Sign Up' : 'Login'} Instead',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ),
                        /*FlatButton(
                            child: Text(
                                '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                            onPressed: _switchAuthMode,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 4),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            textColor: Theme.of(context).primaryColor,
                          ),
                          RaisedButton(
                            child: Text('Admin Skip',
                                style: TextStyle(fontSize: 20)),
                            elevation: 10,
                            disabledColor: Colors.grey,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/');
                            },
                          )*/
                      ],
                    ),
                  )
                ]))));
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
