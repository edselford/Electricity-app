import 'package:electric_charge_note/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatelessWidget {
  final List<Note> notelist;

  const GraphPage({Key? key, required this.notelist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).backgroundColor,
        middle: Text(
          'Graph',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        leading: CupertinoButton(
          child: Row(
            children: const [Icon(CupertinoIcons.back), Text('Back')],
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            // pop with animation
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SfCartesianChart(
        trackballBehavior: TrackballBehavior(
            enable: true, activationMode: ActivationMode.singleTap),
        legend: Legend(
          isVisible: true,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 80,
          interval: 10,
        ),
        primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minimum: notelist[0].time,
            maximum: notelist.length < 11
                ? notelist[notelist.length - 1].time
                : notelist[10].time,
            // set intervalType to fit the data
            intervalType: DateTimeIntervalType.days,
            dateFormat: DateFormat('dd-MM-yy'),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        series: <ChartSeries>[
          LineSeries(
            name: 'Electric / day',
            dataSource: notelist,
            xValueMapper: (note, _) =>
                DateTime.parse(DateFormat('yyyy-MM-dd').format(note.time)),
            yValueMapper: (note, _) {
              debugPrint("Hello, world!");
              return 1;
              // return note.kwhPerDay()['result'];
            },
            markerSettings: const MarkerSettings(isVisible: true),
          ),
          LineSeries(
              dashArray: [5, 10],
              markerSettings: const MarkerSettings(isVisible: true),
              name: 'First Size',
              dataSource: notelist,
              xValueMapper: (note, _) =>
                  DateTime.parse(DateFormat('yyyy-MM-dd').format(note.time)),
              yValueMapper: (note, _) => note.lastSize,
              color: const Color.fromARGB(255, 45, 168, 76)),
          LineSeries(
            dashArray: [5, 10],
            markerSettings: const MarkerSettings(isVisible: true),
            name: 'Last Size',
            dataSource: notelist,
            xValueMapper: (note, _) =>
                DateTime.parse(DateFormat('yyyy-MM-dd').format(note.time)),
            yValueMapper: (note, _) => note.firstSize,
          )
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}
