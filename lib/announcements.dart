import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_delta/announcements_model.dart';
import 'package:project_delta/colortheme.dart';
import 'package:project_delta/main.dart';

class AnnouncementsRoute extends StatelessWidget {
  final String email;
  final String profilePic;
  final String name;

  AnnouncementsRoute(this.email, this.profilePic, this.name);
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
            // drawer: Drawer(
            //   child: ListView(
            //     // Important: Remove any padding from the ListView.
            //     padding: EdgeInsets.zero,
            //     children: <Widget>[
            //       UserAccountsDrawerHeader(
            //         accountName: Text(name),
            //         accountEmail: Text(email),
            //         currentAccountPicture: CircleAvatar(
            //           backgroundImage: NetworkImage(profilePic),
            //         ),
            //       ),
            //       ListTile(
            //         title: Text('Home'),
            //         onTap: () {
            //           Navigator.of(context).pushReplacementNamed('/');
            //         },
            //       ),
            //       ListTile(
            //         title: Text('Schedule'),
            //         onTap: () {
            //           Navigator.of(context).pushReplacementNamed('/schedule');
            //         },
            //       ),
            //       ListTile(
            //         title: Text('My Account'),
            //         onTap: () {
            //           Navigator.of(context).pushReplacementNamed('/account');
            //         },
            //       ),
            //       ListTile(
            //         title: Text('Contact Us'),
            //         onTap: () {
            //           Navigator.of(context).pushReplacementNamed('/contact');
            //         },
            //       ),
            //       ListTile(
            //         title: Text('Settings'),
            //         onTap: () {
            //           Navigator.of(context).pushReplacementNamed('/settings');
            //         },
            //       ),
            //       ListTile(
            //           title: Text(
            //             'Volunteer',
            //           ),
            //           onTap: () {
            //             Navigator.of(context)
            //                 .pushReplacementNamed('/volunteer');
            //           }),
            //       ListTile(
            //         title: Text(
            //           'About',

            //         ),
            //         onTap: () {
            //            Navigator.of(context)
            //                 .pushReplacementNamed('/about');
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            appBar: AppBar(
              elevation: 0,
              backgroundColor: color.primaryColor,
              // leading: Builder(
              //   builder: (BuildContext context) {
              //     return IconButton(
              //       icon: const Icon(Icons.menu),
              //       onPressed: () {
              //         Scaffold.of(context).openDrawer();
              //       },
              //       tooltip:
              //           MaterialLocalizations.of(context).openAppDrawerTooltip,
              //     );
              //   },
              // ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
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
                        "Announcements",
                        style: TextStyle(
                            fontSize: 30,
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
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Announcements')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Container(
                                              padding: EdgeInsets.all(21),
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    color.primaryDarkColor,
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        color
                                                            .primaryLightColor),
                                              ));

                                        List<Announcement> myAnnouncementList =
                                            [];
                                        for (int i = 0;
                                            i < snapshot.data.documents.length;
                                            i++) {
                                          Announcement _event = Announcement(
                                              snapshot.data.documents[i]
                                                  ['body'],
                                              snapshot.data.documents[i]
                                                  ['imageUrl'],
                                              snapshot.data.documents[i]
                                                  ['index'],
                                              snapshot.data.documents[i]
                                                  ['time']);

                                          myAnnouncementList.add(_event);
                                        }

                                        myAnnouncementList.sort((a, b) =>
                                            b.index.compareTo(a.index));
                                        //snapshot.data.documents.sort((a, b) => (a['index'] - b['indsex'])); //sort the items based on "index"
                                        //print('im here');
                                        //print("first name is = " + myEventList[0].name);
                                        return Container(
                                          height: 555,
                                          child: ListView.builder(
                                            itemCount:
                                                myAnnouncementList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Column(
                                                children: <Widget>[
                                                  Text(
                                                    myAnnouncementList[index]
                                                        .time,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blueGrey,
                                                        fontSize: 16),
                                                  ),
                                                  Text(myAnnouncementList[index]
                                                      .body),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Image.network(
                                                      myAnnouncementList[index]
                                                          .imageUrl),
                                                  Divider(),
                                                  SizedBox(
                                                    height: 20,
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      })))
                        ]))
                  ])))
            ])));
  }
}
