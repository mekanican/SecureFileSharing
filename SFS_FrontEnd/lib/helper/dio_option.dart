import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_URL'] ?? "http://localhost:8000/api",
  connectTimeout: const Duration(milliseconds: 20000),
  receiveTimeout: const Duration(milliseconds: 20000),
  contentType: 'application/json',
  validateStatus: (status) {
    return status! < 500;
  },
);

BaseOptions baseOptions2 = BaseOptions(
  baseUrl: dotenv.env['API_URL_2'] ?? "http://localhost:9087/api",
  connectTimeout: const Duration(milliseconds: 20000),
  receiveTimeout: const Duration(milliseconds: 20000),
  contentType: 'application/json',
  validateStatus: (status) {
    return status! < 500;
  },
);
