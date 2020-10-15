import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

colorInit(colorTxt) {
  bool darkModeOn = false;

  var brightness = SchedulerBinding.instance.window.platformBrightness;
  darkModeOn = brightness == Brightness.dark;
  if (darkModeOn) {
    print('Dark Mode Activated for ${colorTxt}');
    var colors = <String, Color>{
      'primaryColor': Color(0xFFc2451d),
      'primaryLightColor': Color(0xFFfb7649),
      'primaryDarkColor': Color(0xFFc21700),
      'secondaryColor': Color(0xFF121212),
      'secondaryDarkColor': Color(0xFF121212),
      'secondaryLightColor': Color(0xFF212121),
      'primaryTextColor': Color(0xFFc2451d),
      'secondaryTextColor': Color(0xFFFFFFFF),
    };
    return colors[colorTxt];
  } else {
    var colors = <String, Color>{
      'primaryColor': Color(0xFFc2451d),
      'primaryLightColor': Color(0xFFfb7649),
      'primaryDarkColor': Color(0xFF8b1000),
      'secondaryColor': Color(0xFFfafafa),
      'secondaryDarkColor': Color(0xFFc7c7c7),
      'secondaryLightColor': Color(0xFFffffff),
      'primaryTextColor': Color(0xFFc2451d),
      'secondaryTextColor': Color(0xFF000000),
    };
    return colors[colorTxt];
  }
}

class ColorTheme {
  // final primaryColor = const Color(0xFFc2451d);
  final primaryColor = colorInit('primaryColor');
  final primaryLightColor = colorInit('primaryLightColor');
  final primaryDarkColor = colorInit('primaryDarkColor');
  final secondaryColor = colorInit('secondaryColor');
  final secondaryLightColor = colorInit('secondaryLightColor');
  final secondaryDarkColor = colorInit('secondaryDarkColor');
  final primaryTextColor = colorInit('primaryTextColor');
  final secondaryTextColor = colorInit('secondaryTextColor');
  // return {primaryColor,  primaryLightColor, primaryDarkColor, secondaryColor, secondaryLightColor, secondaryDarkColor, primaryTextColor, secondaryTextColor}

}

// const primaryColor = const Color(0xFFc2451d);
// const primaryLightColor = const Color(0xFFfb7649);
// const primaryDarkColor = const Color(0xFF8b1000);
// const secondaryColor = const Color(0xFFfafafa);
// const secondaryLightColor = const Color(0xFFffffff);
// const secondaryDarkColor = const Color(0xFFc7c7c7);
// const primaryTextColor = const Color(0xFFc2451d);
// const secondaryTextColor = const Color(0xFFc2451d);

ColorTheme color = ColorTheme();
