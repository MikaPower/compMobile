import 'package:cmobile/src/screens/routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
          title: 'Extreme Lagares 2019',
          routes: body,
          initialRoute: '/',
        );
  }
}