import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cmobile/src/common/check_connectivity.dart';
import 'package:cmobile/src/models/pilot_model.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/resources/repository.dart';
import 'package:cmobile/src/screens/pilots_screen.dart';
import 'package:cmobile/src/screens/race_detail_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final int raceId;

  const RegisterScreen({Key key, this.raceId}) : super(key: key);

  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<Pilot> pilot;
  Future<RacesModel> races;
  StreamSubscription _connectionChangeStream;
  Pilot pilotModel;

  bool isOffline = false;

  @override
  initState() {
    super.initState();

    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton
        .getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      print("internet xxx on register");
      isOffline = !hasConnection;
    });
  }


  final repo = Repository();
  String _name, _bikeName, _engineSize;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: new Text('Inscrever')),
        body: Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  TextFormField(
                    key: Key("form_name"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (input) => _name = input,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    key: Key("form_bike_name"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (input) => _bikeName = input,
                    decoration: InputDecoration(labelText: 'Bike Name'),
                  ),
                  TextFormField(
                    key: Key("form_engine_size"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (input) => _engineSize = input,
                    decoration: InputDecoration(labelText: 'Engine size'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      key: Key("form_submit"),
                      onPressed: () {
                        if (isOffline) {
                          _showDialog(); /*_submit(context);*/
                        }
                        else {
                          _submit(context);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                  FutureBuilder<Pilot>(
                    future: pilot,

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        repo.db.addRegisteredPilot(widget.raceId, pilotModel);
                        Timer(Duration(seconds: 3), () =>
                            Navigator.of(context).pop());
                        return Text("Obrigado pela sua inscrição ${snapshot.data
                            .name}");

                      }
                      return Center(
                          child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            )));
  }

  // Be sure to cancel subscription after you are done


  _submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final snackBar = SnackBar(content: Text('Processing Data'));
      pilotModel = new Pilot.normal(
          _name, _bikeName, int.parse(_engineSize), raceId: widget.raceId);
      updateRegister(pilotModel);
      print('REGISTRAR PILOTO');
      _scaffoldKey.currentState
          .showSnackBar(snackBar);
    }
  }

  updateRegister(Pilot pilotModel) {
    setState(() {
      pilot = repo.registerPilot(widget.raceId, pilotModel);
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Check your internet connection"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
