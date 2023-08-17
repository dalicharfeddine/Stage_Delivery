import 'package:delivery/View/Home.dart';
import 'package:delivery/View/Login.dart';
import 'package:flutter/material.dart';
import 'package:delivery/View/Login.dart';
import 'package:delivery/Navigation/bottom_navigation_bar_with_fab.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      routes: {
        "/": (context) {
          return BottomNavigationBarWithFAB();
        },
        "/signup": (context) {
          return Home();
        },
        "/resetPwd": (context) {
          return BottomNavigationBarWithFAB();
        },
        "": (context) {
          return BottomNavigationBarWithFAB();
        },
        "/home/update": (context) {
          return Login();
        },
        "/homeTab": (context) {
          return Login();
        },
        "/homeBottom": (context) {
          return Login();
        },
      },
    );
  }
}
