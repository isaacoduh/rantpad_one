import 'package:flutter/material.dart';
import 'package:rantpad_one/screens/home_screen.dart';
import 'package:rantpad_one/utils/ApiService.dart';

void main() => runApp(MyApp());

// GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        accentColor: Colors.orangeAccent,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // key: _scaffoldState,
        appBar: AppBar(
          title: Text(
            "Rant Pad Demo",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: HomeScreen(),
      ),
    );
  }
}
