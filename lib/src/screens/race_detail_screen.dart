import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/resources/repository.dart';
import 'package:cmobile/src/screens/map_screen.dart';
import 'package:cmobile/src/screens/pilots_screen.dart';
import 'package:cmobile/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class RaceDetailScreen extends StatefulWidget {
  final Race race;

  @override
  const RaceDetailScreen({Key key, this.race}) : super(key: key);

  _RaceDetailScreenState createState() => _RaceDetailScreenState();
}

class _RaceDetailScreenState extends State<RaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.race.name)),
      body: new Container(
          child: new Column(
        children: <Widget>[
          new Container(
            child: Image.network(widget.race.image),
          ),
          new Container(
              child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)),
                      child: new Text('Inscrever'),
                      onPressed: () {
                      return  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen(
                                      raceId: widget.race.id,
                                    )));
                      }),
                  new RaisedButton(
                      child: new Text("Lista de inscritos"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PilotsScreen(
                                      raceId: widget.race.id,
                                    )));
                      })
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)),
                      child: new Text('Localização'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapInsideOperationScreen(
                                    point: new LatLng(
                                        double.parse(widget.race.latitude),
                                        double.parse(widget.race.longitude)))));
                      }),
                  new RaisedButton(
                      child: new Text("Inscritos offline"), onPressed: () {})
                ],
              )
            ],
          ))
        ],
      )),
    );
  }
}
