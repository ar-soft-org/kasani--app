import 'dart:developer';

import 'package:dio/dio.dart';

class DioInterceptor {
  DioInterceptor({required Dio dio}) : _dio = dio;

  final Dio _dio;

  addInterceptor(Map<String, dynamic> headers) {
    log('add Interceptors');
    inspect(headers);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers.addAll(headers);
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );
  }

  removeInterceptors() {
    log('removeInterceptors');
    _dio.interceptors.clear();
  }
}
