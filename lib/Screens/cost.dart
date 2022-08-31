import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation/Firebase/kwh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Cost extends StatefulWidget {
  const Cost({Key? key}) : super(key: key);

  @override
  State<Cost> createState() => _CostState();
}

class _CostState extends State<Cost> {
  StreamController<double> controller = StreamController<double>.broadcast();
  late DatabaseReference _dbref;
  late ChartSeriesController _chartSeriesController;
  List<Kwh> kwh = [];

  String current_hour_cost = '';

  String thirty_day_cost = '';

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance
        .ref()
        .child('data')
        .child('energy')
        .orderByChild('Time')
        .ref;
    dataChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cost"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              buildText('Current Hour Cost: Rs. $current_hour_cost /-'),
              buildText('Monthly Cost: Rs. $thirty_day_cost /-'),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text("Go to Main Menu"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildText(String s) {
    return Text(
      s,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void dataChange() {
    var subscription = FirebaseDatabase.instance
        .ref()
        .child('data')
        .child('energy')
        .onChildAdded
        .listen((onDone) {
      Map data = onDone.snapshot.value as Map;
      data.forEach((key, value) {
        setState(() {
          current_hour_cost =
              ((data['current_hour_energy'] / 1000) * 1.9 + 25).toString();
          thirty_day_cost =
              ((data['current_hour_energy'] * 30 * 24 / 1000) * 1.9 + 25)
                  .toString();
        });
      });
    });
  }
}
