import 'dart:math';

import 'package:cmobile/src/common/circle.dart';
import 'package:cmobile/src/models/pilot_model.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/resources/repository.dart';
import 'package:cmobile/src/screens/register_screen.dart';
import 'package:flutter/material.dart';

class PilotsScreen extends StatefulWidget {
  final int raceId;

  @override
  const PilotsScreen({Key key, this.raceId}) : super(key: key);

  _PilotsScreenState createState() => _PilotsScreenState();
}

class _PilotsScreenState extends State<PilotsScreen> {
  Future<PilotsModel> pilots;
  @override
  void initState() {
    super.initState();
    var repo = Repository();
    pilots = repo.fetchRacePilots(widget.raceId);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Inscritos"),),
        backgroundColor: Colors.orange,
        body: new Container(
          child: FutureBuilder<PilotsModel>(
            future: pilots,
            builder: (context,snapshot){
              if (snapshot.hasData) {
                return pilotsList(snapshot.data.pilots);
              } else if (snapshot.hasError) {
                return new Center(child:Text("${snapshot.error}"));
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          )
        ));
  }

  pilotsList( List<Pilot> pilots){
    if (pilots?.isEmpty ?? true) {
      return new Center(child: new Text("No pilots registered yet"),);
    }
    return ListView.builder(
      itemCount: pilots.length,
      itemBuilder: (context, int index) {
        return new Container(
          child: new Column(
            children: <Widget>[
              ListTile(
                //  contentPadding:index == 0 ? EdgeInsets.only(top: 10,left: 18): null ,
                title: new Text(pilots[index].name,
                  style: new TextStyle(
                    fontSize: 19.4,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),),
                subtitle: new Text("${pilots[index].bikeName}-${pilots[index].engineSize}",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17.0
                  ),),
                leading: avatarLeft(index),
              ),
              new Divider(
                height: 10.0,
              )
            ],
          ),
        );
      });
  }
}
