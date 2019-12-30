import 'package:cmobile/src/common/check_connectivity.dart';
import 'package:flutter/material.dart';


import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  runApp(App());
}

