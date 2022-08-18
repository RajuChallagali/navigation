import 'package:flutter/material.dart';
import 'package:navigation/Firebase/list.dart';
import 'package:navigation/Screens/cost.dart';
import 'package:navigation/Screens/current.dart';
import 'package:navigation/Screens/energy.dart';
import 'package:navigation/Screens/readings.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Energy Meter"),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Readings()));
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  "Readings",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Energy()));
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  "Energy",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Current()));
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  "Current",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Cost()));
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  "Cost",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
            ],
          )),
    );
  }
}
