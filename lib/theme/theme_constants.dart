import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.cyan[50],
  fontFamily: 'Barlow',
  cardColor: Colors.white,
  textTheme: TextTheme(displayLarge: TextStyle(
    color:Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  ))
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  fontFamily: 'Barlow',
  cardColor: Colors.black,
  textTheme: TextTheme(displayLarge: TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  )),
);