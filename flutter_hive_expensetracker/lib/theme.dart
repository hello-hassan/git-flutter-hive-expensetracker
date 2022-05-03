import 'package:flutter/material.dart';


MaterialColor PrimaryMaterialColor = MaterialColor(
  4288479487,
  <int, Color>{
    50: Color.fromRGBO(
      157,
      0,
      255,
      .1,
    ),
    100: Color.fromRGBO(
      157,
      0,
      255,
      .2,
    ),
    200: Color.fromRGBO(
      157,
      0,
      255,
      .3,
    ),
    300: Color.fromRGBO(
      157,
      0,
      255,
      .4,
    ),
    400: Color.fromRGBO(
      157,
      0,
      255,
      .5,
    ),
    500: Color.fromRGBO(
      157,
      0,
      255,
      .6,
    ),
    600: Color.fromRGBO(
      157,
      0,
      255,
      .7,
    ),
    700: Color.fromRGBO(
      157,
      0,
      255,
      .8,
    ),
    800: Color.fromRGBO(
      157,
      0,
      255,
      .9,
    ),
    900: Color.fromRGBO(
      157,
      0,
      255,
      1,
    ),
  },
);

ThemeData myTheme = ThemeData(
  //fontFamily: "customFont",
  primaryColor: Color(0xff9d00ff),
  primarySwatch: PrimaryMaterialColor,
);
