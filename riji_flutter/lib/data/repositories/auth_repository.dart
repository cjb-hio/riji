import 'package:dio/dio.dart';
import 'package:riji_flutter/core/api/api_client.dart';
import 'package:riji_flutter/core/api/api_exception.dart';
import 'package:riji_flutter/data/models/auth_response.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  String _parseErrorMessage(dynamic error) {
    if (error is DioException && error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
    }
    if (error is DioException && error.type == DioExceptionType.connectionError) {
      final message = error.message ?? '';
      if (message.contains('Failed host lookup')) {
        return '无法解析服务器地址，请检查网络或稍后重试';
      }
      return '无法连接服务器，请检查网络或稍后重试';
    }
    return error.toString();
  }

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      final authResponse = AuthResponse.fromJson(response.data);
      await _apiClient.saveToken(authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('注册失败: $e');
    }
  }

  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      final authResponse = AuthResponse.fromJson(response.data);
      await _apiClient.saveToken(authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('登录失败: $e');
    }
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null && token.isNotEmpty;
  }
}
