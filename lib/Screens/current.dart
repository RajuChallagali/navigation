import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Firebase/amps.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Current extends StatefulWidget {
  const Current({Key? key}) : super(key: key);

  @override
  State<Current> createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  StreamController<double> controller = StreamController<double>.broadcast();
  late DatabaseReference _dbref;
  late ChartSeriesController _chartSeriesController;
  List<Amps> amp = [];

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance
        .ref()
        .child('data')
        .child('readings')
        .orderByChild('Time')
        .ref;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Utilization"),
      ),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
                stream: _dbref.onValue,
                builder: (context, AsyncSnapshot onDone) {
                  if (onDone.hasData &&
                      !onDone.hasError &&
                      onDone.data.snapshot.value != null) {
                    Map data = onDone.data.snapshot.value;

                    for (Map i in data.values) {
                      amp.add(Amps.fromMap(i.cast<dynamic, dynamic>()));
                    }

                    List item = [];
                    data.forEach(
                        (index, data) => item.add({"key": index, ...data}));
                    return Expanded(
                      child: SafeArea(
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                              intervalType: DateTimeIntervalType.days),
                          primaryYAxis: NumericAxis(interval: 50),
                          title: ChartTitle(text: 'Current Utilization'),
                          legend: Legend(
                            isVisible: true,
                          ),
                          trackballBehavior: TrackballBehavior(enable: true),
                          zoomPanBehavior: ZoomPanBehavior(
                              enablePinching: true,
                              enablePanning: true,
                              enableDoubleTapZooming: true,
                              zoomMode: ZoomMode.x),
                          series: <ChartSeries<Amps, dynamic>>[
                            LineSeries<Amps, dynamic>(
                              onRendererCreated:
                                  (ChartSeriesController controller) {
                                _chartSeriesController = controller;
                              },
                              dataSource: amp,
                              xValueMapper: (Amps data, _) => data.sec,
                              yValueMapper: (Amps data, _) => data.cur,
                              name: 'Current',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: false),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text("Loading data...."));
                  }
                }),
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
    );
  }
}
