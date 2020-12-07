import 'package:flutter/material.dart';
import './colortheme.dart';

class SplashScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.secondaryColor,
      body: Center(
        child: Text('Loading...', style: TextStyle(color: color.secondaryTextColor),),
      ),
    );
  }
}
