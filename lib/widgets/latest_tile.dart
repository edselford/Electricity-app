import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/views/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show RawMaterialButton, Theme;
import 'package:electric_charge_note/models/note.dart';
import 'package:electric_charge_note/views/add_screen.dart';
import 'package:intl/intl.dart';

class LatestTile extends StatelessWidget {
  final Note note;
  final List<Note> notelist;
  final Function callback;

  const LatestTile(
      {Key? key,
      required this.note,
      required this.notelist,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
              builder: (context) => DetailPage(
                  note: note, notelist: notelist, callback: callback)),
        );
      },
      onLongPress: () {
        longPressActionMenu(context);
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
                  DateFormat('EEEE').format(note.time),
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  DateFormat('d MMMM y').format(note.time),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat('HH:mm').format(note.time),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  note.getPrice(),
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
                        text: note.size.toString(),
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
                  note.todayRange()['text'],
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    kwhSize(
                      context,
                      title: 'First Size:',
                      value: note.firstSize.toString(),
                      color: const Color(0xff78A90F),
                    ),
                    kwhSize(
                      context,
                      title: 'Last Size:',
                      value: note.lastSize.toString(),
                      color: const Color(0xff22C5CF),
                    ),
                  ],
                ),
              ],
            ),
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

  void longPressActionMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
            'Tile Menu [${DateFormat('dd-MM-yyyy HH:mm:ss').format(note.time)}]'),
        message: const Text("What do you want to do?"),
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
                    index: note.id,
                  ),
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Detail'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                CupertinoPageRoute(
                    builder: (context) => DetailPage(
                        note: note, notelist: notelist, callback: callback)),
              );
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
                    content: const Text('Are you sure to delete this note?'),
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
                          HiveManager().deleteData(note.id);
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
  }
}
