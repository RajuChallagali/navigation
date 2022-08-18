import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Firebase/kwh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Usage extends StatefulWidget {
  const Usage({Key? key}) : super(key: key);

  @override
  State<Usage> createState() => _UsageState();
}

class _UsageState extends State<Usage> {
  StreamController<double> controller = StreamController<double>.broadcast();
  late DatabaseReference _dbref;
  late ChartSeriesController _chartSeriesController;
  List<Kwh> kwh = [];

  String EC = '';
  String all_energy = '';
  String cur_hour_energy = '';
  String thirty_day_energy = '';

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance
        .ref()
        .child('data')
        .child('energy')
        .orderByChild('time')
        .ref;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Usage"),
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: _dbref.onValue,
                builder: (context, AsyncSnapshot snap) {
                  if (snap.hasData &&
                      !snap.hasError &&
                      snap.data.snapshot.value != null) {
                    Map data = snap.data.snapshot.value;

                    for (Map i in data.values) {
                      kwh.add(Kwh.fromMap(i.cast<dynamic, dynamic>()));
                    }

                    List item = [];
                    data.forEach(
                        (index, data) => item.add({"key": index, ...data}));
                  }
                  return Expanded(
                      child: SafeArea(
                    child: SfCartesianChart(
                      series: <ChartSeries>[
                        BarSeries<Kwh, DateTime>(
                            dataSource: kwh,
                            xValueMapper: (Kwh data, _) => DateTime.now(),
                            yValueMapper: (Kwh data, _) => data.cur_hour_energy)
                      ],
                      primaryXAxis: DateTimeCategoryAxis(
                          interval: 60,
                          intervalType: DateTimeIntervalType.hours),
                      primaryYAxis: CategoryAxis(interval: 50),
                    ),
                  ));
                })
          ],
        ),
      ),
    );
  }
}
