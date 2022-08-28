import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/models/statusbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, Icons;
import 'package:intl/intl.dart';
import 'package:electric_charge_note/models/note.dart';
import 'package:electric_charge_note/widgets/detail_list_tile.dart';

class DetailPage extends StatelessWidget {
  final Note note;
  final List<Note> notelist;
  late final int index;
  final Function callback;

  DetailPage(
      {required this.note,
      required this.callback,
      required this.notelist,
      Key? key})
      : super(key: key) {
    index = notelist.indexWhere((Note note) => note.id == this.note.id);
  }

  @override
  Widget build(BuildContext context) {
    refreshStatusBar();
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Electric Notes',
      home: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        navigationBar: detailNavbar(context),
        child: SafeArea(
          child: ListView(
            children: [
              firstRow(context),
              secondRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Container secondRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          DetailListTile(
            title: 'Before Charge',
            value: kwhText(
              note.firstSize.toString(),
              context,
            ),
          ),
          DetailListTile(
            title: 'After Charge',
            value: kwhText(
              note.lastSize.toString(),
              context,
            ),
          ),
          DetailListTile(
            title: 'Usage / day',
            value: (index != 0)
                ? kwhText(
                    note.kwhPerDay(notelist)['value'].toString(),
                    context,
                  )
                : Text(
                    "Last charge",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
          ),
          DetailListTile(
            title: 'Price',
            value: Text(
              note.getPrice(),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          DetailListTile(
            title: 'Price / day',
            value: Text(
              note.pricePerDay(notelist),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }

  SizedBox firstRow(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 38, left: 6),
                  child: Icon(
                    Icons.date_range,
                    size: 96,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        DateFormat('EEEE\ndd MMMM yyyy\nHH:mm')
                            .format(note.time),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 94,
                  padding: const EdgeInsets.only(top: 4, left: 19),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.timeline,
                            size: 28,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          Text(
                            note.todayRange()['text'] +
                                '\n' +
                                note.nextChargeRange(notelist)['text'],
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 166,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.electrical_services,
                            size: 55,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              'Electric Size',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                                text: note.size.toString(),
                                style: const TextStyle(fontSize: 36)),
                            const TextSpan(
                                text: 'KWH', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  RichText kwhText(String value, BuildContext context) {
    return RichText(
        text: TextSpan(
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(fontWeight: FontWeight.w500),
      children: [
        TextSpan(
          text: value,
          style: const TextStyle(fontSize: 18),
        ),
        const TextSpan(
          text: 'KWH',
          style: TextStyle(fontSize: 12),
        ),
      ],
    ));
  }

  CupertinoNavigationBar detailNavbar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: const Text(
        'Detail',
        style: TextStyle(fontFamily: "Product", fontWeight: FontWeight.w300),
      ),
      brightness: Theme.of(context).brightness,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            const Icon(CupertinoIcons.back),
            Text('Home', style: Theme.of(context).textTheme.headline5),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          'Delete',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: CupertinoColors.destructiveRed,
              ),
        ),
        onPressed: () {
          BuildContext navbarContext = context;
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text(
                  'Delete',
                  style: TextStyle(fontFamily: "Product"),
                ),
                content: const Text(
                  'Are you sure you want to delete this?',
                  style: TextStyle(fontFamily: "Product"),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancel',
                        style: Theme.of(context).textTheme.headline5),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Delete',
                        style: Theme.of(context).textTheme.headline5),
                    onPressed: () {
                      HiveManager().deleteData(note.id);
                      Navigator.of(context).pop();
                      Navigator.of(navbarContext).pop();
                      callback();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
