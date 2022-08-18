import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Screens/page.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:math';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "My Energy Meter",
      home: Page1(),
      debugShowCheckedModeBanner: false,
    );
  }
}
