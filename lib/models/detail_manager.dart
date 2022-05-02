import 'package:intl/intl.dart';

class ElectricDetail {
  late int index;
  late List historyData;
  late Map currentData;
  final String lastCharge = "Last Charge";

  ElectricDetail({
    required this.index,
    required this.historyData,
  }) {
    currentData = historyData[index];
  }

  static int dayRangeCounter(DateTime startDate, DateTime endDate) {
    var difference = endDate.difference(startDate);
    return difference.inDays;
  }

  static bool isToday(DateTime startDate, DateTime endDate) {
    if (startDate.day == endDate.day) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> todayRange() {
    int range = dayRangeCounter(currentData['time'], DateTime.now());
    bool isSameDay = isToday(currentData['time'], DateTime.now());
    return {
      'text': (range == 0)
          ? (isSameDay)
              ? 'Today'
              : '1 day ago'
          : (range < 0)
              ? '${-range} days later'
              : '$range days ago',
      'value': range
    };
  }

  Map<String, dynamic> nextChargeRange() {
    int? range = (index != 0)
        ? dayRangeCounter(currentData['time'], historyData[index - 1]['time'])
        : null;
    return {
      'text': (range != null) ? '$range days before next charge' : lastCharge,
      'value': range ?? 0
    };
  }

  Map<String, dynamic> kwhPerDay() {
    if (index != 0) {
      double result = double.parse(
        NumberFormat('#.##').format(
          (currentData['lastSize'] - historyData[index - 1]['firstSize']) /
              ((nextChargeRange()['value'] == 0)
                  ? 1
                  : nextChargeRange()['value']),
        ),
      );
      return {'text': '${result}KWH', 'result': result};
    } else {
      return {'text': lastCharge, 'result': 0};
    }
  }

  String toRupiah(num value) => NumberFormat('Rp#,###.##').format(value);

  String pricePerDay() {
    if (index != 0) {
      var result = kwhPerDay()['result'] * 1557.64;
      return toRupiah(result);
    } else {
      return lastCharge;
    }
  }

  String price() {
    return toRupiah(currentData['size'] * 1557.64);
  }
}
