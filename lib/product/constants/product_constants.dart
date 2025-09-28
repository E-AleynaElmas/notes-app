class ProductConstants {
  static ProductConstants? _instance;
  static ProductConstants get instance {
    _instance ??= ProductConstants._init();
    return _instance!;
  }

  ProductConstants._init();

  final String appName = 'Notes app';
  final String institutionalUrl = 'https://www.api.notesapp.com';
  
  static const String localApiUrl = 'http://localhost:8000';
  final String apiUrl = '$localApiUrl/api/v1/';
}
