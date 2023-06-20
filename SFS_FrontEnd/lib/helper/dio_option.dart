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
