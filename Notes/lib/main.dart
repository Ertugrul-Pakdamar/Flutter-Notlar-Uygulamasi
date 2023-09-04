import 'package:flutter/material.dart';
import 'package:Notlar/pages/home.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notlar",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}