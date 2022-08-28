import 'package:electric_charge_note/models/statusbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appName = "";
  String _version = "";
  String _buildNumber = "";

  @override
  void initState() {
    getAppInfo();
    super.initState();
  }

  void getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    refreshStatusBar();
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).backgroundColor,
        middle: Text(
          'About',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontFamily: "Product",
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: CupertinoButton(
          child: Row(
            children: [
              const Icon(CupertinoIcons.back),
              Text(
                'Back',
                style: Theme.of(context).textTheme.headline5,
              )
            ],
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
              _appName,
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).secondaryHeaderColor,
                decoration: TextDecoration.none,
                fontFamily: 'Product',
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              _version + '+' + _buildNumber,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SvgPicture.asset(
              'assets/images/electricity_icon.svg',
              width: 200,
              height: 200,
            ),
            Text("Made by Edsel", style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
    );
  }
}
