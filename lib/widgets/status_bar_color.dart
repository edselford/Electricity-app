import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarColored extends StatelessWidget {
  final Widget child;

  const StatusBarColored({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).backgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: child,
    );
  }
}
