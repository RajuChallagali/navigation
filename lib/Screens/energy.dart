import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Firebase/kwh.dart';
import 'package:navigation/Screens/usage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Energy extends StatefulWidget {
  const Energy({Key? key}) : super(key: key);

  @override
  State<Energy> createState() => _EnergyState();
}

class _EnergyState extends State<Energy> {
  StreamController<double> controller = StreamController<double>.broadcast();
  late DatabaseReference _dbref;
  late ChartSeriesController _chartSeriesController;
  List<Kwh> kwh = [];

  String EC = '';
  String all_energy = '';
  String current_hour_energy = '';
  String thirty_day_energy = '';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Energy Utilization"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildText('Energy: $EC KWh'),
                buildText('Current Hour Energy: $current_hour_energy Kwh'),
                buildText('Monthly Energy: $thirty_day_energy Kwh'),
                buildText('Total Energy: $all_energy Kwh'),
                Center(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Usage()));
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text("My Usage"),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text("Go to Main Menu"),
                    ),
                  ),
                ),
              ],
            ),
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
          EC = data['EC'].toString();
          current_hour_energy = data['current_hour_energy'].toString();
          thirty_day_energy = data['thirty_day_energy'].toString();
          all_energy = data['all_energy'].toString();
        });
      });
    });
  }
}
