import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

class Note {
  int id;
  late DateTime time;
  double size;
  double firstSize;
  double lastSize;
  double price = 1557.64;

  Note({
    required this.time,
    required this.size,
    required this.firstSize,
    required this.lastSize,
    required this.id,
  });

  @override
  String toString() {
    return {
      "id": id,
      "time": time,
      "size": size,
      "firstSize": firstSize,
      "lastSize": lastSize
    }.toString();
  }

  Map toMap() {
    return {
      "id": id,
      "time": time.toIso8601String(),
      "size": size,
      "firstsize": firstSize,
      "lastsize": lastSize
    };
  }

  static Map<String, int> dayRangeCounter(
      DateTime startDate, DateTime endDate) {
    Duration difference = endDate.difference(startDate);
    return {
      "days": difference.inDays,
      "seconds": difference.inSeconds,
    };
  }

  static bool isToday(DateTime startDate) {
    DateTime endDate = DateTime.now();
    if (startDate.day == endDate.day &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> todayRange() {
    Map<String, int> range = dayRangeCounter(time, DateTime.now());
    bool sameDay = isToday(time);

    if (range["days"] == null) {
      return {"text": "ERROR", "value": -1, "seconds": -1};
    }

    return {
      "text": (range["days"] == 0)
          ? sameDay
              ? "Today"
              : "Yesterday"
          : range["days"]! < 0
              ? "${-range["days"]!} days later"
              : "${range["days"]} days ago",
      "value": range["days"],
      "seconds": range["seconds"]
    };
  }

  Map<String, dynamic> nextChargeRange(List<Note> notelist) {
    int index = notelist.indexWhere((Note note) => note.id == id);
    int range = index != 0
        ? dayRangeCounter(time, notelist[index - 1].time)["days"] ?? 0
        : 0;

    return {
      "text": (range != 0) ? "$range days before next charge" : "Last charge",
      "value": range != 0 ? range : 0
    };
  }

  Map<String, dynamic> kwhPerDay(List<Note> notelist) {
    int index = notelist.indexWhere((Note note) => note.id == id);

    if (index == 0) return {"text": "Last charge", "value": 0};

    Map<String, dynamic> nextRange = nextChargeRange(notelist);
    String result = NumberFormat("#.##").format(
        (lastSize - notelist[index - 1].firstSize) /
            (nextRange["value"] == 0 ? 1 : nextRange["value"]));

    return {"text": "$result kWh/d", "value": double.parse(result)};
  }

  String pricePerDay(List<Note> notelist) {
    int index = notelist.indexWhere((Note note) => note.id == id);

    if (index == 0) return "Last charge";

    Map<String, dynamic> kwhPerDay = this.kwhPerDay(notelist);
    String result =
        (Decimal.parse(NumberFormat("#.##").format(kwhPerDay["value"])) *
                Decimal.parse(NumberFormat("#.##").format(price)))
            .toString();

    return toRupiah(double.parse(result));
  }

  String toRupiah(dynamic value) {
    if (value is double || value is int || value is DecimalIntl) {
      return NumberFormat('Rp#,###.##').format(value);
    } else if (value is String) {
      return NumberFormat('Rp#,###.##').format(double.parse(value));
    } else {
      return "ERROR";
    }
  }

  String getPrice() {
    return toRupiah(DecimalIntl(
        Decimal.parse(size.toString()) * Decimal.parse(price.toString())));
  }
}
