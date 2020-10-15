import 'dart:math';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:project_delta/aboutPage.dart';
import 'package:project_delta/colortheme.dart';
import 'package:project_delta/next_event.dart';
import 'package:project_delta/notification_2.0.dart';
import 'package:project_delta/schedule_items.dart';
import 'package:project_delta/schedule_page.dart';
import 'package:project_delta/services/locator.dart';
import 'package:project_delta/services/push_notification.dart';
import 'package:project_delta/volunteer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'app_state.dart';
//import 'notification.dart';
//import 'notification_2.0.dart';
import './colortheme.dart';
import 'announcements.dart';
import 'auth-screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'events.dart';
import 'waiting_screen.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  _pushNotificationService.initialise();

  FirebaseMessaging().getToken().then((token) {
    print('THIS IS A BLOODY TOKEN ' + token);
  });
  FirebaseMessaging().subscribeToTopic('schedule').then((result) {
    print('We ARE FINALLY BLOOOODY SUBSRIBED');
  });
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MaterialApp(
      //     home: SplashScreen(
      //   'assets/splash.flr',
      //   MyApp(),
      //   startAnimation: 'Untitled',
      //   backgroundColor: Color(0xffE8E8E8),
      // )));
      home: Phoenix(child: MyApp())));
}

class MyApp extends StatelessWidget {
  final String _email = "bruh@insertbruhsoundeffect.com";
  //String user_email;
  User thisUser = new User(
      "empty",
      'https://www.gyanbar.com/wp-content/uploads/2019/07/Facebook-Profile-Pictures-3.jpg',
      'empty');

  final url = 'https://project-delta-db6b3.firebaseio.com/test_1.json';

  final String appTitle = 'Utsav Events';
  AuthService authService;

  get auth => AccountRoute(
      auth.token, _email, authService, thisUser.profilePic, thisUser.name);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          //ChangeNotifierProvider.value(value: SubmitExtraDetails(this.auth.token),),
          ChangeNotifierProxyProvider<Auth, AccountRoute>(
            create: (_) => AccountRoute(auth.token, thisUser.email, authService,
                thisUser.profilePic, thisUser.name),
            update: (ctx, auth, previousAccountRoute) => AccountRoute(
                auth.token,
                thisUser.email,
                authService,
                thisUser.profilePic,
                thisUser.name),
          ),
          ChangeNotifierProxyProvider<Auth, SignupStep2>(
            create: (_) => SignupStep2(auth.token, thisUser),
            update: (ctx, auth, previousSignupStep2) =>
                SignupStep2(auth.token, thisUser),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Utsav Events',
            // MaterialApp contains our top-level Navigator
            home: auth.otherAuth
                ? HomePage(thisUser.email, thisUser.profilePic, thisUser.name)
                : auth.isAuth
                    ? HomePage(
                        thisUser.email, thisUser.profilePic, thisUser.name)
                    : FutureBuilder(
                        future: auth.tryAutoLogin(thisUser),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen2()
                                : AuthScreen(thisUser, auth)),
            routes: {
              '/signin': (BuildContext context) => AuthScreen(thisUser, auth),
              '/home': (BuildContext context) =>
                  HomePage(thisUser.email, thisUser.profilePic, thisUser.name),
              '/register': (BuildContext context) => RegisterRoute(),
              '/account': (BuildContext context) => AccountRoute(
                  auth.token,
                  thisUser.email,
                  authService,
                  thisUser.profilePic,
                  thisUser.name),
              '/schedule': (BuildContext context) => ScheduleRoute(
                  thisUser.email, thisUser.profilePic, thisUser.name),
              '/contact': (BuildContext context) => ContactRoute(
                  thisUser.email, thisUser.profilePic, thisUser.name),
              '/settings': (BuildContext context) => SettingsRoute(
                  thisUser.email, thisUser.profilePic, thisUser.name
                  //screenHeight: MediaQuery.of(context).size,
                  ),
              '/secondstep': (BuildContext context) =>
                  SignupStep2(auth.token, thisUser),
              '/notification': (BuildContext context) => Notification(),
              '/lunchcheckin': (BuildContext context) =>
                  LunchCheckInRoute(thisUser.email),
              '/volunteer': (BuildContext context) => VolunteerRoute(
                  thisUser.email, thisUser.profilePic, thisUser.name),
              '/volunteerchat': (BuildContext context) => VolunteerChatRoute(
                  thisUser.email, thisUser.profilePic, thisUser.name),
              '/about': (BuildContext context) =>
                  AboutRoute(thisUser.email, thisUser.profilePic, thisUser.name)
            },
          ),
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage(this.email, this.profilePic, this.name);
  final email;
  final profilePic;
  final name;
  @override
  State<StatefulWidget> createState() {
    return _HomePageState(email, profilePic, name);
  }
}

class _HomePageState extends State<HomePage> {
  List<String> people = ['Person_1'];

  _HomePageState(this.email, this.profilePic, this.name);
  final email;
  final profilePic;
  final name;
  build(context) {
    return MaterialApp(
        theme: new ThemeData(
            primaryColor: color.primaryColor,
            primaryColorDark: color.primaryDarkColor,
            primaryColorLight: color.primaryLightColor,
            secondaryHeaderColor: color.secondaryColor,
            backgroundColor: color.secondaryColor),
        home: Scaffold(
            backgroundColor: color.secondaryColor,
            drawer: Drawer(
              child: Container(
                color: color.secondaryLightColor,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,

                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(name),
                      accountEmail: Text(email),
                      currentAccountPicture: CircleAvatar(
                        // child: Text(
                        //   'B',
                        //   style: TextStyle(fontSize: 40.0),
                        // ),
                        // backgroundColor: primaryDarkColor,
                        // foregroundColor: Colors.white,
                        backgroundImage: NetworkImage(profilePic),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Home',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'Schedule',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/schedule');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'My Account',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/account');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Contact Us',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/contact');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/settings');
                      },
                    ),
                    // ListTile(
                    //   title: Text('Volunteer'),
                    //   onTap: () {
                    //     Navigator.of(context).pushReplacementNamed('/volunteer');
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/about');
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/account');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/settings');
                  },
                ),
              ],
              title: Text('Utsav Events'),
            ),
            body: Stack(children: <Widget>[
              HomePageBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            Text(
                              'Beta 0.1.0',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Container(
                                margin: EdgeInsets.all(40.0),
                                child: Column(children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/schedule');
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      elevation: 4,
                                      color: color.secondaryLightColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                      child: TimerBuilder.periodic(
                                        Duration(minutes: 5),
                                        builder: (context) {
                                          return StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Schedule')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot
                                                    .hasData) //if no data.. Now Event Box
                                                  return Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor: color
                                                            .primaryDarkColor,
                                                        valueColor:
                                                            new AlwaysStoppedAnimation<
                                                                    Color>(
                                                                color
                                                                    .primaryLightColor),
                                                      ));

                                                // go through the schedule and find the current event name
                                                DateTime now = DateTime.now();
                                                Duration leastDiff =
                                                    Duration(hours: 88);
                                                String nowEvent =
                                                    'No Current Event';
                                                int nowIndex = -1;
                                                for (int i = 0;
                                                    i <
                                                        snapshot.data.documents
                                                            .length;
                                                    i++) {
                                                  DateTime event =
                                                      DateTime.parse(snapshot
                                                              .data.documents[i]
                                                          ['time']);
                                                  //print(event);
                                                  if (event.isBefore(now) ==
                                                      true) {
                                                    var difference =
                                                        now.difference(event);
                                                    if (difference <
                                                        leastDiff) {
                                                      leastDiff = difference;
                                                      nowEvent = snapshot.data
                                                          .documents[i]['name'];
                                                      nowIndex = snapshot
                                                              .data.documents[i]
                                                          ['index'];
                                                    }
                                                  }
                                                }
                                                String nextEvent =
                                                    'Can\'t find Next Event';
                                                if (nowIndex ==
                                                    snapshot.data.documents
                                                            .length -
                                                        1) {
                                                  nextEvent = 'No More Events';
                                                } else {
                                                  for (int i = 0;
                                                      i <
                                                          snapshot.data
                                                              .documents.length;
                                                      i++) {
                                                    if (snapshot.data
                                                                .documents[i]
                                                            ['index'] ==
                                                        (nowIndex + 1)) {
                                                      nextEvent = snapshot.data
                                                          .documents[i]['name'];
                                                      break;
                                                    }
                                                  }
                                                }
                                                //print(nextEvent);
                                                return Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Center(),
                                                      Text(
                                                        'Now',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: color
                                                              .secondaryTextColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          nowEvent,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: color
                                                                .secondaryTextColor,
                                                            fontSize: 21,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Coming Up',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: color
                                                              .secondaryTextColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          nextEvent,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: color
                                                                .secondaryTextColor,
                                                            fontSize: 21,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      elevation: 4,
                                      color: color.secondaryLightColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Check-In to Event',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: color.secondaryTextColor,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                //'Click below for your check-in tickets',
                                                'Check-in not needed for virtual events', //jray
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      color.secondaryTextColor,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: RaisedButton(
                                                color: color.primaryColor,
                                                child: Text('Check-In',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: color
                                                            .secondaryColor)),
                                                elevation: 10,
                                                disabledColor: Colors.grey,
                                                // jray: disabled the button for DP2020
                                                // onPressed: () {
                                                //   Navigator.pushNamed(
                                                //       context, '/lunchcheckin');
                                                // },
                                                onPressed: null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        elevation: 4,
                                        color: color.secondaryLightColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24))),
                                        child: Container(
                                            margin: EdgeInsets.all(10),
                                            child: Column(children: <Widget>[
                                              Text(
                                                'Announcements',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      color.secondaryTextColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TimerBuilder.periodic(
                                                Duration(minutes: 5),
                                                builder: (context) {
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Announcements')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot
                                                            .hasData) //if no data.. Now Event Box
                                                          return Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                backgroundColor:
                                                                    color
                                                                        .primaryDarkColor,
                                                                valueColor:
                                                                    new AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        color
                                                                            .primaryLightColor),
                                                              ));
                                                        int currentIndex =
                                                            snapshot
                                                                    .data
                                                                    .documents
                                                                    .length -
                                                                1;
                                                        String currentBody =
                                                            'There are no Announcements';
                                                        String currentImage =
                                                            '';
                                                        int currentListIndex =
                                                            0;
                                                        for (int i = 0;
                                                            i <
                                                                snapshot
                                                                    .data
                                                                    .documents
                                                                    .length;
                                                            i++) {
                                                          if (snapshot.data
                                                                      .documents[
                                                                  i]['index'] ==
                                                              currentIndex) {
                                                            //currentListIndex = i;
                                                            currentBody;
                                                            currentBody = snapshot
                                                                    .data
                                                                    .documents[
                                                                i]['body'];
                                                            currentImage = snapshot
                                                                    .data
                                                                    .documents[
                                                                i]['imageUrl'];
                                                          }
                                                        }
                                                        // go through the schedule and find the current event name
                                                        // DateTime now =
                                                        //     DateTime.now();
                                                        // Duration leastDiff =
                                                        //     Duration(hours: 88);
                                                        // String nowEvent =
                                                        //     'No Current Event';
                                                        // int nowIndex = -1;
                                                        // for (int i = 0;
                                                        //     i <
                                                        //         snapshot
                                                        //             .data
                                                        //             .documents
                                                        //             .length;
                                                        //     i++) {
                                                        //   DateTime event = DateTime
                                                        //       .parse(snapshot
                                                        //               .data
                                                        //               .documents[
                                                        //           i]['time']);
                                                        //   //print(event);
                                                        //   if (event.isBefore(
                                                        //           now) ==
                                                        //       true) {
                                                        //     var difference =
                                                        //         now.difference(
                                                        //             event);
                                                        //     if (difference <
                                                        //         leastDiff) {
                                                        //       leastDiff =
                                                        //           difference;
                                                        //       nowEvent = snapshot
                                                        //               .data
                                                        //               .documents[
                                                        //           i]['name'];
                                                        //       nowIndex = snapshot
                                                        //               .data
                                                        //               .documents[
                                                        //           i]['index'];
                                                        //     }
                                                        //   }
                                                        // }
                                                        // String nextEvent =
                                                        //     'Can\'t find Next Event';
                                                        // if (nowIndex ==
                                                        //     snapshot
                                                        //             .data
                                                        //             .documents
                                                        //             .length -
                                                        //         1) {
                                                        //   nextEvent =
                                                        //       'No More Events';
                                                        // } else {
                                                        //   for (int i = 0;
                                                        //       i <
                                                        //           snapshot
                                                        //               .data
                                                        //               .documents
                                                        //               .length;
                                                        //       i++) {
                                                        //     if (snapshot.data
                                                        //                 .documents[i]
                                                        //             ['index'] ==
                                                        //         (nowIndex +
                                                        //             1)) {
                                                        //       nextEvent = snapshot
                                                        //               .data
                                                        //               .documents[
                                                        //           i]['name'];
                                                        //       break;
                                                        //     }
                                                        //   }
                                                        // }
                                                        //print(nextEvent);
                                                        return Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Center(),
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    ExpandableNotifier(
                                                                  child:
                                                                      ScrollOnExpand(
                                                                    child:
                                                                        ExpandablePanel(
                                                                      //header: Text(article.title),
                                                                      collapsed:
                                                                          Text(
                                                                        currentBody,
                                                                        style: TextStyle(
                                                                            color:
                                                                                color.secondaryTextColor),
                                                                        softWrap:
                                                                            true,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      hasIcon:
                                                                          true,
                                                                      iconColor:
                                                                          color
                                                                              .secondaryTextColor,
                                                                      tapBodyToCollapse:
                                                                          true,
                                                                      tapHeaderToExpand:
                                                                          true,
                                                                      iconPlacement:
                                                                          ExpandablePanelIconPlacement
                                                                              .right,

                                                                      expanded:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            currentBody,
                                                                            style:
                                                                                TextStyle(
                                                                              color: color.secondaryTextColor,
                                                                            ),
                                                                            softWrap:
                                                                                true,
                                                                          ),
                                                                          Image(
                                                                            image:
                                                                                NetworkImage(currentImage),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                // child: Text(
                                                                //   currentBody,
                                                                //   style:
                                                                //       TextStyle(
                                                                //     fontSize:
                                                                //         21,
                                                                //   ),
                                                                // ),
                                                              ),
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.push(
                                                                        context,
                                                                        new MaterialPageRoute(
                                                                            builder: (context) => AnnouncementsRoute(
                                                                                email,
                                                                                profilePic,
                                                                                name)));
                                                                  },
                                                                  child: Text(
                                                                    'Show All',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ))
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            ])),
                                      ))
                                ]))
                          ]))
                    ])
                  ])))
            ])));
  }
}

class RegisterRoute extends StatelessWidget {
  final email;

  const RegisterRoute({Key key, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.secondaryColor,
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.of(context).pushReplacementNamed('/home');
          },
          child: Text(
              'I Acknoleged (I know i spelled it wrong) this bloody works'),
        ),
      ),
    );
  }
}

class LunchCheckInRoute extends StatelessWidget {
  LunchCheckInRoute(this.email);
  final email;
  String uID;
  DocumentReference snapshot;

  Future getuid() async {
    var document =
        await FirebaseFirestore.instance.collection('users').doc(email);
    document.get().then((document) {
      //print(document);
      uID = document.data()['utsavID'];
    });
  }

  bool isUID = false;

  //getuid();

  @override
  Widget build(BuildContext context) {
    getuid().then((value) => isUID = true);
    //print(email);
    return Scaffold(
      backgroundColor: color.secondaryColor,
      appBar: AppBar(
        title: Text('Check In'),
        backgroundColor: color.primaryColor,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              email,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  //Text('FIX ME'),
                  //Text('BAD UTSAV ID'),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Text("Loading");
                        }
                        uID = snapshot.data["utsavID"];
                        return new Text(uID);
                      }),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to first route when tapped.
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Done'),
            ),
            SizedBox(
              height: 50,
            ),
            StreamBuilder<Object>(
                stream: Firestore.instance
                    .collection('users')
                    .document(email)
                    .snapshots(),
                builder: (context, snapshot) {
                  String qrData = email + ' ' + uID;
                  // String qrData = email;
                  return !snapshot.hasData || !isUID
                      ? const Text('Loading...')
                      : QrImage(
                          data: qrData, //snapshot.data["utsavID"].toString(),
                          embeddedImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/project-delta-db6b3.appspot.com/o/utsav_logo_edited-ConvertImage.png?alt=media&token=f7932df8-43ac-4413-96e6-044d748a1eea'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(55, 70),
                          ),
                          size: 200,
                          version: 5,
                        );
                }),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(email)
                    .collection('tickets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return SingleChildScrollView(
                    child: Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Card(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 4,
                              color: color.secondaryLightColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                          snapshot.data.documents[index]
                                              ['name'],
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(snapshot
                                          .data.documents[index]['quantity']
                                          .toString())
                                    ],
                                  )));
                        },
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class AccountRoute extends StatefulWidget with ChangeNotifier {
  final String authToken;
  final String email;
  final AuthService google;
  final String profilePic;
  final String name;

  AccountRoute(
      this.authToken, this.email, this.google, this.profilePic, this.name);
  @override
  _AccountRouteState createState() =>
      _AccountRouteState(authToken, email, authService, profilePic, name);
}

class _AccountRouteState extends State<AccountRoute> {
  var membershipName = 'I See You Got Help';

  final String profilePic;
  final String authToken;
  final String email;
  final String name;
  final AuthService google;
  _AccountRouteState(
      this.authToken, this.email, this.google, this.profilePic, this.name);

  var num = 0;

  var constantText = 'ya this is constant!';

  var requestID;

  //TODO: Put pay() in the designated page

  void _pay() {
    // InAppPayments.setSquareApplicationId('sq0idp-BMmW1tjTRhOTjAa_fSQ2EQ');
    // InAppPayments.startCardEntryFlow(
    //   onCardNonceRequestSuccess: _cardNonceRequestSuccess,
    //   onCardEntryCancel: _cardEntryCancel,
    // );
  }

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not go to $url';
    }
  }

  // void _cardEntryCancel() {}

  // void _cardNonceRequestSuccess(credit.CardDetails result) {
  //   print('\n\n\nSuccess');
  //   print(result.nonce);
  //   //print(result.card);
  //   print('\n\n\n');

  //   InAppPayments.completeCardEntry(
  //     onCardEntryComplete: _onCardEntryComplete,
  //   );
  // }

  // void _onCardEntryComplete() {
  //   print("success!!!!");
  // }

  Future<void> _changeUtsavId(BuildContext context) {
    String newUtsavId = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Current Utsav ID'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          return showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('How to find your Utsav ID'),
                                content: Container(
                                  height: 150,
                                  child: Column(
                                    children: <Widget>[
                                      const Text('Just Do It!'),
                                      Image.network(
                                          'https://www.budgetsaresexy.com/images/just-do-it-gif.gif')
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Where to find my Utsav ID?',
                          style: TextStyle(color: Colors.blue, fontSize: 13),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'New Utsav ID', hintText: 'e.g. 123456'),
                      onChanged: (value) {
                        newUtsavId = value;
                      },
                    ),
                  ],
                ),
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('CONFIRM'),
              onPressed: () {
                var snapshot =
                    FirebaseFirestore.instance.collection('users').doc(email);
                snapshot.update({'utsavID': newUtsavId});
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final url = 'https://project-delta-db6b3.firebaseio.com/test_1.json?auth=$authToken';
    return MaterialApp(
        theme: new ThemeData(
          primaryColor: color.primaryColor,
          primaryColorLight: color.primaryLightColor,
          primaryColorDark: color.primaryDarkColor,
          secondaryHeaderColor: color.secondaryColor,
        ),
        home: Scaffold(
            backgroundColor: color.secondaryColor,
            drawer: Drawer(
              child: Container(
                color: color.secondaryLightColor,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(name),
                      accountEmail: Text(email),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                      ),
                    ),
                    ListTile(
                      title: Text('Home',
                          style: TextStyle(color: color.secondaryTextColor)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),
                    ListTile(
                      title: Text('Schedule',
                          style: TextStyle(color: color.secondaryTextColor)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/schedule');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'My Account',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Contact Us',
                          style: TextStyle(color: color.secondaryTextColor)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/contact');
                      },
                    ),
                    ListTile(
                      title: Text('Settings',
                          style: TextStyle(color: color.secondaryTextColor)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/settings');
                      },
                    ),
                    // ListTile(
                    //   title: Text('Volunteer'),
                    //   onTap: () {
                    //     Navigator.of(context).pushReplacementNamed('/volunteer');
                    //   },
                    // ),
                    ListTile(
                      title: Text('About',
                          style: TextStyle(color: color.secondaryTextColor)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/about');
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/settings');
                  },
                ),
              ],
              title: Text('My Account'),
            ),
            body: Stack(children: <Widget>[
              HomePageBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "My Account",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(email)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const Text('Loading...');
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    elevation: 4,
                                    color: color.secondaryLightColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Column(children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              return showDialog<void>(
                                                context: context,
                                                barrierDismissible:
                                                    false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Rewind and remember'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'You will never be satisfied.'),
                                                          Text(
                                                              'You\’re like me. I’m never satisfied.'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('Regret'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                                alignment: Alignment(0, 10),
                                                child: Text(
                                                  email,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.start,
                                                )),
                                          ),
                                          Divider(),
                                          GestureDetector(
                                            onTap: () {
                                              return showDialog<void>(
                                                context: context,
                                                barrierDismissible:
                                                    false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Are you sure?'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'Do you really want to change your password for your ' +
                                                                  email +
                                                                  ' account?'),
                                                          // Image.network(
                                                          //     'https://media2.giphy.com/media/LAKIIRqtM1dqE/giphy.gif'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color: color
                                                                    .primaryColor),
                                                          )),
                                                      RaisedButton(
                                                        child: Text('Confirm'),
                                                        color:
                                                            color.primaryColor,
                                                        highlightColor: color
                                                            .primaryLightColor,
                                                        onPressed: () {
                                                          http.post(
                                                              'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyAfXLxZRkJ-rB00Z9TCrBRdJizZ6AQriH4',
                                                              body: json
                                                                  .encode({
                                                                "requestType":
                                                                    "PASSWORD_RESET",
                                                                "email": email
                                                              }));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                                alignment: Alignment(0, 10),
                                                child: Text(
                                                  'Change Password',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.start,
                                                )),
                                          ),
                                          Divider(),
                                          GestureDetector(
                                            onLongPress: () {
                                              _changeUtsavId(context);
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Utsav ID',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Container(
                                                  child: snapshot.data[
                                                              "utsavID"] ==
                                                          null
                                                      ? Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Set Up Utsav ID Required",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                'Tap and hold to set up',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15))
                                                          ],
                                                        )
                                                      : Text(
                                                          snapshot
                                                              .data["utsavID"],
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            'My Memberships',
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.start,
                                          ),
                                          Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      top: 10),
                                              child: Text(
                                                membershipName,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              )),
                                          Divider(),
                                          OutlineButton(
                                            child: Text('Buy Membership'),
                                            // onPressed: _pay,
                                            onPressed: () {
                                              if (Platform.isAndroid) {
                                                _launchInApp(
                                                    'https://www.utsavsac.org/membership');
                                              } else if (Platform.isIOS) {
                                                var snakbar = SnackBar(
                                                    content: Text(
                                                        'This is Not Supported on iOS'));
                                                Scaffold.of(context)
                                                    .showSnackBar(snakbar);
                                              }
                                            },
                                          ),
                                          Divider(),
                                          OutlineButton(
                                            // onPressed: () {
                                            //   print(authToken);
                                            //   http
                                            //       .post(
                                            //     'https://project-delta-db6b3.firebaseio.com/test_1.json?auth=$authToken',
                                            //     body: json.encode({
                                            //       'title': constantText,
                                            //       'ID': num++,
                                            //     }),
                                            //   )
                                            //       .then((response) {
                                            //     var requestID = json
                                            //         .decode(response.body)['name'];
                                            //     return showDialog<void>(
                                            //       context: context,
                                            //       barrierDismissible:
                                            //           false, // user must tap button!
                                            //       builder: (BuildContext context) {
                                            //         return AlertDialog(
                                            //           title: Text('Task Completed'),
                                            //           content: SingleChildScrollView(
                                            //             child: ListBody(
                                            //               children: <Widget>[
                                            //                 Text(
                                            //                     'Your Data Transfer to Your Server is Complete'),
                                            //                 SizedBox(
                                            //                   height: 10,
                                            //                 ),
                                            //                 Image.network(
                                            //                     'https://thumbs.gfycat.com/ImpishChiefAlaskanmalamute-small.gif'),
                                            //                 Text(
                                            //                     'Your Request ID is' +
                                            //                         '$requestID')
                                            //               ],
                                            //             ),
                                            //           ),
                                            //           actions: <Widget>[
                                            //             FlatButton(
                                            //               child: Text('OK'),
                                            //               onPressed: () {
                                            //                 Navigator.of(context)
                                            //                     .pop();
                                            //               },
                                            //             ),
                                            //           ],
                                            //         );
                                            //       },
                                            //     );
                                            //   });
                                            // },
                                            onPressed: () async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.clear();
                                              await authService.signOut();
                                              Phoenix.rebirth(context);
                                            },
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            textColor: Colors.red,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        100.0)),
                                            highlightedBorderColor: Colors.red,
                                          ),
                                        ])),
                                  );
                                }))
                      ],
                    ),
                  ])))
            ])));
  }
}

class ScheduleRoute extends StatefulWidget {
  final String email;
  final String profilePic;
  final String name;

  const ScheduleRoute(this.email, this.profilePic, this.name);
  @override
  _ScheduleRouteState createState() =>
      _ScheduleRouteState(email, profilePic, name);
}

class _ScheduleRouteState extends State<ScheduleRoute> {
  int index;
  final String email;
  final String profilePic;
  final String name;

  _ScheduleRouteState(this.email, this.profilePic, this.name);
  Future<List<Events>> _getEvents() async {
    var data = await http.get(
        "https://firebasestorage.googleapis.com/v0/b/project-delta-db6b3.appspot.com/o/generated.json?alt=media");
    var jsonData = json.decode(data.body);

    List<Events> events = [];

    for (var e in jsonData) {
      Events event = Events(e["imageUrl"], e["body"], e["name"], e["time"],
          e["index"], e['delay']);

      events.add(event);
    }

    //print(events.length);
    //print(events[0].name);
    return events;
  }

  Widget _buildScheduleEvent(BuildContext context, int index) {
    return Card(
        child: Row(
      children: <Widget>[
        Text('Name'),
        SizedBox(
          width: 20,
        ),
        Text('Time')
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          primaryColor: color.primaryColor,
          primaryColorLight: color.primaryLightColor,
          primaryColorDark: color.primaryDarkColor,
          secondaryHeaderColor: color.secondaryColor,
        ),
        home: Scaffold(
            backgroundColor: color.secondaryColor,
            drawer: Drawer(
              child: Container(
                color: color.secondaryLightColor,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(name),
                      accountEmail: Text(email),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Home',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Schedule',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'My Account',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/account');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Contact Us',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/contact');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/settings');
                      },
                    ),
                    // ListTile(
                    //   title: Text('Volunteer'),
                    //   onTap: () {
                    //     Navigator.of(context).pushReplacementNamed('/volunteer');
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/about');
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/account');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/settings');
                  },
                ),
              ],
              title: Text('Utsav Events'),
            ),
            body: Stack(children: <Widget>[
              HomePageBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              Container(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "Schedule ",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            /*Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                child: */
                            BodyLayout() /* //Padding(
                                //padding: const EdgeInsets.all(8.0),
                                //child:
                                //print(snapshot.data.length);
                                //print(snapshot.data[0].name);
                                /*Expanded(
                                child: FutureBuilder(
                                    future: _getEvents(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.data == null) {
                                        return Container(
                                            padding: EdgeInsets.all(20),
                                            child: CircularProgressIndicator(
                                              backgroundColor: primaryDarkColor,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(primaryLightColor),
                                            ));
                                      } else {
                                        print(snapshot.data.length);
                                        print(snapshot.data[0].name);

                                        return ListView.builder(
                                          itemBuilder: _buildScheduleEvent,
                                          itemCount: snapshot.data.length,
                                        );
                                      }
                                    }),
                              ),*/
                                ),*/
                            //MyApp2()
                          ],
                        ),
                      )
                    ])
                  ])))
            ])));
  }
}

class ContactRoute extends StatelessWidget {
  Future<void> _launched;
  String phoneNumber = '';
  final String email;
  String _launchUrl = 'mailto:smith@example.org?subject=News&body=New%20plugin';
  final String profilePic;
  final String name;

  ContactRoute(this.email, this.profilePic, this.name);

  //ContactRoute(User email);

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      throw 'Could not go to $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          primaryColor: Color(0xFFc1451c),
          primaryColorLight: Color(0xFFfa7548),
          primaryColorDark: Color(0xFF8a0e00),
          secondaryHeaderColor: color.secondaryColor,
        ),
        home: Scaffold(
            backgroundColor: color.secondaryColor,
            drawer: Drawer(
              child: Container(
                color: color.secondaryLightColor,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(name),
                      accountEmail: Text(email),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Home',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Schedule',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/schedule');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'My Account',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/account');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Contact Us',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/settings');
                      },
                    ),
                    // ListTile(
                    //   title: Text('Volunteer'),
                    //   onTap: () {
                    //     Navigator.of(context).pushReplacementNamed('/volunteer');
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/about');
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: color.primaryColor,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/account');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
              title: Text('Utsav Events'),
            ),
            body: Stack(children: <Widget>[
              HomePageBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "Contact Us",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: <Widget>[
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 4,
                            color: color.secondaryLightColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'utsavsac.org',
                                    style: TextStyle(
                                        color: color.secondaryTextColor),
                                  ),
                                  RaisedButton(
                                    color: color.primaryColor,
                                    highlightColor: color.primaryLightColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      'Go to our website',
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _launchInApp('https://www.utsavsac.org');
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 4,
                            color: color.secondaryLightColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'utsavpr@gmail.com',
                                    style: TextStyle(
                                        color: color.secondaryTextColor),
                                  ),
                                  RaisedButton(
                                    color: color.primaryColor,
                                    highlightColor: color.primaryLightColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text('Email us',
                                        style: TextStyle(
                                            color: Colors.white)),
                                    onPressed: () {
                                      _launchInApp(
                                          'mailto:utsavpr@gmail.com?subject=Beta%20Tester');
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            elevation: 4,
                            color: color.secondaryLightColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    '916-294-5088',
                                    style: TextStyle(
                                        color: color.secondaryTextColor),
                                  ),
                                  RaisedButton(
                                      color: color.primaryColor,
                                      highlightColor: color.primaryLightColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text('Call us',
                                          style: TextStyle(
                                              color: Colors.white)),
                                      onPressed: () {
                                        _launchInApp('tel:+1 916 294 5088');
                                      } //_launchCaller(),
                                      )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ])))
            ])));
  }
}

class SettingsRoute extends StatelessWidget {
  final String email;
  final String profilePic;
  final String name;
  //final screenHeight;
  const SettingsRoute(
      /*this.screenHeight*/ this.email,
      this.profilePic,
      this.name);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
          primaryColor: Color(0xFFc1451c),
          primaryColorLight: Color(0xFFfa7548),
          primaryColorDark: Color(0xFF8a0e00),
          secondaryHeaderColor: color.secondaryColor,
        ),
        home: Scaffold(
            backgroundColor: color.secondaryColor,
            drawer: Drawer(
              child: Container(
                color: color.secondaryLightColor,
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(name),
                      accountEmail: Text(email),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Home',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Schedule',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/schedule');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'My Account',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/account');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Contact Us',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/contact');
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {},
                    ),
                    // ListTile(
                    //   title: Text('Volunteer'),
                    //   onTap: () {
                    //     Navigator.of(context).pushReplacementNamed('/volunteer');
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(color: color.secondaryTextColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/about');
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: color.primaryColor,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/account');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
              title: Text('Utsav Events'),
            ),
            body: Stack(children: <Widget>[
              HomePageBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ])))
            ])));
  }
}

class SignupStep2 extends StatefulWidget with ChangeNotifier {
  final String authToken;
  final User user;
  SignupStep2(this.authToken, this.user);
  @override
  _SignupStep2State createState() => _SignupStep2State(authToken, user);
}

class _SignupStep2State extends State<SignupStep2> {
  //final _utsavId = TextEditingController();
  final String authToken;
  final User user;
  _SignupStep2State(this.authToken, this.user);
  final GlobalKey<FormState> _formKey = GlobalKey();
  final utsavIDC = TextEditingController();
  String _utsavID = 'undefined';
  String _name = '';
  String _phoneNumber = '';
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    transformConfig.translate(-10.0);
    var utsavID;
    return Scaffold(
      backgroundColor: color.secondaryColor,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        key: utsavID,
                        flex: deviceSize.width > 600 ? 2 : 1,
                        child: Card(
                          color: color.secondaryLightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 8.0,
                          child: Container(
                            height: 320,
                            constraints: BoxConstraints(minHeight: 340),
                            width: deviceSize.width * 0.75,
                            padding: EdgeInsets.all(16.0),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                                  Text(
                                    'Personal Details',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: color.primaryDarkColor),
                                  ),
                                  TextField(
                                    key: utsavID,
                                    style: TextStyle(color: Colors.white),
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration(labelText: 'Utsav ID', labelStyle: TextStyle(color: Colors.white)),
                                    controller: utsavIDC,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Where to find your Utsav ID'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                        'If you are a member, you got your Utsav ID number on your card. If you are a guest, you got an email with it. If you cant find it in your E-Mail, check the Spam Folder.'),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Image.network(
                                                        'https://www.google.com/url?sa=i&url=https%3A%2F%2Ftenor.com%2Fsearch%2Fi-dont-know-gifs&psig=AOvVaw35QbwAEL5xjJOUfB7ivPTo&ust=1575228793203000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCNjZ-dzWkuYCFQAAAAAdAAAAABAD'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    utsavID.currentState.save();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Where can I find my Utsav ID?',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.blue),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    onSubmitted: (value) => _name = value,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(color: Colors.white),
                                    decoration:
                                        InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        labelText: 'Phone Number', labelStyle: TextStyle(color: Colors.white), ),
                                    onSubmitted: (value) =>
                                        _phoneNumber = value,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                            color: color.secondaryColor),
                                      ),
                                      color: color.primaryColor,
                                      highlightColor: color.primaryLightColor,
                                      onPressed: () async {
                                        //print(_phoneNumber.toString());
                                        //print(_name.toString());
                                        //print(utsavIDC.text);
                                        //final url = 'https://project-delta-db6b3.firebaseio.com/extra_details.json?auth=$authToken';
                                        //String id = _utsavID.toString();
                                        //await http.post(
                                        //    'https://project-delta-db6b3.firebaseio.com/extra_details/id/secondstepinfo.json?auth=$authToken',
                                        //    body: json.encode({
                                        //      'utsavID': _utsavID,
                                        //      'name': _name,
                                        //      'phoneNumber': _phoneNumber,
                                        //    }));
                                        // final CollectionReference users =
                                        //     Firestore.instance
                                        //         .collection('users');
                                        // Firestore.instance.runTransaction(
                                        //     (Transaction transaction) async {
                                        //   CollectionReference reference =
                                        //       Firestore.instance
                                        //           .collection('users');

                                        //   await reference.add({
                                        //     "name": _name,
                                        //     "PhoneNumber": _phoneNumber,
                                        //     "utsavID": utsavID
                                        //   });
                                        // });
                                        final databaseReference =
                                            FirebaseFirestore.instance;
                                        try {
                                          databaseReference
                                              .collection('users')
                                              .doc(user.email)
                                              .set({
                                            'phoneNumber': _phoneNumber,
                                            'utsavID': utsavIDC.text,
                                            'name': _name
                                          });
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                        Navigator.pushNamed(context, '/home');
                                      })
                                ]),
                              ),
                            ),
                          ),
                        ))
                  ],
                ))));
  }

  void utsavIdController(value2) {
    setState(() {
      _utsavID = value2;
    });
  }
}

class Notification extends StatelessWidget {
  final String appTitle;

  const Notification({this.appTitle});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Utsav Events'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MessagingWidget(),
        ),
      );
}

class HalfCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 1.455, size.height / 350), radius: 210),
        3.14,
        -3.14,
        false,
        customPaint());
    //canvas.drawPath(getTrianglePath(size,20, 15), customPaint());
  }

  //Path getTrianglePath(Size size,double x, double y) {
  //  return Path()
  //    ..moveTo(size.width/2, 0)
  //    ..lineTo(size.width/2+x, y)
  //    ..lineTo(size.width/2, y)
  //    ..lineTo(size.width/2-x, y);
  //}

  Paint customPaint() {
    Paint paint = Paint();
    paint.color = color.primaryColor;
    paint.isAntiAlias = true;
    paint.strokeWidth = 10;
    return paint;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.85);
    Offset curveEndPoint = Offset(size.width, size.height * 0.85);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(
        size.width / 2, size.height, curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HomePageBackground extends StatelessWidget {
  final screenHeight;
  const HomePageBackground({Key key, @required this.screenHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ClipPath(
      clipper: BottomShapeClipper(),
      child: Container(
        height: screenHeight * 0.5,
        color: themeData.primaryColor,
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListViews')),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _myFSListView(context),
      ],
    );
  }
}

Widget _myListView(BuildContext context) {
  Future<List<Events>> _getEvents() async {
    var data = await http.get(
        "https://firebasestorage.googleapis.com/v0/b/project-delta-db6b3.appspot.com/o/generated.json?alt=media");
    var jsonData = json.decode(data.body);

    List<Events> events = [];

    for (var e in jsonData) {
      Events event = Events(e["imageUrl"], e["body"], e["name"], e["time"],
          e["index"], e['delay']);

      events.add(event);
    }

    //print(events.length);
    //print(events[0].name);
    return events;
  }

  return FutureBuilder(
      future: _getEvents(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                backgroundColor: color.primaryDarkColor,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(color.primaryLightColor),
              ));
        } else {
          //print(snapshot.data.length);
          // print(snapshot.data[0].name);
          return Container(
            height: 10000,
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (ctx, index) {
                return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                    color: color.secondaryLightColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          Text(snapshot.data[index].name,
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 40,
                          ),
                          Text('time')
                        ],
                      ),
                    ));
              },
            ),
          );
          //return
          /*return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(snapshot.data[index].name, style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 40,),
            Text('time')
          ],
        ),
      ),
    ),
                );
              });*/
        }
      });
}

Widget _myFSListView(BuildContext context) {
  return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Schedule').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  padding: EdgeInsets.all(21),
                  child: CircularProgressIndicator(
                    backgroundColor: color.primaryDarkColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        color.primaryLightColor),
                  ));

            List<Events> myEventList = [];
            //for (int i = 0; i < snapshot.data.documents.length; i++) {
            // List<Events> myEventList = [];
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              Events _event = Events(
                snapshot.data.documents[i]['name'],
                DateTime.parse(snapshot.data.documents[i]['time']),
                snapshot.data.documents[i]['index'],
                snapshot.data.documents[i]['delay'],
                snapshot.data.documents[i]['body'],
                snapshot.data.documents[i]['imageUrl'],
              );

              myEventList.add(_event);
            }

            myEventList.sort((a, b) => a.time.compareTo(b.time));
            //snapshot.data.documents.sort((a, b) => (a['index'] - b['indsex'])); //sort the items based on "index"
            //print('im here');
            //print("first name is = " + myEventList[0].name);

            return Container(
                height: 555,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    SchedulePage(myEventList[index])));
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                        color: color.secondaryLightColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 200,
                                child: Text(myEventList[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    textWidthBasis: TextWidthBasis.parent,
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                DateFormat('E hh:mm a')
                                    .format(myEventList[index].time)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: color.secondaryTextColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ));

            /*ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) {
                  return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: <Widget>[
                            Text(snapshot.data[index].name,
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 40,
                            ),
                            Text('time')
                          ],
                        ),
                      ));
                },),*/
          }));

  //return
  /*return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(snapshot.data[index].name, style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 40,),
            Text('time')
          ],
        ),
      ),
    ),
                );
              });*/
}

//yes it is 785 lines of code
