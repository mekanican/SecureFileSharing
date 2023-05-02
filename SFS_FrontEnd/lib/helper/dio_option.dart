import 'package:dio/dio.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: 'http://localhost:8000/api',
  connectTimeout: const Duration(milliseconds: 20000),
  receiveTimeout: const Duration(milliseconds: 20000),
  contentType: 'application/json',
  validateStatus: (status) {
    return status! < 500;
  },
);
