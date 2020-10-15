import 'package:flutter/material.dart';
import 'package:project_delta/colortheme.dart';
import 'package:project_delta/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutRoute extends StatelessWidget {
  final String email;
  final String profilePic;
  final String name;
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

  AboutRoute(this.email, this.profilePic, this.name);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                color: color.secondaryColor,
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
                      title: Text('Home', style: TextStyle(color: color.secondaryTextColor),),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                    ListTile(
                      title: Text('Schedule', style: TextStyle(color: color.secondaryTextColor),),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/schedule');
                      },
                    ),
                    ListTile(
                      title: Text('My Account', style: TextStyle(color: color.secondaryTextColor),),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/account');
                      },
                    ),
                    ListTile(
                      title: Text('Contact Us', style: TextStyle(color: color.secondaryTextColor),),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/contact');
                      },
                    ),
                    ListTile(
                      title: Text('Settings', style: TextStyle(color: color.secondaryTextColor),),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/settings');
                      },
                    ),
                    // ListTile(
                    //     title: Text(
                    //       'Volunteer',
                    //     ),
                    //     onTap: () {
                    //       Navigator.of(context)
                    //           .pushReplacementNamed('/volunteer');
                    //     }),
                    ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {},
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
                        "About",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(children: <Widget>[
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
                                    children: <Widget>[
                                      Image.asset(
                                        'logo.jpg',
                                        height: 40,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          'This application is created and owned by KidsonX \n\nCopyright© KidsonX 2020. All Rights Reserved\n\nPatent Pending.'
                                          , style: TextStyle(color: color.secondaryTextColor),
                                          ),
                                    ],
                                  ))),
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
                                  Text('Email us at: kidsonx.pr@gmail.com', style: TextStyle(color: color.secondaryTextColor),),
                                  RaisedButton(
                                    color: color.primaryColor,
                                    highlightColor: color.primaryLightColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      'Email us',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _launchInApp(
                                          'mailto:kidsonx.pr@gmail.com?subject=Beta%20Tester');
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ]))
                  ])))
            ])));
  }
}
