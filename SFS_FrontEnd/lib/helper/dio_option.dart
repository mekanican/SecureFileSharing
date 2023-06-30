import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_URL'] ?? "http://localhost:8000/api",
  connectTimeout: const Duration(minutes: 60), // 60mins Required to uploading file
  receiveTimeout: const Duration(minutes: 60),
  contentType: 'application/json',
  validateStatus: (status) {
    return status! < 500;
  },
);

BaseOptions baseOptions2 = BaseOptions(
  baseUrl: dotenv.env['API_URL_2'] ?? "http://localhost:9087/api",
  connectTimeout: const Duration(milliseconds: 60000),
  receiveTimeout: const Duration(milliseconds: 60000),
  contentType: 'application/json',
  validateStatus: (status) {
    return status! < 500;
  },
);
