import 'package:flutter/material.dart';
import 'package:project_delta/events.dart';
import 'colortheme.dart';

class SchedulePage extends StatelessWidget {
  final Events event;

  SchedulePage(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.secondaryColor,
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Column(
        children: <Widget>[
          Image.network(event.imageUrl
              //'https://i.chzbgr.com/full/1219333376/h91D42DAC/placeholder'
              ),
          Card(
              margin: const EdgeInsets.symmetric(vertical: 12),
              elevation: 4,
              color: color.secondaryLightColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        event.delay,
                        style: TextStyle(
                            color: event.delay == 'On Time'
                                ? Colors.green
                                : event.delay == 'Late'
                                    ? Colors.red
                                    : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontStyle: FontStyle.normal),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(event.body, style: TextStyle(color: color.secondaryTextColor),
                          //'I spend a lot of time walking around in the woods and talking to trees, and squirrels, and little rabbits and stuff. You can create the world you want to see and be a part of. You have that power. The only prerequisite is that it makes you happy. If it makes you happy then it\'s good.  You\'re meant to have fun in life. I like to beat the brush. The shadows are just like the highlights, but we\'re going in the opposite direction. We artists are a different breed of people. We\'re a happy bunch.'),
                          ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
