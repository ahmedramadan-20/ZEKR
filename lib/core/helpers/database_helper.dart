import 'dart:convert';
import 'package:flutter/foundation.dart';
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
    _database = await _initDB('quran_v3.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS surahs');
      await db.execute('DROP TABLE IF EXISTS surah_details');
      await _createDB(db, newVersion);
    }

    if (oldVersion < 3) {
      // Create FTS table
      await db.execute('''
        CREATE VIRTUAL TABLE IF NOT EXISTS ayahs_search USING fts4(
          surahNumber,
          ayahNumber,
          text_clean,
          text_original,
          page,
          json_data,
          tokenize = 'unicode61'
        )
      ''');

      // Repopulate FTS from existing data
      await _repopulateFTS(db);
    }
    if (oldVersion < 4) {
      // Force recreate FTS table to ensure it uses fts4 and is populated
      await db.execute('DROP TABLE IF EXISTS ayahs_search');
      await db.execute('''
        CREATE VIRTUAL TABLE ayahs_search USING fts4(
          surahNumber,
          ayahNumber,
          text_clean,
          text_original,
          page,
          json_data,
          tokenize = 'unicode61'
        )
      ''');
      await _repopulateFTS(db);
    }
  }

  Future<void> _repopulateFTS(Database db) async {
    try {
      final surahDetails = await db.query('surah_details');
      if (surahDetails.isEmpty) return;

      final batch = db.batch();
      for (var row in surahDetails) {
        final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
        final surahDetail = SurahDetail.fromJson(data);
        _addSurahToFTSBatch(batch, surahDetail);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      // Ignore errors during migration
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

    // Surah details table
    await db.execute('''
      CREATE TABLE surah_details (
        number INTEGER PRIMARY KEY,
        data TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    // FTS5 Virtual Table for Search
    await db.execute('''
      CREATE VIRTUAL TABLE ayahs_search USING fts4(
        surahNumber,
        ayahNumber,
        text_clean,
        text_original,
        page,
        json_data,
        tokenize = 'unicode61'
      )
    ''');
  }

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

    return result.map<Surah>((json) => Surah.fromJson(json)).toList();
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

    // Offload heavy processing to isolate
    final preparedData = await compute(_prepareSurahInsertion, surahDetail);

    // 1. Insert into main storage
    await db.insert('surah_details', {
      'number': preparedData['number'],
      'data': preparedData['surahJson'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // 2. Insert into FTS (delete old entries first)
    await db.delete(
      'ayahs_search',
      where: 'surahNumber = ?',
      whereArgs: [preparedData['number']],
    );

    final batch = db.batch();
    final ayahsData = preparedData['ayahsData'] as List<Map<String, dynamic>>;

    for (var ayah in ayahsData) {
      batch.insert('ayahs_search', ayah);
    }

    await batch.commit(noResult: true);
  }

  // Helper for migration (runs on main thread as it's rare)
  void _addSurahToFTSBatch(Batch batch, SurahDetail surahDetail) {
    for (var ayah in surahDetail.ayahs) {
      batch.insert('ayahs_search', {
        'surahNumber': surahDetail.number,
        'ayahNumber': ayah.numberInSurah,
        'text_clean': ArabicUtils.normalizeForSearch(ayah.text),
        'text_original': ayah.text,
        'page': ayah.page,
        'json_data': jsonEncode(ayah.toJson()),
      });
    }
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
    await db.delete('ayahs_search');
  }

  // Search Ayahs using FTS
  Future<List<Map<String, dynamic>>> searchAyahs(String query) async {
    try {
      final db = await database;
      final normalizedQuery = ArabicUtils.normalizeForSearch(query);

      if (normalizedQuery.isEmpty) return [];

      // Self-healing: Check if FTS table is empty
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT count(*) FROM ayahs_search'),
      );
      if (count == 0) {
        await _repopulateFTS(db);
      }

      // 1. Try FTS MATCH with tokenized prefix query (supports multi-word)
      final tokens = normalizedQuery.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
      final ftsQuery = tokens.isEmpty ? '$normalizedQuery*' : tokens.map((t) => '$t*').join(' AND ');

      List<Map<String, Object?>> results = [];
      try {
        results = await db.rawQuery(
          '''
          SELECT 
            s.number as surahNumber,
            COALESCE(s.name, '') as surahName,
            COALESCE(s.englishName, '') as englishName,
            COALESCE(s.englishNameTranslation, '') as englishNameTranslation,
            COALESCE(s.revelationType, '') as revelationType,
            COALESCE(s.numberOfAyahs, 0) as numberOfAyahs,
            fts.json_data as ayahJson
          FROM ayahs_search fts
          LEFT JOIN surahs s ON fts.surahNumber = s.number
          WHERE fts.text_clean MATCH ?
          ORDER BY fts.surahNumber, fts.ayahNumber
          LIMIT 50
        ''',
          [ftsQuery],
        );
      } catch (_) {
        // Ignore MATCH errors and fallback to LIKE
      }

      // 2. Fallback to LIKE if FTS returns empty or MATCH failed
      if (results.isEmpty) {
        results = await db.rawQuery(
          '''
          SELECT 
            s.number as surahNumber,
            COALESCE(s.name, '') as surahName,
            COALESCE(s.englishName, '') as englishName,
            COALESCE(s.englishNameTranslation, '') as englishNameTranslation,
            COALESCE(s.revelationType, '') as revelationType,
            COALESCE(s.numberOfAyahs, 0) as numberOfAyahs,
            fts.json_data as ayahJson
          FROM ayahs_search fts
          LEFT JOIN surahs s ON fts.surahNumber = s.number
          WHERE fts.text_clean LIKE ?
          ORDER BY fts.surahNumber, fts.ayahNumber
          LIMIT 100
        ''',
          ['%' + normalizedQuery.replaceAll(' ', '%') + '%'],
        );
      }

      // 3. Legacy fallback: scan JSON if still empty (rare)
      if (results.isEmpty) {
        final rows = await db.query('surah_details');
        final legacyOut = <Map<String, dynamic>>[];
        for (var row in rows) {
          if (legacyOut.length >= 50) break;
          final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
          final detail = SurahDetail.fromJson(data);
          for (var ayah in detail.ayahs) {
            if (ArabicUtils.containsIgnoreDiacritics(ayah.text, query)) {
              legacyOut.add({
                'surahDetail': SurahDetail(
                  number: detail.number,
                  name: detail.name,
                  englishName: detail.englishName,
                  englishNameTranslation: detail.englishNameTranslation,
                  revelationType: detail.revelationType,
                  numberOfAyahs: detail.numberOfAyahs,
                  ayahs: [],
                ),
                'ayah': ayah,
              });
              if (legacyOut.length >= 50) break;
            }
          }
        }
        return legacyOut;
      }

      return results.map((row) {
        final ayah = Ayah.fromJson(jsonDecode(row['ayahJson'] as String));

        final surahDetail = SurahDetail(
          number: row['surahNumber'] as int,
          name: row['surahName'] as String,
          englishName: row['englishName'] as String,
          englishNameTranslation: row['englishNameTranslation'] as String,
          revelationType: row['revelationType'] as String,
          numberOfAyahs: row['numberOfAyahs'] as int,
          ayahs: [],
        );

        return {'surahDetail': surahDetail, 'ayah': ayah};
      }).toList();
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

// Top-level function for compute()
Map<String, dynamic> _prepareSurahInsertion(SurahDetail detail) {
  final ayahsData = <Map<String, dynamic>>[];

  for (var ayah in detail.ayahs) {
    ayahsData.add({
      'surahNumber': detail.number,
      'ayahNumber': ayah.numberInSurah,
      'text_clean': ArabicUtils.normalizeForSearch(ayah.text),
      'text_original': ayah.text,
      'page': ayah.page,
      'json_data': jsonEncode(ayah.toJson()),
    });
  }

  return {
    'number': detail.number,
    'surahJson': jsonEncode(detail.toJson()),
    'ayahsData': ayahsData,
  };
}
