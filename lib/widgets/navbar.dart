import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, Colors;
import 'package:electric_charge_note/views/add_screen.dart';
import 'package:electric_charge_note/views/about_screen.dart';
import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/models/note_req.dart';
import 'package:electric_charge_note/models/statusbar.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';

class Navbar extends StatelessWidget {
  final Function callback;
  final Function exportNote;

  const Navbar({Key? key, required this.callback, required this.exportNote})
      : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext navbarContext) {
    return CupertinoSliverNavigationBar(
      brightness: Brightness.light,
      transitionBetweenRoutes: false,
      padding: const EdgeInsetsDirectional.only(start: 15, end: 5),
      largeTitle: Text(
        'Electrical Notes',
        style: TextStyle(
            color: Theme.of(navbarContext).secondaryHeaderColor,
            fontFamily: "Product",
            fontWeight: FontWeight.w300),
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.add),
        onPressed: () {
          Navigator.of(navbarContext)
              .push(
            CupertinoPageRoute(
              builder: (context) => AddPage(callback: callback),
            ),
          )
              .then((value) {
            refreshBarDelay();
          });
        },
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text('Home', style: Theme.of(navbarContext).textTheme.headline5),
        onPressed: () {
          showCupertinoModalPopup(
            context: navbarContext,
            builder: (BuildContext context) => CupertinoActionSheet(
              title: Text('Menu',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 15, color: Colors.grey)),
              actions: [
                clearData(context),
                refreshData(context),
                exportData(context),
                importData(context, navbarContext),
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
        Navigator.of(context)
            .push(
          CupertinoPageRoute(
            builder: (context) => const AboutPage(),
          ),
        )
            .then((value) {
          refreshBarDelay();
        });
      },
    );
  }

  void refreshBarDelay() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      refreshStatusBar();
    });
  }

  Widget exportData(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text(
        "Export Data",
        style: Theme.of(context).textTheme.headline5,
      ),
      onPressed: () {
        Navigator.of(context).pop();

        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                'Export data',
                style: TextStyle(fontFamily: "Product"),
              ),
              content: const Text(
                'where do you want to export?',
                style: TextStyle(fontFamily: "Product"),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "Json",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    List<Map> dataExport = exportNote();

                    inspect(dataExport);

                    Share.share(json.encode(dataExport).toString());
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "Database",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Export from database
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget importData(BuildContext context, BuildContext navbarContext) {
    return CupertinoActionSheetAction(
      child: Text(
        "Import Data",
        style: Theme.of(context).textTheme.headline5,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                'Import data',
                style: TextStyle(fontFamily: "Product"),
              ),
              content: const Text(
                'where do you want to import from?',
                style: TextStyle(fontFamily: "Product"),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "Json",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Import from json
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "Database",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    NoteReq req = NoteReq();
                    req.reqNote().then(
                      (value) {
                        if (value.statusCode < 300 && value.statusCode > 199) {
                          // DATA GET
                          try {
                            List data = json.decode(value.body)['results'];

                            showCupertinoDialog(
                              context: navbarContext,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text(
                                    "Succesful",
                                    style: TextStyle(fontFamily: "Product"),
                                  ),
                                  content: const Text(
                                      "Data is obtained, do you want to overwrite the current data?",
                                      style: TextStyle(fontFamily: "Product")),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(
                                        'Yes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        HiveManager hive = HiveManager();
                                        hive.clearAll();
                                        for (int i = 0; i < data.length; i++) {
                                          hive.addData({
                                            'time':
                                                DateTime.parse(data[i]['time']),
                                            'size':
                                                double.parse(data[i]['size']),
                                            'firstSize': double.parse(
                                                data[i]['firstsize']),
                                            'lastSize': double.parse(
                                                data[i]['lastsize']),
                                          });
                                        }
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                            title: const Text(
                                              'Import data succesfull',
                                              style: TextStyle(
                                                  fontFamily: "Product"),
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text(
                                                  'Ok',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Restart.restartApp();
                                                },
                                              ),
                                            ],
                                          ),
                                          barrierDismissible: false,
                                        );
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        'No',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            showCupertinoDialog(
                              context: navbarContext,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text(
                                    "Error",
                                    style: TextStyle(fontFamily: "Product"),
                                  ),
                                  content: Text(
                                      e.toString() +
                                          "\nresponse : " +
                                          value.body,
                                      style: const TextStyle(
                                          fontFamily: "Product")),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(
                                        'Ok',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          showCupertinoDialog(
                            context: navbarContext,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text(
                                  "Error",
                                  style: TextStyle(fontFamily: "Product"),
                                ),
                                content: Text(
                                    "Status code " +
                                        value.statusCode.toString(),
                                    style:
                                        const TextStyle(fontFamily: "Product")),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text(
                                      'Ok',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                )
              ],
            );
          },
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
