import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/resources/repository.dart';
import 'package:cmobile/src/screens/race_detail_screen.dart';
import 'package:flutter/material.dart';

class RacesScreen extends StatefulWidget {
  @override
  _RacesScreenState createState() => _RacesScreenState();
}

class _RacesScreenState extends State<RacesScreen> {
  Future<RacesModel> races;

  @override
  void initState() {
    super.initState();
    var repo = Repository();
    races = repo.fetchAllRaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: new Text('Races')),
        body: Center(
          child: FutureBuilder<RacesModel>(
            future: races,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget buildList(AsyncSnapshot<RacesModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.races.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
              child: InkResponse(
                  enableFeedback: true,
                  child: Image.network(
                    snapshot.data.races[index].image,
                    fit: BoxFit.fill,
                  ),
                  onTap: () =>
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RaceDetailScreen(
                              race: snapshot.data.races[index])))));
        });
  }
}
