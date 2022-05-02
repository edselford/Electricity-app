import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:intl/intl.dart';
import 'package:electric_charge_note/views/detail_screen.dart';
import 'package:electric_charge_note/views/add_screen.dart';

class NoteListTile extends StatelessWidget {
  late final Map data;
  final int index;
  final List electricData;
  final bool isLast;
  final Function callback;
  final HiveManager hiveManager = HiveManager();

  NoteListTile({
    Key? key,
    required this.index,
    required this.electricData,
    this.isLast = false,
    required this.callback,
  }) : super(
          key: key,
        ) {
    data = electricData[index];
  }

  void showDetail(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => DetailPage(
          index: index,
          historyData: electricData,
          callback: callback,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: RawMaterialButton(
        onLongPress: () {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              title: Text(
                  'Tile Menu [${DateFormat('dd-MM-yyyy HH:mm:ss').format(data['time'])}]'),
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
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(data['time']),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        DateFormat('dd MMMM y').format(data['time']),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 20),
                          children: [
                            TextSpan(
                              text: data['size'].toString(),
                            ),
                            const TextSpan(
                              text: ' KWH',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('H:mm').format(data['time']),
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                ],
              ),
              (!isLast)
                  ? Column(
                      children: [
                        const SizedBox(height: 17),
                        Divider(
                          color: Theme.of(context).backgroundColor,
                          thickness: 2,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
