import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' show Client;

import 'package:cmobile/src/models/pilot_model.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cmobile/src/resources/repository.dart';

class DatabaseHelper implements Source, Cache {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 3;

  static final table = 'users';
  static final tablePilots = 'pilots';
  static final tableRaces = 'races';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'age';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    print('start_database');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print('criar');
    await db.execute("""
      CREATE TABLE $table
      (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
      """);

    await db.execute("""
      CREATE TABLE $tableRaces
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        latitude TEXT,
        longitude TEXT,
        image TEXT 
          )
      """);

    await db.execute("""
      CREATE TABLE $tablePilots
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        bike_name TEXT,
        engine_size INTEGER,
        race_id INTEGER,
        FOREIGN KEY (race_id) REFERENCES $tableRaces (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      """);
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  /* // Retrieving user from User Tables
  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["firstname"], list[i]["lastname"], list[i]["mobileno"], list[i]["emailid"]));
    }
    print(employees.length);
    return employees;
  }*/

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

//Returns User name
  Future<Map<String, dynamic>> queryUserName() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> records = await db.query('$table');
    return records.first;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future<PilotsModel> fetchRacePilots(int id) async {
    Database db = await instance.database;
    final list = await db.query(
      "$tablePilots",
      columns: null,
      where: "race_id = ?",
      whereArgs: [id],
    );
    list.forEach((row) => print(row));
    if (list.length > 0) {
      return PilotsModel.fromDb(list);
    }
    return null;
  }

  @override
  Future<RacesModel> fetchRaces(Client client) async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM $tableRaces');
    if (list.length > 0) {
      List<Race> races = new List();
      for (int i = 0; i < list.length; i++) {
        races.add(new Race(
            id: list[i]["id"],
            name: list[i]["name"],
            image: list[i]["image"],
            latitude: list[i]["latitude"],
            longitude: list[i]["longitude"]));
      }
      print("race,${races}");
      return RacesModel(races: races);
    }
    return null;
  }

  @override
  Future<int> addRaceModel(RacesModel model) async {
    Database db = await instance.database;
    for (int i = 0; i < model.races.length; i++) {
      db.insert("$tableRaces", model.races[i].toJson());
    }
    return 0;
  }

  @override
  Future<int> addPilotModel(PilotsModel model) async {
    Database db = await instance.database;
    for (int i = 0; i < model.pilots.length; i++) {
      db.insert("$tablePilots", model.pilots[i].toJson());
    }
    return 1;
  }

  Future<int> addRegisteredPilot(int raceId, pilot) async {
    print("$raceId,Insert on database Registered Pilot");
    Database db = await instance.database;
    return db.insert("$tablePilots", pilot.toMapForDb());
  }

  @override
  Future<int> clear() async {
    print("Delete All");
    Database db = await instance.database;
    db.delete("$tablePilots");
    return db.delete("$tableRaces");
  }

  @override
  Future<int> deleteRacePilots(int id) async {
    Database db = await instance.database;
    print("update database by deleting old");
    return await db
        .delete("$tablePilots", where: 'race_id = ?', whereArgs: [id]);
  }
}
