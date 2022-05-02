import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme, Icons;
import 'package:electric_charge_note/models/detail_manager.dart';
import 'package:intl/intl.dart';
import 'package:electric_charge_note/widgets/detail_list_tile.dart';
import 'package:electric_charge_note/models/hive_manager.dart';

class DetailPage extends StatelessWidget {
  late final ElectricDetail detailManager;
  final int index;
  final List historyData;
  final HiveManager hiveManager = HiveManager();
  final Function callback;

  DetailPage(
      {required this.index,
      required this.historyData,
      required this.callback,
      Key? key})
      : super(key: key) {
    detailManager = ElectricDetail(index: index, historyData: historyData);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Electric Notes',
      home: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Detail'),
          brightness: Theme.of(context).brightness,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: const [
                Icon(CupertinoIcons.back),
                Text('Home'),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text(
              'Delete',
              style: TextStyle(
                color: CupertinoColors.destructiveRed,
              ),
            ),
            onPressed: () {
              BuildContext konteks1 = context;
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('Delete'),
                    content:
                        const Text('Are you sure you want to delete this?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Delete'),
                        onPressed: () {
                          hiveManager.deleteData(historyData[index]['id']);
                          Navigator.of(context).pop();
                          Navigator.of(konteks1).pop();
                          callback();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(
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
                                      .format(historyData[index]['time']),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    Text(
                                      detailManager.todayRange()['text'] +
                                          '\n' +
                                          detailManager
                                              .nextChargeRange()['text'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.electrical_services,
                                      size: 55,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'Electric Size',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
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
                                          text: historyData[index]['size']
                                              .toString(),
                                          style: const TextStyle(fontSize: 36)),
                                      const TextSpan(
                                          text: 'KWH',
                                          style: TextStyle(fontSize: 13)),
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
              ),
              Container(
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
                        historyData[index]['firstSize'].toString(),
                        context,
                      ),
                    ),
                    DetailListTile(
                      title: 'After Charge',
                      value: kwhText(
                        historyData[index]['lastSize'].toString(),
                        context,
                      ),
                    ),
                    DetailListTile(
                      title: 'Electric / day',
                      value: (index != 0)
                          ? kwhText(
                              detailManager.kwhPerDay()['result'].toString(),
                              context,
                            )
                          : Text(
                              detailManager.lastCharge,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                    ),
                    DetailListTile(
                      title: 'Price',
                      value: Text(
                        detailManager.price(),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    DetailListTile(
                      title: 'Price / day',
                      value: Text(
                        detailManager.pricePerDay(),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      ),
    );
  }
}
