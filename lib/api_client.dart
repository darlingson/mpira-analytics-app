import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://mpira-metrics-api.vercel.app/api/v1',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // Define your endpoints as methods
  Future<Response> getCompetitionsHomepage() async {
    try {
      return await _dio.get('/competitions');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCompetitionDetails(int id) async {
    return await _dio.get('/users/$id');
  }
}