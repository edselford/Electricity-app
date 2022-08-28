import 'package:flutter/cupertino.dart' show Color;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void refreshStatusBar() {
  var brightness = SchedulerBinding.instance!.window.platformBrightness;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness:
        (brightness == Brightness.dark) ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: (brightness == Brightness.dark)
        ? const Color.fromARGB(255, 29, 29, 29)
        : const Color(0xffF8F8F8), // navigation bar color
    statusBarColor: (brightness == Brightness.dark)
        ? const Color.fromARGB(255, 29, 29, 29)
        : const Color(0xffF8F8F8), // status bar color
  ));
}
