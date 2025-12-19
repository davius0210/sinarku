import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sinarku/helper/sync_helper.dart';

class SyncService {
  final Dio dio;
  bool _isSyncing = false; // lock (anti double sync)

  SyncService(this.dio);

  /// SIMPAN ATAU KIRIM
  Future<void> sendOrQueue({
    required String endpoint,
    required String method,
    required SyncType type,
    required Map<String, dynamic> payload,
  }) async {
    try {
      await _send(endpoint, method, payload);
    } catch (_) {
      await _save(endpoint, method, type, payload);
    }
  }

  /// EVENT-BASED SYNC
  Future<void> syncPending() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final items = await LocalSyncDB.instance.getUnsynced();

      for (final item in items) {
        try {
          await _send(
            item['endpoint'],
            item['method'],
            jsonDecode(item['payload']),
          );
          await LocalSyncDB.instance.markAsSynced(item['id']);
        } catch (_) {
          break; // stop jika gagal, lanjut nanti
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _send(
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

  Future<void> _save(
    String endpoint,
    String method,
    SyncType type,
    Map<String, dynamic> payload,
  ) async {
    await LocalSyncDB.instance.insertQueue(
      SyncItem(
        endpoint: endpoint,
        method: method,
        payload: payload,
        type: type,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }
}
