import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;

ThemeData lightTheme = ThemeData(
  secondaryHeaderColor: const Color.fromARGB(255, 14, 14, 14),
  brightness: Brightness.light,
  backgroundColor: const Color(0xffF8F8F8),
  primaryColor: Colors.white,
  fontFamily: 'Product',
  textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 37,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headline2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
      headline3: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
      headline6: TextStyle(color: CupertinoColors.black),
      bodyText1: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Color(0xffA0A0A3),
      ),
      headline5: TextStyle(color: Color(0xff1f8ee6), fontSize: 17)),
);

ThemeData darkTheme = ThemeData(
  secondaryHeaderColor: const Color.fromARGB(255, 255, 255, 255),
  backgroundColor: const Color.fromARGB(255, 29, 29, 29),
  primaryColor: const Color.fromARGB(255, 41, 41, 44),
  brightness: Brightness.dark,
  fontFamily: 'Product',
  textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 37,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Color(0xffA0A0A3),
      ),
      headline5: TextStyle(color: Color(0xff1f8ee6), fontSize: 17)),
);
