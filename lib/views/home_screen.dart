import 'package:electric_charge_note/models/note.dart';
import 'package:electric_charge_note/models/hive_manager.dart';
import 'package:electric_charge_note/widgets/column_builder.dart';
import 'package:electric_charge_note/widgets/info_tile.dart';
import 'package:electric_charge_note/widgets/latest_tile.dart';
import 'package:electric_charge_note/widgets/list_tile.dart';
import 'package:electric_charge_note/widgets/navbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HiveManager db = HiveManager();
  List<Note> notelist = [];

  @override
  void initState() {
    setNotelist();
    super.initState();
  }

  callback() {
    setState(() {
      setNotelist();
    });
  }

  List<Map> exportNote() {
    List<Map> a = notelist.map((x) {
      return x.toMap();
    }).toList();

    return a;
  }

  void setNotelist() {
    notelist = db.getAllData().entries.map((x) {
      return Note(
          time: x.value["time"],
          size: x.value["size"],
          firstSize: x.value["firstSize"],
          lastSize: x.value["lastSize"],
          id: x.key);
    }).toList();
    notelist.sort((a, b) => b.time.compareTo(a.time));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        body: ListView(
          children: [
            (notelist.length > 1)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35, top: 20, bottom: 10),
                          child: Text(
                            'Dashboard',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.025,
                            ),
                            child: InfoTile(notelist: notelist))
                      ])
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 10, bottom: 20),
              child: Text(
                'Latest',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025,
              ),
              child: (notelist.isNotEmpty)
                  ? LatestTile(
                      note: notelist[0],
                      notelist: notelist,
                      callback: callback,
                    )
                  : Container(
                      height: 188,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor),
                      child: const Center(
                        child: Text('No Data'),
                      ),
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
                child: (notelist.length > 1)
                    ? ColumnBuilder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return NoteListTile(
                            note: notelist[index + 1],
                            notelist: notelist,
                            callback: callback,
                            isLast:
                                (index == notelist.length - 2) ? true : false,
                          );
                        },
                      )
                    : Container(
                        height: 188,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor),
                        child: const Center(
                          child: Text('No Data'),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return [
            Navbar(
                callback: () {
                  setState(() {
                    setNotelist();
                  });
                },
                exportNote: exportNote)
          ];
        }),
      ),
    );
  }
}
