import 'package:dio/dio.dart';
import 'package:sinarku/helper/constant_helper.dart';

class DioHelper {
  // SINGLETON
  static final DioHelper _instance = DioHelper._internal();
  factory DioHelper() => _instance;

  late final Dio dio;

  DioHelper._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ConstantHelper.base_url,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // INTERCEPTOR
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // token tarik dari sini
          final token = '';
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // optional: handle 401 refresh token
          if (error.response?.statusCode == 401) {
            // TODO refresh token
          }
          return handler.next(error);
        },
      ),
    );
  }
}
