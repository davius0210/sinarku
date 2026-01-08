import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sinarku/data/dio_client.dart';
import 'package:sinarku/helper/sync_helper.dart';

class NetworkHelper {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Mulai memantau koneksi internet secara real-time.
  /// [onStatusChange] akan dipanggil setiap kali status berubah.
  void startMonitoring(Function(bool isOnline) onStatusChange) async {
    // Cek status awal
    final results = await _connectivity.checkConnectivity();
    final isOnline = _isConnected(results);
    onStatusChange(isOnline);

    // Pantau perubahan koneksi (stream terbaru mengembalikan List<ConnectivityResult>)
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = _isConnected(results);
      onStatusChange(isOnline);
      // Ini untuk nge sync data yang belum berhasil dikirim saat online
      if (results != ConnectivityResult.none) {
        final _dio = DioClient().dio;
        SyncService(_dio).syncPending();
      }
    });
  }

  /// Mengecek apakah perangkat benar-benar terhubung ke internet.
  bool _isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }

  /// Hentikan pemantauan koneksi
  void stopMonitoring() {
    _subscription?.cancel();
  }
}
