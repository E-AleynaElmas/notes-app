import 'package:notes_app/product/models/pagination_info.dart';

class SimpleResult<T> {
  final bool status;
  final String? message;
  final T? data;
  final PaginationInfo? pagination;

  SimpleResult({required this.status, this.message, this.data, this.pagination});

  factory SimpleResult.fromJson(Map<String, dynamic> json) =>
      SimpleResult(status: json["status"] ?? json["success"] ?? false, message: json["message"], data: json["data"]);
}

abstract class GenericResponse<T> {
  T fromJson(Map<String, dynamic> json);
}
