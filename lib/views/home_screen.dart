import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/views/add_screen.dart';
import 'package:electric_charge_note/views/about_screen.dart';
import 'package:electric_charge_note/widgets/chart_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:electric_charge_note/widgets/latest_tile.dart';
import 'package:electric_charge_note/widgets/list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HiveManager hiveManager = HiveManager();

  List electricData = [];

  @override
  void initState() {
    setElectricData();
    super.initState();
  }

  void callback() {
    setState(() {
      setElectricData();
    });
  }

  void setElectricData() {
    electricData = hiveManager.getAllData().entries.map((x) {
      x.value['id'] = x.key;
      return x.value;
    }).toList();
    electricData.sort((a, b) => b['time'].compareTo(a['time']));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) {
          return [
            CupertinoSliverNavigationBar(
              transitionBetweenRoutes: false,
              padding: const EdgeInsetsDirectional.only(start: 15, end: 5),
              largeTitle: Text(
                'Electrical Notes',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                child: const Text('Home'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Text('Menu'),
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text('Clear all data'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Clear all data'),
                                  content: const Text(
                                      'Are you sure you want to clear all data?'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text('Clear'),
                                      onPressed: () {
                                        hiveManager.clearAll();
                                        Navigator.of(context).pop();
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                            title: const Text(
                                                'Clearing Data Succefully'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const Text('Ok'),
                                                onPressed: () {
                                                  setState(() {
                                                    setElectricData();
                                                  });
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
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Refresh'),
                          onPressed: () {
                            setState(() {
                              setElectricData();
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('About this app'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const AboutPage(),
                              ),
                            );
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text('Cancel'),
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 20, bottom: 20),
              child: Text(
                'Latest',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.025),
              child: (electricData.isNotEmpty)
                  ? LatestTile(
                      data: electricData[0],
                      allData: electricData,
                      callback: callback,
                    )
                  : Container(
                      height: 188,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor),
                      child: const Center(child: Text('No Data')),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 31, bottom: 20),
              child: Text(
                'Notes',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 23),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor),
                child: Column(
                  children: (!(electricData.length <= 1))
                      ? (() {
                          List<Widget> result = [];
                          int maxLine = 10;
                          for (int i = 1; i <= maxLine; i++) {
                            try {
                              result.add(
                                NoteListTile(
                                  index: i,
                                  electricData: electricData,
                                  isLast: (i == maxLine ||
                                          i == electricData.length - 1)
                                      ? true
                                      : false,
                                  callback: callback,
                                ),
                              );
                            } catch (e) {
                              break;
                            }
                          }
                          return result;
                        })()
                      : [
                          const SizedBox(
                            height: 188,
                            child: Center(
                              child: Text('No Data'),
                            ),
                          ),
                        ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ChartTile(data: electricData),
            ),
          ],
        ),
      ),
    );
  }
}
