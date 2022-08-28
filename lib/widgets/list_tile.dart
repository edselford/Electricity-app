import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/views/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show RawMaterialButton, Theme, Colors, Divider;
import 'package:electric_charge_note/models/note.dart';
import 'package:electric_charge_note/views/add_screen.dart';
import 'package:intl/intl.dart';

class NoteListTile extends StatelessWidget {
  final Note note;
  final List<Note> notelist;
  final Function callback;
  final bool isLast;

  const NoteListTile(
      {Key? key,
      required this.note,
      required this.notelist,
      required this.callback,
      this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: RawMaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => DetailPage(
                  note: note, callback: callback, notelist: notelist)));
        },
        onLongPress: () {
          longPressActionMenu(context);
        },
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
                        DateFormat('EEEE').format(note.time),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        DateFormat('dd MMMM y').format(note.time),
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
                              text: note.size.toString(),
                            ),
                            const TextSpan(
                              text: ' KWH',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('H:mm').format(note.time),
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

  void longPressActionMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
            'Tile Menu [${DateFormat('dd-MM-yyyy HH:mm:ss').format(note.time)}]'),
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
              debugPrint("Show Detail (revision)");
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
