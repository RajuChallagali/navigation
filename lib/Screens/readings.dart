import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:navigation/Firebase/list.dart';
import 'package:navigation/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Readings extends StatefulWidget {
  const Readings();

  @override
  State<Readings> createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  _ReadingsState() {}
  StreamController<double> controller = StreamController<double>.broadcast();
  late DatabaseReference _dbref;
  late ChartSeriesController _chartSeriesController;
  List<Amps> amp = [];
  DateTime selectedDate = DateTime.now();

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
    fetchData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    var data;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Readings")),
        body: Container(
          alignment: Alignment.center,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildText('Voltage: $voltage V'),
                  buildText('Current: $current mA'),
                  buildText('Power: $power W'),
                  buildText('Power Factor: $pf'),
                  buildText('Time: $time'),
                  ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date')),
                  StreamBuilder(
                    stream: _dbref.onValue,
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        Map data = snap.data.snapshot.value;

                        for (Map i in data.values) {
                          amp.add(Amps.fromMap(i.cast<dynamic, dynamic>()));
                        }

                        List item = [];
                        data.forEach(
                            (index, data) => item.add({"key": index, ...data}));
                      }
                      return SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text("Go to Main Menu"),
                        ),
                      );
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    fetchData(selectedDate);
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
        .orderByChild('Time')
        .onChildAdded
        .listen((onDone) {
      Map data = onDone.snapshot.value as Map;
      data.forEach((key, value) {
        setState(() {
          current = data['current'].toString();
          voltage = data['voltage'].toString();
          pf = data['Pf'].toString();
          power = data['power'].toString();
          time = DateTime.parse(data['Time']).toString();
        });
      });
    });
  }

  void fetchData(DateTime selectedDate) {
    var date = FirebaseDatabase.instance
        .ref()
        .child('data')
        .child('readings')
        .child('Time')
        .once()
        .then((DatabaseEvent snapshot) {
      Map dat = snapshot.snapshot.value as Map;
      dat.forEach((key, value) {
        setState(() {
          current = dat['current'].toString();
          voltage = dat['voltage'].toString();
          pf = dat['Pf'].toString();
          power = dat['power'].toString();
          time = DateTime.parse(dat['Time']).toString();
        });
      });
    });
  }
}

class Amps {
  DateTime sec;
  final dynamic cur;
  final dynamic vol;

  Amps(this.sec, this.cur, this.vol);
  factory Amps.fromMap(Map<dynamic, dynamic> dataMap) {
    return Amps(DateTime.parse(dataMap['Time']), dataMap['current'],
        dataMap['voltage']);
  }
}
