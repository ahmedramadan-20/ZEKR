import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/quran/data/models/surah_response.dart';
import '../../features/quran/data/models/surah_detail_response.dart';
import 'arabic_utils.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(
      'quran_v2.db',
    ); // Changed db name to force recreation
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Increment version
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old tables and recreate
      await db.execute('DROP TABLE IF EXISTS surahs');
      await db.execute('DROP TABLE IF EXISTS surah_details');
      await _createDB(db, newVersion);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Surahs table
    await db.execute('''
      CREATE TABLE surahs (
        number INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        englishName TEXT NOT NULL,
        englishNameTranslation TEXT NOT NULL,
        numberOfAyahs INTEGER NOT NULL,
        revelationType TEXT NOT NULL
      )
    ''');

    // Surah details table (stores complete surah with ayahs as JSON)
    await db.execute('''
      CREATE TABLE surah_details (
        number INTEGER PRIMARY KEY,
        data TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  // Rest of your methods remain the same...
  // Surahs CRUD
  Future<void> insertSurahs(List<Surah> surahs) async {
    final db = await database;
    final batch = db.batch();

    for (var surah in surahs) {
      batch.insert(
        'surahs',
        surah.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Surah>> getSurahs() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'surahs',
      orderBy: 'number ASC',
    );

    return result.map<Surah>((Map<String, dynamic> json) {
      return Surah.fromJson(json);
    }).toList();
  }

  Future<Surah?> getSurahById(int surahNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'surahs',
      where: 'number = ?',
      whereArgs: [surahNumber],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return Surah.fromJson(result.first);
  }

  Future<bool> hasSurahs() async {
    final db = await database;
    final result = await db.query('surahs', limit: 1);
    return result.isNotEmpty;
  }

  // Surah Details CRUD
  Future<void> insertSurahDetail(SurahDetail surahDetail) async {
    final db = await database;
    await db.insert('surah_details', {
      'number': surahDetail.number,
      'data': jsonEncode(surahDetail.toJson()),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<SurahDetail?> getSurahDetail(int surahNumber) async {
    final db = await database;
    final result = await db.query(
      'surah_details',
      where: 'number = ?',
      whereArgs: [surahNumber],
    );

    if (result.isEmpty) return null;

    final Map<String, dynamic> data =
        jsonDecode(result.first['data'] as String) as Map<String, dynamic>;
    return SurahDetail.fromJson(data);
  }

  Future<bool> hasSurahDetail(int surahNumber) async {
    final db = await database;
    final result = await db.query(
      'surah_details',
      where: 'number = ?',
      whereArgs: [surahNumber],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('surahs');
    await db.delete('surah_details');
  }

  // Search Ayahs by text (diacritic-insensitive)
  Future<List<Map<String, dynamic>>> searchAyahs(String query) async {
    try {
      final db = await database;
      final results = <Map<String, dynamic>>[];

      // Get all surah details
      final surahDetailsResult = await db.query('surah_details');

      for (var row in surahDetailsResult) {
        final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
        final surahDetail = SurahDetail.fromJson(data);

        // Search through ayahs (ignore diacritics)
        for (var ayah in surahDetail.ayahs) {
          if (ArabicUtils.containsIgnoreDiacritics(ayah.text, query)) {
            results.add({'surahDetail': surahDetail, 'ayah': ayah});
          }
        }
      }

      return results;
    } catch (e) {
      return [];
    }
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
