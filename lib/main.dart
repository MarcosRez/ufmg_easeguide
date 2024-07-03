import 'package:flutter/material.dart';
import 'package:proj_multidisciplinar_ufmg/screens/map_screen.dart';

import 'src/app.dart';

void main() async {
  runApp(
      const Directionality(textDirection: TextDirection.ltr, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ease Guide - UFMG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}
