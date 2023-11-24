import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_api/app/pages/home/home_page.dart';

import '../main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'HomePage'),
    );
  }
}