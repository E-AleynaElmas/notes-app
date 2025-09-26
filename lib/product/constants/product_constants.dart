class ProductConstants {
  static ProductConstants? _instance;
  static ProductConstants get instance {
    _instance ??= ProductConstants._init();
    return _instance!;
  }

  ProductConstants._init();

  final String appName = 'Notes app';
  final String institutionalUrl = 'https://www.getvenlo.com/';
  static const String basePath = 'panel.getvenlo.com';
  static const String baseUrl = 'https://$basePath';
  static const String socketUrl = 'wss://$basePath';
  final String apiUrl = '$baseUrl/api/';
}
