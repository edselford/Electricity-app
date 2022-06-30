import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:electric_charge_note/models/detail_manager.dart';
import 'package:intl/intl.dart';
import 'package:electric_charge_note/views/detail_screen.dart';
import 'package:electric_charge_note/views/add_screen.dart';

class LatestTile extends StatelessWidget {
  final Map data;
  final List allData;
  late final ElectricDetail detailManager;
  final Function callback;
  final HiveManager hiveManager = HiveManager();

  LatestTile(
      {Key? key,
      required this.data,
      required this.allData,
      required this.callback})
      : super(key: key) {
    detailManager = ElectricDetail(
      index: 0,
      historyData: allData,
    );

    if (data['time'] is String) {
      data['time'] = DateTime.parse(data['time']);
    }
  }

  void showDetail(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return DetailPage(index: 0, historyData: allData, callback: callback);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onLongPress: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            title: Text(
              'Tile Menu [${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data['time'].toString()))}]',
            ),
            message: const Text('What do you want to do?'),
            actions: [
              CupertinoActionSheetAction(
                child: const Text('Edit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => AddPage(
                        callback: callback,
                        isEdit: true,
                        index: data['id'],
                      ),
                    ),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Detail'),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDetail(context);
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Delete'),
                        content:
                            const Text('Are you sure to delete this note?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Delete'),
                            onPressed: () {
                              hiveManager.deleteData(data['id']);
                              Navigator.of(context).pop();
                              callback();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
      onPressed: () {
        showDetail(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 188,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 23,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(data['time']),
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  DateFormat('d MMMM y').format(data['time']),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat('HH:mm').format(data['time']),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  detailManager.price(),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: const Color(0xffC54C4C),
                      ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 7),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                        text: data['size'].toString(),
                      ),
                      const TextSpan(
                        text: 'KWH',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  detailManager.todayRange()['text'],
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    kwhSize(
                      context,
                      title: 'First Size:',
                      value: data['firstSize'].toString(),
                      color: const Color(0xff78A90F),
                    ),
                    kwhSize(
                      context,
                      title: 'Last Size:',
                      value: data['lastSize'].toString(),
                      color: const Color(0xff22C5CF),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container kwhSize(
    BuildContext context, {
    required title,
    required value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 18,
                  color: color,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'KWH',
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
