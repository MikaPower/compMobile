import 'dart:async';

import 'package:cmobile/src/database/database_helper.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/resources/repository.dart';
import 'package:cmobile/src/screens/initial_screen.dart';
import 'package:cmobile/src/screens/race_detail_screen.dart';
import 'package:flutter/material.dart';

class InsertUserScreen extends StatefulWidget {
  @override
  _InsertUserScreenState createState() => _InsertUserScreenState();
}

class _InsertUserScreenState extends State<InsertUserScreen> {
  DatabaseHelper database;
  final _formKey = GlobalKey<FormState>();
  String _name;
  Future<String> user;

  @override
  void initState() {
    super.initState();
    var repo = Repository();
    database = repo.db;
    user = _userExists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: new Text('InsertUser'),),
        body: Center(
            child: new Padding(
                padding: EdgeInsets.all(10.0),
                child: new Container(child: _testUser()))));
  }

  Widget _testUser() {
    return Center(
      child: FutureBuilder<String>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Timer(
                Duration(seconds: 3),
                () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/initial', (Route<dynamic> route) => false));
            return new Text("Bem vindo de novo: ${snapshot.data}");
          } else if (snapshot.hasError) {
            return _newUser();
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<String> _userExists() async {
    final allRows = await database.queryRowCount();
    if (allRows > 0) {
      Map<String, dynamic> result = await database.queryUserName();
      print("result,${result}");
      return result['name'];
    }
    return throw 'User not created';
  }

  Widget _newUser() {
    return new Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (input) => _name = input,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                _submit(context);
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  _submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_name);
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: '$_name',
      };
      final id = await database.insert(row);
      print('inserted row id: $id');
      return Navigator.pushNamed(context, '/');
    }
  }
}
