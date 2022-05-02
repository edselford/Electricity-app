import 'package:electric_charge_note/views/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:electric_charge_note/widgets/status_bar_color.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('notes');

  runApp(const ElectricalNote());
}

class ElectricalNote extends StatelessWidget {
  const ElectricalNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electric Notes',
      darkTheme: ThemeData(
        secondaryHeaderColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        primaryColor: const Color.fromARGB(255, 41, 41, 44),
        brightness: Brightness.dark,
        fontFamily: 'SF UI',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 37,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          headline3: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
          headline4: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
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
        ),
      ),
      theme: ThemeData(
        secondaryHeaderColor: const Color.fromARGB(255, 14, 14, 14),
        brightness: Brightness.light,
        backgroundColor: const Color(0xffF8F8F8),
        primaryColor: Colors.white,
        fontFamily: 'SF UI',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 37,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
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
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeMenu(),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: const HomeScreen(),
    );
  }
}
