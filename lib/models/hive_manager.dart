import 'package:hive/hive.dart';

class HiveManager {
  static late Box _box;

  HiveManager() {
    _init();
  }

  static _init() async {
    await Hive.openBox('notes');
  }

  void addData(Map data) {
    _box = Hive.box('notes');
    _box.add(data);
  }

  Map getAllData() {
    _box = Hive.box('notes');
    return _box.toMap();
  }

  void deleteData(int index) {
    _box = Hive.box('notes');
    _box.delete(index);
  }

  void clearAll() {
    _box = Hive.box('notes');
    _box.clear();
  }
}
