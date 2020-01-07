import 'dart:async';
import 'dart:io';

import 'package:cmobile/src/api/requestRacesApi.dart';
import 'package:cmobile/src/database/database_helper.dart';
import 'package:cmobile/src/models/pilot_model.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/screens/pilots_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' show Client;


class Repository {
  final racesApiProvider = RacesApiProvider();
  final db = DatabaseHelper.instance;

  List<Source> sources = <Source>[
    RacesApiProvider(),
    DatabaseHelper.instance,
  ];

  List<Cache> caches = <Cache>[DatabaseHelper.instance];

/*  Future<RacesModel> fetchAllRaces() => racesApiProvider.fetchRaces();*/
  /*Future<PilotsModel> fetchRacePilots(id) => racesApiProvider.fetchRacePilots(id);*/

  Future<Pilot> registerPilot(id, Pilot pilot) {
    print("Repositorio register Pilot");
    Future<Pilot> new_pilot;
      new_pilot = racesApiProvider.registerPilot(id, pilot.toJson());
      return new_pilot;
  }


  /// Buscar item na base de dados
  /// se nao tiver ai há api e guardar na base de dados
  Future<RacesModel> fetchAllRaces() async {
    RacesModel item;
    Client client = Client();
    print("teste");
    var source;
    for (source in sources) {
      item = await source.fetchRaces(client);
      print("fetch races $item");
      if (item != null) {
        break;
      }
    }
    for (var cache in caches) {
      if (cache != source) {
        print("update database");
        cache.clear();
        cache.addRaceModel(item);
      }
    }
    return item;
  }

  Future<PilotsModel> fetchRacePilots(int id) async {
    PilotsModel item;
    var source;
    for (source in sources) {
      item = await source.fetchRacePilots(id);
      if (item != null) {
        print("fetched data");
        break;
      }
    }
    for (var cache in caches) {
      if (cache != source) {
        print("update database");
        cache.addPilotModel(item);
      }
    }
    return item;
  }
}

abstract class Source {
  Future<RacesModel> fetchRaces(Client client);

  Future<PilotsModel> fetchRacePilots(int id);
}

abstract class Cache {
  Future<int> addRaceModel(RacesModel races);

  Future<int> addPilotModel(PilotsModel races);

  Future<int> clear();
}
