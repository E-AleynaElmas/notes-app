import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:notes_app/product/constants/product_constants.dart';
import 'package:notes_app/product/models/simple_result.dart';


enum RequestType { get, post, put, delete, patch }

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init();
  final Dio _dio = Dio(BaseOptions(baseUrl: ProductConstants.instance.apiUrl, contentType: 'application/json'));

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<SimpleResult> request<T>(
    RequestType requestType,
    String path, {
    String? baseUrl,
    FromJson<T>? fromJson,
    dynamic data,
    dynamic model,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isBaseResponse = true,
    isFile = false,
  }) async {
    var time = DateTime.now();
    try {
      data ??= {};
      Object? body = data is Map || data is FormData ? data : data.toJson();
      if (baseUrl != null) {
        _dio.options.baseUrl = baseUrl;
      }
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }
      var response = await _dio.request(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(contentType: isFile ? 'multipart/form-data' : 'application/json', method: requestType.name),
      );

      if (kDebugMode) {
        print('$path -> ${(DateTime.now().difference(time)).inMilliseconds} ms');
      }
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        if (isBaseResponse) {
          return _simpleResultConverter<T>(response.data, fromJson);
        } else {
          return SimpleResult(status: true, data: response.data);
        }
      } else {
        return _showError<T>(
          '$path ${requestType.name}',
          'Status Code: ${response.statusCode} | Status Message: ${response.statusMessage}',
          response.data,
          time,
        );
      }
    } on DioException catch (dioError) {
      if (kDebugMode) {
        print(dioError.toString());
      }
      return _showError<T>(
        '$path ${requestType.name}',
        'Error: ${dioError.error} | Status Message: ${dioError.message}',
        dioError.response?.data,
        time,
      );
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return _showError('$path ${requestType.name}', error, null, time);
    }
  }

  SimpleResult<T> _showError<T>(String errorPoint, dynamic error, dynamic responseData, DateTime time) {
    String? message = 'Sunucu ile ilgili bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.';
    if (responseData != null && responseData is Map && responseData.containsKey('errorMessage')) {
      message = responseData['errorMessage'];
    }
    log('$errorPoint FAILED | Status Code: $error');
    if (kDebugMode) {
      print('$errorPoint -> ${(DateTime.now().difference(time)).inMilliseconds} ms');
    }
    return SimpleResult(status: false, message: message);
  }

  SimpleResult _simpleResultConverter<T>(dynamic data, FromJson<T>? fromJson) {
    final baseResponse = SimpleResult.fromJson(data);
    if (baseResponse.status) {
      if (baseResponse.data != null) {
        if (baseResponse.data is List) {
          var list = <T>[];
          for (var element in (baseResponse.data as List)) {
            list.add(fromJson!(element));
          }
          return SimpleResult<List<T>>(status: true, data: list);
        } else {
          return SimpleResult<T>(status: true, data: fromJson!(baseResponse.data));
        }
      } else {
        return SimpleResult(status: false);
      }
    } else {
      return SimpleResult(status: false, message: baseResponse.message);
    }
  }
}