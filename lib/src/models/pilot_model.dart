// To parse this JSON data, do
//
//     final pilotsModel = pilotsModelFromJson(jsonString);

import 'dart:convert';

import 'dart:math';

PilotsModel pilotsModelFromJson(String str) =>
    PilotsModel.fromJson(json.decode(str));

String pilotsModelToJson(PilotsModel data) => json.encode(data.toJson());

class PilotsModel {
  List<Pilot> pilots;

  PilotsModel({
    this.pilots,
  });

  factory PilotsModel.fromJson(Map<String, dynamic> json) => PilotsModel(
        pilots: List<Pilot>.from(json["pilots"].map((x) => Pilot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pilots": List<dynamic>.from(pilots.map((x) => x.toJson())),
      };

  factory PilotsModel.fromDb(List<Map<String, dynamic>> json) {
    List<Pilot> pilots = new List();
    for (int i = 0; i < json.length; i++) {
      pilots.add(new Pilot(name: json[i]["name"],bikeName: json[i]['bike_name'],engineSize: json[i]['engine_size'],raceId:json[i]['race_id']));
    }
    return new PilotsModel(pilots: pilots);
  }
}

class Pilot {
  String name;
  String bikeName;
  int engineSize;
  int raceId;

  Pilot({
    this.name,
    this.bikeName,
    this.engineSize,
    this.raceId
  });

  Pilot.normal(String name, String bikeName, int engineSize,{int raceId=0}) {
    this.name = name;
    this.bikeName = bikeName;
    this.engineSize = engineSize;
    this.raceId = raceId;
  }

  factory Pilot.fromJson(Map<String, dynamic> json) => Pilot(
        name: json["name"],
        bikeName: json["bike_name"],
        engineSize: json["engine_size"],
        raceId: json["race_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "bike_name": bikeName,
        "engine_size": engineSize,
        "race_id":raceId,
      };

  Map<String, dynamic> toMapForDb() =>
      <String, dynamic>{
      "name":name,
      "bike_name": bikeName,
      "engine_size": engineSize,
      "race_id":raceId,
    };
}
