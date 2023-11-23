import 'dart:async';
import 'dart:io';
import '../model/model_timtTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'timeTable.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE timeTables(
      subjno INTEGER PRIMARY KEY,
      subjnm TEXT,
      pronm TEXT,
      day TEXT,
      start_t TEXT,
      clsroom TEXT,
      beaconid TEXT,
      end_t TEXT,
      att_t TEXT,
      out_t TEXT
    )
    ''');
  }
  Future drop() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'timeTable.db');
    return await deleteDatabase(
      path,
    );


  }
  Future _onDELETE(Database db, int version) async {
    await db.execute('''
    
    ''');
  }
  Future<int> add(Timetable tt) async {
    Database db = await instance.database;
    return await db.insert('timeTables',tt.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<int> add_raw(Timetable tt) async {
    Database db = await instance.database;
    return await db.rawInsert('''INSERT INTO timeTables(subjno,subjnm, pronm, day, start_t, clsroom, beaconid, end_t, att_t,out_t) VALUES ( CAST('${tt.subjno}' AS INTEGER), '${tt.subjnm}', '${tt.pronm}', '${tt.day.toString().substring(1,tt.day.toString().length - 1)}', '${tt.start_t.toString().substring(1,tt.start_t.toString().length - 1)}', '${tt.clsroom}', '${tt.beaconid}', '${tt.end_t.toString().substring(1,tt.end_t.toString().length-1)}','${tt.att_t.toString().substring(1,tt.att_t.toString().length-1)}','${tt.out_t.toString().substring(1,tt.out_t.toString().length-1)}')'''
    );
  }
  Future<Set<Timetable>> sd() async {
    Database db = await instance.database;
    var tt = await db.query('timeTables');
    Set<Timetable> tList = tt.isNotEmpty
        ? tt.map((c) => Timetable.fromMap(c)).toSet()
        : {};
    return tList;
  }
  Future<Set<Timetable>> getTimetable() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('timeTables');
    Set<Timetable> ls= {};
    ls=List.generate(data.length, (i) {
      return Timetable(
        subjno: data[i]['subjno'],
        subjnm: data[i]['subjnm'],
        pronm: data[i]['pronm'],
        day: data[i]['day'].split(','),
        start_t: data[i]['start_t'].split(','),
        clsroom: data[i]['clsroom'],
        beaconid: data[i]['beaconid'],
        end_t: data[i]['end_t'].split(','),
        att_t: data[i]['att_t'].split(','),
        out_t: data[i]['out_t'].split(','),
      );
    }).toSet();
    return ls;
  }
  Future<int> update(Timetable tt) async {
    Database db = await instance.database;
    return await db.update('timeTables', tt.toMap(),
        where: 'subjno = ?', whereArgs: [tt.subjno]);
  }
  Future<int> remove(Timetable tt) async {
    Database db = await instance.database;
    return await db.delete('timeTables', where: 'subjno = ?', whereArgs: [tt.subjno]);
  }
}