class LocationModel {
  final String provinceName;
  final int provinceId;
  final String cityName;
  final int cityId;
  final Map<String, dynamic> rawOsm;

  LocationModel({
    required this.provinceName,
    required this.provinceId,
    required this.cityName,
    required this.cityId,
    required this.rawOsm,
  });
}
