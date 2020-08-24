import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'Record.dart';
import 'package:path_provider/path_provider.dart';


class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String ADRESS1 = 'adress1';
  static const String ADREDS2 = 'adress2';
  static const String LATITUDE1 = 'latitude1';
  static const String LONGITUDE1 = 'longitude1';
  static const String LATITUDE2 = 'latitude2';
  static const String LONGITUDE2 = 'longitude2';
  static const String DATE = 'date';
  static const String DISTANCIA = 'distancia';
  static const String USUARIO = 'usuario';
  static const String TABLE = 'Record';
  static const String DB_NAME = 'record.db';

  Future<Database> get db async{
    if (_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
  
  _onCreate(Database db, int version) async{
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $ADRESS1 TEXT, $ADREDS2 TEXT, $LATITUDE1 TEXT, $LONGITUDE1 TEXT, $LATITUDE2 TEXT, $LONGITUDE2 TEXT, $DATE TEXT, $DISTANCIA TEXT, $USUARIO TEXT)");
  }

  Future<Record> save(Record record) async{
    var dbClient = await db;
    record.id = await dbClient.insert(TABLE, record.toMap());
    return record;

    /*await dbClient.transaction((txn) async{
      var query = "INSERT INTO $TABLE ($ADRESS1,$ADREDS2,$LATITUDE1,$LONGITUDE1,$LATITUDE2,$LONGITUDE2) "
          "VALUES ('"+record.adrres1+"','"+record.adrres2+"','"+record.latitude1+"','"+record.longitude1+"','"+record.latitude2+"','"+record.longitude2+"')";
      return await txn.rawInsert(query);
    });*/
  }

  Future<List<Record>> getRecords() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, ADRESS1, ADREDS2, LATITUDE1, LONGITUDE1, LATITUDE2, LONGITUDE2, DATE, DISTANCIA, USUARIO]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Record> records = [];
    if(maps.length>0){
      for(int i=0; i<maps.length; i++){
        records.add(Record.fromMap(maps[i]));
      }
    }
    return records;
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Record record) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, record.toMap(),
        where: '$ID = ?', whereArgs: [record.id]);
  }

  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}