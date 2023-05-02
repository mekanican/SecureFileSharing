import 'package:dio/dio.dart';

BaseOptions baseOptions = BaseOptions(
  baseUrl: 'http://localhost:8000/api',
  connectTimeout: const Duration(milliseconds: 5000),
  receiveTimeout: const Duration(milliseconds: 5000),
  contentType: 'application/json',
);