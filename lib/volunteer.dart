import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:square_in_app_payments/models.dart';

import 'colortheme.dart';
import 'main.dart';

class Sender {
  final int id;
  final String name;
  final String imageUrl;

  Sender({
    this.id,
    this.name,
    this.imageUrl,
  });
}

class Message {
  final Sender sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;
  final String multimedia;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.multimedia,
  });
}

// YOU - current user
final Sender currentUser = Sender(
    id: 0,
    name: 'Current User',
    imageUrl:
        'https://siliconangle.com/files/2013/08/1374633424543-300x300.jpg');

final Sender greg = Sender(
  id: 1,
  name: 'Greg',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/female/female1022886224396.jpg',
);
final Sender james = Sender(
  id: 2,
  name: 'James',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/male/male20161086442295044.jpg',
);
final Sender john = Sender(
  id: 3,
  name: 'John',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/female/female20161025525766968.jpg',
);
final Sender olivia = Sender(
  id: 4,
  name: 'Olivia',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/male/male1084822683533.jpg',
);
final Sender sam = Sender(
  id: 5,
  name: 'Sam',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/male/male108444239368.jpg',
);
final Sender sophia = Sender(
  id: 6,
  name: 'Sophia',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/female/female20161025515364441.jpg',
);
final Sender steven = Sender(
  id: 7,
  name: 'Steven',
  imageUrl:
      'https://www.fakepersongenerator.com/Face/female/female1022615370972.jpg',
);

// FAVORITE CONTACTS
List<Sender> favorites = [sam, steven, olivia, john, greg];

class VolunteerRoute extends StatelessWidget {
  VolunteerRoute(this.email, this.profilePic, this.name);
  final email;
  final profilePic;
  final name;
  int submittedAccessPin;
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
            drawer: Drawer(
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
                    title: Text('Home'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                  ListTile(
                    title: Text('Schedule'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/schedule');
                    },
                  ),
                  ListTile(
                    title: Text('My Account'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/account');
                    },
                  ),
                  ListTile(
                    title: Text('Contact Us'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/contact');
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/settings');
                    },
                  ),
                  ListTile(
                      title: Text(
                        'Volunteer',
                        style: TextStyle(color: color.primaryDarkColor),
                      ),
                      onTap: () {}),
                  ListTile(
                    title: Text('About'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/about');
                    },
                  ),
                ],
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
                        "Volunteer",
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
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                    'In order to get to the volunteer chat, you must enter the access pin below given to you by an admin'),
                              )),
                          Card(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: <Widget>[
                                      TextField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(),
                                        maxLength: 6,
                                        onSubmitted: (value) {
                                          submittedAccessPin = int.parse(value);
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      RaisedButton(
                                          child: Text(
                                            'Done',
                                            style: TextStyle(
                                                color: color.secondaryColor),
                                          ),
                                          color: color.primaryColor,
                                          onPressed: () {
                                            if (submittedAccessPin == 666666) {
                                              Navigator.of(context)
                                                  .pushNamed('/volunteerchat');
                                              print('it worked');
                                            }
                                          })
                                    ],
                                  )))
                        ]))
                  ])))
            ])));
  }
}

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Online', 'Groups', 'Requests'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 90,
      color: color.primaryColor,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: Text(
                  categories[index],
                  style: TextStyle(
                      color: index == selectedIndex
                          ? color.secondaryColor
                          : Colors.white60,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
              ),
            );
          }),
    );
  }
}

class FavoriteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                )
              ],
            ),
          ),
          Container(
              height: 120,
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                      chatroomId: favorites[index],
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 35.0,
                                backgroundImage:
                                    NetworkImage(favorites[index].imageUrl),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                favorites[index].name,
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ));
                  }))
        ],
      ),
    );
  }
}

class RecentChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                final Message chat = chats[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(
                                chatroomId: chat.sender,
                              ))),
                  child: Container(
                    decoration: BoxDecoration(
                        color: chat.unread ? Color(0xFFFFEFEE) : Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0))),
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  NetworkImage(chat.sender.imageUrl),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  chat.sender.name,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    chat.text,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              chat.time,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            chat.unread
                                ? Container(
                                    width: 40.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: color.primaryLightColor),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'NEW',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ))
                                : Text('')
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class VolunteerChatRoute extends StatelessWidget {
  VolunteerChatRoute(this.email, this.profilePic, this.name);
  final String email;
  final String profilePic;
  final String name;

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
          backgroundColor: color.primaryColor,
          drawer: Drawer(
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
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                ListTile(
                  title: Text('Schedule'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/schedule');
                  },
                ),
                ListTile(
                  title: Text('My Account'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/account');
                  },
                ),
                ListTile(
                  title: Text('Contact Us'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/contact');
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/settings');
                  },
                ),
                ListTile(
                    title: Text(
                      'Volunteer',
                      style: TextStyle(color: color.primaryDarkColor),
                    ),
                    onTap: () {}),
                ListTile(
                  title: Text('About'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/about');
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.search), onPressed: () {})
              ],
              elevation: 0.0,
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
              title:
                  Text('Chats', style: TextStyle(fontWeight: FontWeight.bold))),
          body: Column(
            children: <Widget>[
              CategorySelector(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFFEF9EB),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(
                    children: <Widget>[
                      FavoriteContacts(),
                      RecentChats(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class ChatScreen extends StatefulWidget {
  final Sender chatroomId;

  ChatScreen({this.chatroomId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Color(0xFFFEF9EB) : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        // IconButton(
        //   icon: message.isLiked
        //       ? Icon(Icons.favorite)
        //       : Icon(Icons.favorite_border),
        //   iconSize: 30.0,
        //   color: message.isLiked
        //       ? primaryColor
        //       : Colors.blueGrey,
        //   onPressed: () {},
        // )
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: color.primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: color.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.chatroomId.name.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_horiz),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {})
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = messages[index];
                      bool isMe = message.sender.id == currentUser.id;
                      return _buildMessage(message, isMe);
                    }),
              ),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }
}

List<Message> chats = [
  Message(
      sender: james,
      time: '5:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: true,
      multimedia: ''),
  Message(
      sender: olivia,
      time: '4:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: true,
      multimedia: ''),
  Message(
      sender: john,
      time: '3:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: false,
      multimedia: ''),
  Message(
      sender: sophia,
      time: '2:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: true,
      multimedia: ''),
  Message(
      sender: steven,
      time: '1:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: false,
      multimedia: ''),
  Message(
      sender: sam,
      time: '12:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: false,
      multimedia: ''),
  Message(
      sender: greg,
      time: '11:30 AM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: false,
      unread: false,
      multimedia: ''),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
      sender: james,
      time: '5:30 PM',
      text: 'Hey, how\'s it going? What did you do today?',
      isLiked: true,
      unread: true,
      multimedia: ''),
  Message(
      sender: currentUser,
      time: '4:30 PM',
      text: 'Just walked my doge. She was super duper cute. The best pupper!!',
      isLiked: false,
      unread: true,
      multimedia: ''),
  Message(
      sender: james,
      time: '3:45 PM',
      text: 'How\'s the doggo?',
      isLiked: false,
      unread: true,
      multimedia: ''),
  Message(
      sender: james,
      time: '3:15 PM',
      text: 'All the food',
      isLiked: true,
      unread: true,
      multimedia: ''),
  Message(
      sender: currentUser,
      time: '2:30 PM',
      text: 'Nice! What kind of food did you eat?',
      isLiked: false,
      unread: true,
      multimedia: ''),
  Message(
      sender: james,
      time: '2:00 PM',
      text: 'I ate so much food today.',
      isLiked: false,
      unread: true,
      multimedia: ''),
];
