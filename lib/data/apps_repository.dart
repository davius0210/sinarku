import 'package:dio/dio.dart';
import 'package:sinarku/data/api_helper.dart';
import 'package:sinarku/data/dio_client.dart';

class AppRepository {
  final Dio _dio = DioClient().dio;

  // --- AUTH SECTION ---
  Future<Response> login(String email, String password) async {
    return await _dio.post(
      ApiHelper.api['login']!,
      data: {'email': email, 'password': password},
    );
  }

  // Tambahkan ini di dalam class AppRepository yang sudah dibuat sebelumnya

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int org_id,
    String? phone,
    // Jika ada upload foto profil, tambahkan parameter filePath
    String? avatarFilePath,
  }) async {
    // Menyiapkan data body
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'org_id': org_id,
    };

    // Jika ada file gambar yang diupload
    if (avatarFilePath != null) {
      data['avatar'] = await MultipartFile.fromFile(
        avatarFilePath,
        filename: avatarFilePath.split('/').last,
      );
    }

    FormData formData = FormData.fromMap(data);

    return await _dio.post(
      ApiHelper.api['register']!,
      data: data, // Gunakan formData jika ada file, atau 'data' jika hanya json
      onSendProgress: (sent, total) {
        print("Progress Register: ${(sent / total * 100).toStringAsFixed(0)}%");
      },
    );
  }

  // --- TOPONYM SECTION ---

  // List Toponyms dengan filter (Pagination, Search, dll)
  Future<Response> getToponyms({int page = 1, String? search}) async {
    return await _dio.get(
      ApiHelper.api['toponym']!,
      queryParameters: {'page': page, if (search != null) 'search': search},
    );
  }

  // Detail Toponym menggunakan Dynamic Path
  Future<Response> getToponymDetail(int id) async {
    final path = ApiHelper.api['toponym/:id']!.replaceFirst(
      '{id}',
      id.toString(),
    );
    return await _dio.get(path);
  }

  // Spatial: Nearby (Mengambil data berdasarkan koordinat)
  Future<Response> getNearby(
    double lat,
    double lng, {
    double distance = 1000,
  }) async {
    return await _dio.get(
      ApiHelper.api['toponym/nearby']!,
      queryParameters: {
        'latitude': lat,
        'longitude': lng,
        'distance': distance,
      },
    );
  }

  // --- UPLOAD SECTION ---
  Future<Response> uploadToponymPhoto(int toponymId, String filePath) async {
    final path = ApiHelper.api['toponym/:id/photos']!.replaceFirst(
      '{id}',
      toponymId.toString(),
    );

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: 'photo.jpg'),
      'description': 'Uploaded via Flutter App',
    });

    return await _dio.post(path, data: formData);
  }

  Future<Response> uploadPhoto(String filePath) async {
    final path = ApiHelper.api['upload-image']!;

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    return await _dio.post(path, data: formData);
  }
}
