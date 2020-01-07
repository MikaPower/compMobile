import 'dart:async';
import 'dart:convert';
import 'package:cmobile/src/models/pilot_model.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:cmobile/src/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response, post;


class RacesApiProvider implements Source {
  Client client = Client();
  final _baseUrl = "http://127.0.0.1:8000/races";



  Future<Pilot> registerPilot(id, pilotJson) async {
    // set up POST request arguments
    print("api call to register pilot");
    Response response;
    String url = 'http://127.0.0.1:8000/races/$id/';
    Map<String, String> headers = {"Content-type": "application/json"};
    // make POST request
    try {
      response = await post(url, headers: headers, body: jsonEncode(pilotJson));
    } catch (err) {
      return Future.error("NO CONNECTING TO SERVER");
    }
    print("print after exception");
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 409) {
      /*throw "Pilot already registered";*/
      return Future.error("Pilot already registered with same bike name");
    }
    print(jsonEncode(pilotJson));
    print(statusCode);
    print(response.body);
    // this API passes back the id of the new item added to the body
    return Pilot.fromJson(json.decode(response.body)['pilot'][0]);
  }

  Future<PilotsModel> fetchRacePilots(id) async {
    try {
      final response = await client.get("$_baseUrl/$id/pilots");
      print(response.reasonPhrase);
      print(response.statusCode);
      print(response.body.toString());
      if (response.statusCode == 200) {
        return PilotsModel.fromJson(json.decode(response.body));
      } else {
        return Future.error("ERROR on getting race pilots");
      }
    } catch (err) {
      return null;
    }
  }




  Future<Post> fetchPost(Client client) async {
    final response =
    await client.get('https://jsonplaceholder.typicode.com/posts/1');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return Post.fromJson(json.decode(response.body));
    } else {
      print("wtf");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<RacesModel> fetchRaces(Client client) async {
    try {

      final response = await client.get("$_baseUrl");
      print("sucess api call");
      print(response.reasonPhrase);
      print(response.statusCode);
      print(response.body.toString());
      print(json.decode(response.body)[0]);
      print("TESTE AFTER PRINT");
      if (response.statusCode == 200) {
        print("sucess api call");
        return RacesModel.fromJson(json.decode(response.body)[0]);
      } else {
        throw Exception('Failed to load races');
      }
    } catch (err) {
      return null;
    }
  }
}

class Post {
  dynamic data;
  Post.fromJson(this.data);
}
