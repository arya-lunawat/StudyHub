import 'package:dio/dio.dart';

import '../values/constant.dart';

class CommentApi {
  static final Dio _dio = Dio();

  // Get all doubts for a course
  static Future<List<dynamic>> getComments(int courseId) async {
    try {
      print('📥 Fetching doubts for course: $courseId');
      var response = await _dio.get(
        '${AppConstants.SERVER_API_URL}api/doubts',
        queryParameters: {'course_id': courseId},
      );
      print('✅ Get doubts - Status: ${response.statusCode}');
      print('📦 Response: ${response.data}');
      if (response.statusCode == 200) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('❌ Error fetching doubts: $e');
      return [];
    }
  }

  // Post a new doubt
  static Future<bool> postComment(int courseId, String doubtText) async {
    try {
      print('📤 Posting doubt for course: $courseId');
      print('💬 Doubt text: "$doubtText"');

      var response = await _dio.post(
        '${AppConstants.SERVER_API_URL}api/doubts',
        data: {
          'course_id': courseId,
          'doubt_text': doubtText,
          'user_token': 'f3acf792d4b2dbf255d9bf572076e285',
          'user_name': 'Student',
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('✅ Post doubt - Status: ${response.statusCode}');
      print('📦 Response: ${response.data}');
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('❌ Error posting doubt: $e');
      if (e is DioException) {
        print('🔴 DioException Status Code: ${e.response?.statusCode}');
        print('🔴 Response Data: ${e.response?.data}');
        print('🔴 Error Message: ${e.message}');
      }
      return false;
    }
  }
}
