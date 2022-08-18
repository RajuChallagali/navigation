import 'dart:async';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Firebase/amps.dart';
import 'package:navigation/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Fblist extends StatefulWidget {
  const Fblist({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Fblist> createState() => _FblistState();
}

class _FblistState extends State<Fblist> {
  _FblistState() {}
  StreamController<double> controller = StreamController<double>.broadcast();
  late DatabaseReference _dbref;
  late ChartSeriesController _chartSeriesController;
  List<Amps> amp = [];

  var current;
  String voltage = '';
  String power = '';
  String pf = '';
  String time = '';

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance
        .ref()
        .child('data')
        .child('readings')
        .orderByChild('Time')
        .ref;
    dataChange();
  }

  @override
  Widget build(BuildContext context) {
    var data;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Readngs")),
        body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildText('Voltage: $voltage V'),
                buildText('Current: $current mA'),
                buildText('Power: $power W'),
                buildText('Power Factor: $pf'),
                StreamBuilder(
                  stream: _dbref.onValue,
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.hasData &&
                        !snap.hasError &&
                        snap.data.snapshot.value != null) {
                      Map data = snap.data.snapshot.value;

                      for (Map i in data.values) {
                        amp.add(Amps.fromMap(i.cast<dynamic, dynamic>()));
                        print(amp);
                      }

                      List item = [];
                      data.forEach(
                          (index, data) => item.add({"key": index, ...data}));
                    }

                    return const Center(child: Text("Loading data...."));
                  },
                ),
              ]),
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
        .child('readings')
        .onChildAdded
        .listen((onDone) {
      Map data = onDone.snapshot.value as Map;
      data.forEach((key, value) {
        setState(() {
          current = data['current'].toString();
          voltage = data['voltage'].toString();
          pf = data['Pf'].toString();
          power = data['power'].toString();
        });
      });
    });
  }
}
