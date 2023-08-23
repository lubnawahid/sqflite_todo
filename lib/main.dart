import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_todo/screen/screen1.dart';

void main() async{

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(


        primarySwatch: Colors.pink,
      ),
      home: const Screen1(),
    );
  }
}
