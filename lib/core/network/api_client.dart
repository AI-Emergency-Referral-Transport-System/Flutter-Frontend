import 'package:dio/dio.dart';

import '../config/app_config.dart';

class ApiClient {
  ApiClient({BaseOptions? options})
    : dio =
          Dio(
            options ??
                BaseOptions(
                  baseUrl: AppConfig.baseUrl,
                  connectTimeout: const Duration(seconds: 12),
                  receiveTimeout: const Duration(seconds: 20),
                  headers: const {'Content-Type': 'application/json'},
                ),
          );

  final Dio dio;
}
