import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("First Screen"),),
      body: new Container(
        color: Colors.red,
        child: new Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/races');
                    },
                    child: new Text("Corridas"),
                  ),
                ],
              ),
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
