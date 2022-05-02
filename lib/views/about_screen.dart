import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).backgroundColor,
        middle: Text(
          'About',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        leading: CupertinoButton(
          child: Row(
            children: const [Icon(CupertinoIcons.back), Text('Back')],
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            // pop with animation
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Electric Charge Note',
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).secondaryHeaderColor,
                decoration: TextDecoration.none,
                fontFamily: 'SF UI',
                fontWeight: FontWeight.w500,
              ),
            ),
            SvgPicture.asset(
              'assets/images/electricity_icon.svg',
              width: 200,
              height: 200,
            ),
            Text(
              'Made by Edsel Mustapa',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).secondaryHeaderColor,
                decoration: TextDecoration.none,
                fontFamily: 'SF UI',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
