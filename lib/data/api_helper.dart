class ApiHelper {
  static const String baseUrl = 'https://sinardev.com';
  static const Map<String, String> api = {
    // Auth
    'register': '/api/auth/register',
    'login': '/api/auth/login',
    'logout': '/api/auth/logout',
    'refresh': '/api/auth/refresh',
    'me': '/api/auth/me',
    // Gazetteer
    'gezetter': '/api/gazetteers',
    'gezetter/:id': '/api/gazetteers/{id}',
    // Region
    'region': '/api/regions',
    'region/:id': '/api/regions/{id}',
    // Toponym
    'toponym': '/api/toponyms',
    'toponym/:id': '/api/toponyms/{id}',
    'toponym/:id/photos': '/api/toponyms/{id}/photos',
    'toponym/nearby': '/api/toponyms/spatial/nearby',
    'toponym/boundingbox': '/api/toponyms/spatial/bounding-box',
    'toponym/geojson': '/api/toponyms/spatial/geojson',
    // User
    'user': '/api/users',
    'user/:id': '/api/users/{id}',
    // Verify Toponym
    'verify-toponym': '/api/verify-toponyms',
    'verify-toponym/:id': '/api/verify-toponyms/{id}',
    // Upload Image
    'upload-image': '/api/upload/image',
    // Verifikasi Kandidat/Transaksi
    'verify-candidate': '/api/verifications/transaction/candidates',
    'verify-transaction': '/api/verifications/transaction',
    // Toponym Clasification
    'toponym-classification-all': '/api/classification/all',
    'toponym-classification-category': '/api/classification/categories',
    'toponym-classification-subcategory': '/api/classification/subcategories',
    'toponym-classification-element': '/api/classification/elements',
  };
}
