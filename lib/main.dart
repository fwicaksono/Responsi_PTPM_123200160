import 'package:flutter/material.dart';
import 'package:kuis_123200160/kategori.dart';
//Responsi 123200160

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Run(),
    );
  }
}
