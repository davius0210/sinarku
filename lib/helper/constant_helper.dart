class ConstantHelper {
  static String title_apps = 'Sinar Mobile'; 
  static String version_apps = '1.0.0'; 
  static String base_url = 'https://'; 
  static const esriImagery =
      "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";

  // Bing perlu key, sementara contoh tanpa validasi
  static String bing(String apiKey) =>
      "https://dev.virtualearth.net/REST/V1/Imagery/Metadata/Aerial/{z}/{y}/{x}?key=$apiKey";

  static const fotoUdara = // contoh indonesia BIG jika punya server lokal
      "https://tanahair.indonesia.go.id/arcgis/rest/services/RBI/Basemap/MapServer/tile/{z}/{y}/{x}";

  static const citraSatelit =
      "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png"; // contoh bebas ganti Maxar / Sentinel
}