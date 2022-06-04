import 'package:electric_charge_note/models/detail_manager.dart';
import 'package:electric_charge_note/views/graph_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:electric_charge_note/models/electric_manager.dart';

class ChartTile extends StatelessWidget {
  final List data;

  const ChartTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.only(bottom: 20),
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, right: 23, left: 23),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Amount of Electricity Now",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        "(Estimate)",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 20),
                      children: [
                        TextSpan(
                          text: ElectricManager(data: data).electricAmount(),
                        ),
                        const TextSpan(
                          text: ' KWH',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Average Electricity Usage",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        "(Per day)",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 20),
                      children: [
                        TextSpan(text: () {
                          return NumberFormat("##.#")
                              .format(ElectricManager(data: data).avgUsage);
                        }()),
                        const TextSpan(
                          text: ' KWH/day',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estimate Price",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        "(Per day)",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Text(
                    ElectricManager(data: data)
                        .kwhToRupiah(ElectricManager(data: data).avgUsage),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 500,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 23,
            left: 10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: data.isEmpty
              ? const Center(child: Text('No Data'))
              : Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Text('Chart',
                                style: Theme.of(context).textTheme.headline2),
                          ),
                          CupertinoButton(
                            child: const Icon(CupertinoIcons.fullscreen),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => GraphPage(
                                    data: data,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SfCartesianChart(
                        legend: Legend(
                          isVisible: true,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 80,
                          interval: 10,
                        ),
                        primaryXAxis: DateTimeAxis(
                            minimum: data[0]['time'],
                            maximum: data.length < 11
                                ? data[data.length - 1]['time']
                                : data[10]['time'],
                            // set intervalType to fit the data
                            intervalType: DateTimeIntervalType.days,
                            dateFormat: DateFormat('dd-MM-yy'),
                            edgeLabelPlacement: EdgeLabelPlacement.shift),
                        series: <ChartSeries>[
                          LineSeries(
                            name: 'Electric / day',
                            dataSource: data,
                            xValueMapper: (note, _) => DateTime.parse(
                              DateFormat('yyyy-MM-dd').format(note['time']),
                            ),
                            yValueMapper: (note, _) => ElectricDetail(
                              index: data.indexOf(note),
                              historyData: data,
                            ).kwhPerDay()['result'],
                          ),
                          LineSeries(
                            dashArray: [5, 10],
                            name: 'First Size',
                            dataSource: data,
                            xValueMapper: (note, _) => DateTime.parse(
                              DateFormat('yyyy-MM-dd').format(note['time']),
                            ),
                            yValueMapper: (note, _) => note['lastSize'],
                            color: const Color.fromARGB(255, 45, 168, 76),
                          ),
                          LineSeries(
                            dashArray: [5, 10],
                            name: 'Last Size',
                            dataSource: data,
                            xValueMapper: (note, _) => DateTime.parse(
                              DateFormat('yyyy-MM-dd').format(note['time']),
                            ),
                            yValueMapper: (note, _) => note['firstSize'],
                          )
                        ],
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
