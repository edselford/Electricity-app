import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:electric_charge_note/models/note.dart';
import 'package:electric_charge_note/models/electric.dart';
import 'package:intl/intl.dart';

class InfoTile extends StatefulWidget {
  final List<Note> notelist;
  const InfoTile({Key? key, required this.notelist}) : super(key: key);

  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  String _estimateAmount = "0.00";
  Map<String, dynamic> _estTimeOut = {};
  Timer? _timer;

  @override
  void initState() {
    _estimateAmount = Electric(notelist: widget.notelist).estimateAmount();
    _estTimeOut = Electric(notelist: widget.notelist).estimateElectricLong();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer timer) => _getElectric());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void _getElectric() {
    Electric electric = Electric(notelist: widget.notelist);
    setState(() {
      _estimateAmount =
          NumberFormat("#.###").format(double.parse(electric.estimateAmount()));
      _estTimeOut = electric.estimateElectricLong();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Electric electric = Electric(notelist: widget.notelist);
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 23, left: 23),
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
                    "Amt. Electric",
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
                      text: _estimateAmount,
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
                    "Avg. Usage",
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
                      return NumberFormat("##.#").format(electric.avgUsage());
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
                    "Est. Price",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "(Per day)",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              Text(
                electric.pricePerDay(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Est. Power Out",
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Day", style: Theme.of(context).textTheme.bodyText2),
                      Text(_estTimeOut['day'].toString(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Hour",
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(_estTimeOut['hours'].toString(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Minutes",
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(_estTimeOut['minutes'].toString(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Seconds",
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(_estTimeOut['seconds'].toString(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
