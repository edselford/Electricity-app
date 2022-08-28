import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, Colors;
import 'package:electric_charge_note/views/add_screen.dart';
import 'package:electric_charge_note/views/about_screen.dart';
import 'package:electric_charge_note/models/hive_manager.dart';

class Navbar extends StatelessWidget {
  final Function callback;

  const Navbar({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      brightness: Brightness.light,
      transitionBetweenRoutes: false,
      padding: const EdgeInsetsDirectional.only(start: 15, end: 5),
      largeTitle: Text(
        'Electrical Notes',
        style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontFamily: "Product",
            fontWeight: FontWeight.w300),
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.add),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => AddPage(callback: callback),
            ),
          );
        },
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text('Home', style: Theme.of(context).textTheme.headline5),
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              title: Text('Menu',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 15, color: Colors.grey)),
              actions: [
                clearData(context),
                refreshData(context),
                aboutApp(context),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('Cancel',
                    style: Theme.of(context).textTheme.headline5),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget aboutApp(BuildContext context) {
    return CupertinoActionSheetAction(
      child:
          Text('About this app', style: Theme.of(context).textTheme.headline5),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const AboutPage(),
          ),
        );
      },
    );
  }

  Widget refreshData(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text('Refresh', style: Theme.of(context).textTheme.headline5),
      onPressed: () {
        callback();
        Navigator.of(context).pop();
      },
    );
  }

  Widget clearData(BuildContext context) {
    return CupertinoActionSheetAction(
      child:
          Text('Clear all data', style: Theme.of(context).textTheme.headline5),
      onPressed: () {
        Navigator.of(context).pop();
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                'Clear all data',
                style: TextStyle(fontFamily: "Product"),
              ),
              content: const Text(
                'Are you sure you want to clear all data?',
                style: TextStyle(fontFamily: "Product"),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.headline5),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Clear',
                      style: Theme.of(context).textTheme.headline5),
                  onPressed: () {
                    HiveManager().clearAll();
                    Navigator.of(context).pop();
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text(
                          'Clearing Data Succefully',
                          style: TextStyle(fontFamily: "Product"),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(
                              'Ok',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onPressed: () {
                              callback();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      barrierDismissible: false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
