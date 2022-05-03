import 'package:flutter/material.dart';
import 'package:flutter_hive_expensetracker/pages/home_page.dart';
import 'package:flutter_hive_expensetracker/theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('income_expense');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: myTheme,
      home: HomePage(),
    );
  }
}