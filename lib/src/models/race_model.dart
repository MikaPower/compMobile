// To parse this JSON data, do
//
//     final racesModel = racesModelFromJson(jsonString);

import 'dart:convert';

List<RacesModel> racesModelFromJson(String str) => List<RacesModel>.from(json.decode(str).map((x) => RacesModel.fromJson(x)));

String racesModelToJson(List<RacesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RacesModel {
  List<Race> races;

  RacesModel({
    this.races,
  });

  factory RacesModel.fromJson(Map<String, dynamic> json) => RacesModel(
    races: List<Race>.from(json["races"].map((x) => Race.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "races": List<dynamic>.from(races.map((x) => x.toJson())),
  };



}

class Race {
  int id;
  String name;
  String latitude;
  String longitude;
  String image;

  Race({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.image,
  });

  factory Race.fromJson(Map<String, dynamic> json) => Race(
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "image": image,
  };


}
