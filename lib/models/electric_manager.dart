import "package:intl/intl.dart";
import "package:electric_charge_note/models/detail_manager.dart";

class ElectricManager {
  final List data;
  late final double avgUsage;

  ElectricManager({required this.data}) {
    if (data.length > 2) {
      List<double> eachKwhPerDay = [];

      List beforeToday = data
          .where((note) => DateTime.now().difference(note['time']).inHours >= 0)
          .toList();

      if (beforeToday.isEmpty) {
        avgUsage = 0;
      } else {
        beforeToday.removeAt(0);

        for (var charge in beforeToday) {
          eachKwhPerDay.add(
              ElectricDetail(index: data.indexOf(charge), historyData: data)
                  .kwhPerDay()['result']);
        }

        avgUsage = eachKwhPerDay.reduce((a, b) => a + b) / eachKwhPerDay.length;
      }
    } else {
      avgUsage = 0;
    }
  }

  String kwhToRupiah(double kwh) {
    return NumberFormat('Rp#,###.##').format(kwh * 1557.64);
  }

  String electricAmount() {
    List beforeToday = data
        .where((note) => DateTime.now().difference(note['time']).inHours >= 0)
        .toList();

    if (beforeToday.isEmpty) {
      return "0";
    }
    Map latest = beforeToday[0];
    beforeToday.removeAt(0);

    String getData(element) {
      return data
          .indexOf(data.where((f) => f['id'] == element['id']).toList()[0])
          .toString();
    }

    if (beforeToday.isEmpty) {
      return "0";
    } else if (beforeToday.length == 1) {
      return NumberFormat("###.#").format(
        latest['lastSize'] -
            (ElectricDetail(
                        index: data.indexOf(beforeToday[0]), historyData: data)
                    .kwhPerDay()['result'] *
                ElectricDetail(
                        index: int.parse(getData(latest)), historyData: data)
                    .todayRange()['value']),
      );
    }
    double result = latest['lastSize'] -
        (avgUsage *
            ElectricDetail(index: int.parse(getData(latest)), historyData: data)
                .todayRange()['value']);

    return (result < 0) ? "0" : NumberFormat("##.#").format(result);
  }
}
