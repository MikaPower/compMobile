import 'package:cmobile/src/screens/initial_screen.dart';
import 'package:cmobile/src/screens/insert_user_screen.dart';
import 'package:cmobile/src/screens/races_screen.dart';
import 'package:flutter/material.dart';


Map<String, WidgetBuilder> body = {
  '/':(context) => InsertUserScreen(),
  '/initial':(context) => InitialScreen(),
  '/races':(context) => RacesScreen(),


/*  '/cores': (context) => InformationScreen(),
  '/estates': (context) => EstatesScreen(),
  '/about': (context) => AboutScreen(),
  '/map': (context) => MapScreen(),*/
};
