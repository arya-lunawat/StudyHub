import 'package:dio/dio.dart';

import '../values/constant.dart';

class DoubtReplyApi {
  static final Dio _dio = Dio();

  // Post a reply to a doubt
  static Future<bool> postReply({
    required int doubtId,
    required String replyText,
    required String userToken,
    required String userName,
    required bool isTeacher,
  }) async {
    try {
      print('📤 Posting reply to doubt: $doubtId');
      print('💬 Reply text: "$replyText"');
      print('👨‍🏫 Is teacher: $isTeacher');

      var response = await _dio.post(
        '${AppConstants.SERVER_API_URL}api/doubt-replies',
        data: {
          'doubt_id': doubtId,
          'user_token': userToken,
          'user_name': userName,
          'reply_text': replyText,
          'is_teacher': isTeacher,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('✅ Post reply - Status: ${response.statusCode}');
      print('📦 Response: ${response.data}');
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('❌ Error posting reply: $e');
      if (e is DioException) {
        print('🔴 DioException Status Code: ${e.response?.statusCode}');
        print('🔴 Response Data: ${e.response?.data}');
        print('🔴 Error Message: ${e.message}');
      }
      return false;
    }
  }
}
