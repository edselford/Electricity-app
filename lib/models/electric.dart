import 'package:electric_charge_note/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Electric {
  final List<Note> notelist;
  final double price = 1557.64;

  Electric({required this.notelist});

  List<Note> beforeTodayList() {
    return notelist
        .where((note) => note.time.isBefore(DateTime.now()))
        .toList();
  }

  double avgUsage() {
    double usage;
    if (notelist.length > 1) {
      List eachUsage = [];
      List<Note> beforeToday = beforeTodayList();

      if (beforeToday.isEmpty) {
        usage = 0;
      } else {
        beforeToday.removeAt(0);
        for (Note note in beforeToday) {
          double res = note.kwhPerDay(notelist)['value'];
          eachUsage.add(res);
        }
      }

      usage = double.parse(NumberFormat("#.##")
          .format(eachUsage.reduce((a, b) => a + b) / eachUsage.length));
    } else {
      usage = 0.0;
    }

    return usage;
  }

  String estimateAmount() {
    List<Note> beforeToday = beforeTodayList();

    if (beforeToday.isEmpty) return "0";

    Note latest = beforeToday.removeAt(0);

    Map<String, dynamic> todayRange = latest.todayRange();

    if (beforeToday.isEmpty) {
      return "0";
    } else if (beforeToday.length == 1) {
      double usage = beforeToday[0].kwhPerDay(notelist)['value'];

      return NumberFormat("#.00000")
          .format(latest.lastSize - (usage * todayRange['seconds'] / 86400));
    }

    double averageUsage = avgUsage();
    String result = NumberFormat("#.00000")
        .format(latest.lastSize - averageUsage * todayRange['seconds'] / 86400);

    return double.parse(result) < 0 ? "0" : result;
  }

  String pricePerDay() {
    double averageUsage = avgUsage();
    return NumberFormat("Rp#,###.##").format(averageUsage * price);
  }

  Map<String, dynamic> estimateElectricLong() {
    String estimate = estimateAmount();
    double averageUsage = avgUsage();

    double value = double.parse(
        NumberFormat("#.00000").format(double.parse(estimate) / averageUsage));

    int day = value.floor();
    int hours = (value % 1 * 24).floor();
    int minutes = (value % 1 * 24 % 1 * 60).floor();
    int seconds = (value % 1 * 24 % 1 * 60 % 1 * 60).floor();

    String text = "$day days $hours hours $minutes minutes $seconds seconds";

    return {
      "text": text,
      "value": value,
      "day": day,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds
    };
  }
}
