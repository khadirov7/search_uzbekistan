import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import '../models/region_model.dart';

class PlacesDatabase {
  static final PlacesDatabase instance = PlacesDatabase._init();

  PlacesDatabase._init();

  factory PlacesDatabase() {
    return instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('places.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final script = await rootBundle.loadString('assets/places/regions.sql');
    final statements = script.split(';');

    for (final statement in statements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    final db = await instance.database;
    return await db.rawQuery(query);
  }

  Future<List<T>> _search<T>(String table, String query, T Function(Map<String, dynamic>) fromJson) async {
    final db = await instance.database;
    final result = await db.query(
      table,
      where: 'LOWER(name) LIKE ?',
      whereArgs: ['%${query.toLowerCase()}%'],
    );
    return result.map(fromJson).toList();
  }

  Future<List<RegionModel>> searchRegionsByName(String query) => _search('regions', query, (json) => RegionModel.fromJson(json));
  Future<List<DistrictModel>> searchDistrictsByName(String query) => _search('districts', query, (json) => DistrictModel.fromJson(json));
  Future<List<QuarterModel>> searchQuartersByName(String query) => _search('quarters', query, (json) => QuarterModel.fromJson(json));


  Future<List<RegionModel>> getAllRegions() async {
    final db = await instance.database;
    final result = await db.query('regions');
    return result.map((json) => RegionModel.fromJson(json)).toList();
  }

  Future<List<DistrictModel>> getAllDistricts() async {
    final db = await instance.database;
    final result = await db.query('districts');
    return result.map((json) => DistrictModel.fromJson(json)).toList();
  }

  Future<List<QuarterModel>> getAllQuarters() async {
    final db = await instance.database;
    final result = await db.query('quarters');
    return result.map((json) => QuarterModel.fromJson(json)).toList();
  }
}
