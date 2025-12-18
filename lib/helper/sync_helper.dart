import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// ================================
/// MODEL SYNC ITEM
/// ================================
class SyncItem {
  final int? id;
  final String endpoint;
  final String method; // POST, PUT, DELETE
  final Map<String, dynamic> payload;
  final int isSynced; // 0 = belum, 1 = sudah
  final String createdAt;

  SyncItem({
    this.id,
    required this.endpoint,
    required this.method,
    required this.payload,
    this.isSynced = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'endpoint': endpoint,
    'method': method,
    'payload': jsonEncode(payload),
    'is_synced': isSynced,
    'created_at': createdAt,
  };
}

/// ================================
/// DATABASE HELPER
/// ================================
class LocalSyncDB {
  static final LocalSyncDB instance = LocalSyncDB._internal();
  static Database? _database;

  LocalSyncDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'sync_queue.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sync_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            endpoint TEXT,
            method TEXT,
            payload TEXT,
            is_synced INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');
      },
    );
  }

  /// SIMPAN DATA KE QUEUE (OFFLINE / GAGAL API)
  Future<int> insertQueue(SyncItem item) async {
    final db = await database;
    return await db.insert('sync_queue', item.toMap());
  }

  /// AMBIL DATA BELUM SYNC
  Future<List<Map<String, dynamic>>> getUnsynced() async {
    final db = await database;
    return await db.query('sync_queue', where: 'is_synced = 0');
  }

  /// UPDATE STATUS SYNC
  Future<void> markAsSynced(int id) async {
    final db = await database;
    await db.update(
      'sync_queue',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

/// ================================
/// SYNC SERVICE
/// ================================
class SyncService {
  final Dio dio;

  SyncService(this.dio);

  /// KIRIM DATA ATAU SIMPAN KE LOCAL
  Future<void> sendOrQueue({
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      await _saveToLocal(endpoint, method, payload);
      return;
    }

    try {
      await _sendToServer(endpoint, method, payload);
    } catch (_) {
      await _saveToLocal(endpoint, method, payload);
    }
  }

  /// SYNC ULANG SAAT ONLINE
  Future<void> syncPending() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    final items = await LocalSyncDB.instance.getUnsynced();

    for (final item in items) {
      try {
        await _sendToServer(
          item['endpoint'],
          item['method'],
          jsonDecode(item['payload']),
        );
        await LocalSyncDB.instance.markAsSynced(item['id']);
      } catch (_) {
        // biarkan, akan dicoba ulang
      }
    }
  }

  Future<void> _sendToServer(
    String endpoint,
    String method,
    Map<String, dynamic> payload,
  ) async {
    switch (method) {
      case 'POST':
        await dio.post(endpoint, data: payload);
        break;
      case 'PUT':
        await dio.put(endpoint, data: payload);
        break;
      case 'DELETE':
        await dio.delete(endpoint, data: payload);
        break;
    }
  }

  Future<void> _saveToLocal(
    String endpoint,
    String method,
    Map<String, dynamic> payload,
  ) async {
    await LocalSyncDB.instance.insertQueue(
      SyncItem(
        endpoint: endpoint,
        method: method,
        payload: payload,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }
}

/// ================================
/// CONTOH PEMAKAIAN
/// ================================
/*
final dio = Dio(BaseOptions(baseUrl: 'https://api.server.com'));
final syncService = SyncService(dio);

// SIMPAN DATA
await syncService.sendOrQueue(
  endpoint: '/ticket',
  method: 'POST',
  payload: {'title': 'Error App', 'desc': 'Crash'},
);

// PANGGIL SETIAP APP OPEN / INTERNET ON
await syncService.syncPending();
*/
