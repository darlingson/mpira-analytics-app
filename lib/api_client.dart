import 'package:dio/dio.dart';
import 'package:mpira_analytics_app/models/competitions_home.dart';
import 'package:mpira_analytics_app/models/overview_models.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://mpira-metrics-api.vercel.app/api/v1',
        connectTimeout: const Duration(seconds: 15), 
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<CompetitionsHome> getCompetitionsHomepage() async {
    try {
      final response = await _dio.get('/competitions');
      return CompetitionsHome.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCompetitionDetails(int id) async {
    return await _dio.get('/users/$id');
  }

Future<Overview?> getOverview() async {
    try {
      final response = await _dio.get('/overview');
      
      if (response.statusCode == 200) {
        return Overview.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("API Error: $e");
      rethrow; // Catch this in your FutureBuilder
    }
  }
}
