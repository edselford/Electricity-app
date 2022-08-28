import 'package:electric_charge_note/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:electric_charge_note/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('notes');
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ElectricalNote());
}

class ElectricalNote extends StatelessWidget {
  const ElectricalNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electric Notes',
      darkTheme: darkTheme,
      theme: lightTheme,
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
