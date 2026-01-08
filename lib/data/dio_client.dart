import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinarku/data/api_helper.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiHelper.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    // CATATAN: Hapus dio.options.validateStatus < 500 jika ingin interceptor onError
    // menangkap status 401 secara otomatis.

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Daftar endpoint yang TIDAK butuh token
          final publicEndpoints = [
            ApiHelper.api['login'],
            ApiHelper.api['register'],
          ];
          print(options.path);

          // Jika path saat ini tidak ada di daftar publik, baru tambahkan token
          if (!publicEndpoints.contains(options.path)) {
            final prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('token');

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Cek jika error adalah 401 (Token Expired)
          print(e.response?.toString());
          if (e.response?.statusCode == 401) {
            // Logika Refresh Token
            String? newToken = await _refreshToken();

            if (newToken != null) {
              // Update token di request yang gagal tadi
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              // Buat ulang request (Retry)
              final opts = Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
              );

              final response = await dio.request(
                e.requestOptions.path,
                options: opts,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );

              return handler.resolve(response);
            } else {
              // Jika refresh gagal (misal refresh token juga expired)
              // Paksa user login kembali
              print("Refresh token gagal, arahkan ke Login");
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    try {
      // Gunakan instance Dio baru (bukan dio utama) untuk menghindari infinite loop
      final refreshDio = Dio(BaseOptions(baseUrl: ApiHelper.baseUrl));

      // Ambil token lama untuk otentikasi refresh
      final sharedPreferences = await SharedPreferences.getInstance();
      final oldToken = sharedPreferences.getString('token');

      final response = await refreshDio.post(
        ApiHelper.api['refresh']!,
        options: Options(headers: {'Authorization': 'Bearer $oldToken'}),
      );

      if (response.statusCode == 200) {
        // Asumsi API SinarKu mengembalikan { "access_token": "..." }
        String newToken = response.data['access_token'];

        // SIMPAN TOKEN BARU KE STORAGE DISINI
        // await storage.write('token', newToken);

        return newToken;
      }
    } catch (e) {
      print("Error saat refresh token: $e");
    }
    return null;
  }
}
