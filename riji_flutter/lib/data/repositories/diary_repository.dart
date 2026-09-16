import 'package:dio/dio.dart';
import 'package:riji_flutter/core/api/api_client.dart';
import 'package:riji_flutter/core/api/api_exception.dart';
import 'package:riji_flutter/data/models/diary.dart';

class DiaryListResponse {
  final List<Diary> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  DiaryListResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory DiaryListResponse.fromJson(Map<String, dynamic> json) {
    return DiaryListResponse(
      content: (json['content'] as List).map((e) => Diary.fromJson(e as Map<String, dynamic>)).toList(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );
  }
}

class DiaryRepository {
  final ApiClient _apiClient;

  DiaryRepository(this._apiClient);

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

  Future<DiaryListResponse> getDiaries({
    int page = 0,
    int size = 20,
    String? startDate,
    String? endDate,
    String? mood,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (mood != null) queryParams['mood'] = mood;

      final response = await _apiClient.get('/diaries', queryParameters: queryParams);
      return DiaryListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('获取日记列表失败: $e');
    }
  }

  Future<Diary> getDiary(String serverId) async {
    try {
      final response = await _apiClient.get('/diaries/$serverId');
      return Diary.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('获取日记详情失败: $e');
    }
  }

  Future<Diary> createDiary(DiaryRequest diary) async {
    try {
      final response = await _apiClient.post('/diaries', data: diary.toJson());
      return Diary.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('创建日记失败: $e');
    }
  }

  Future<Diary> updateDiary(String serverId, DiaryRequest diary) async {
    try {
      final response = await _apiClient.put('/diaries/$serverId', data: diary.toJson());
      return Diary.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('更新日记失败: $e');
    }
  }

  Future<void> deleteDiary(String serverId) async {
    try {
      await _apiClient.delete('/diaries/$serverId');
    } on DioException catch (e) {
      throw ApiException(_parseErrorMessage(e), statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('删除日记失败: $e');
    }
  }
}
