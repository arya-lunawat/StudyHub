import 'package:study_hub/common/utils/http_util.dart';
import '../entities/base.dart';
import '../entities/course.dart';

class CourseAPI {
  static Future<CourseListResponseEntity> courseList() async {
    var response = await HttpUtil().post('api/courseList');
    print(response.toString());
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<CourseDetailResponseEntity> courseDetail({
    required CourseRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      'api/courseDetail',
      queryParameters: params.toJson(),
    );

    return CourseDetailResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> coursePay({
    CourseRequestEntity? params  // Add curly braces to make it a named parameter
  }) async {
    var response = await HttpUtil().post(
      'api/checkout',
      queryParameters: params?.toJson(),
    );

    return BaseResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> searchCourses({
    required String query,
  }) async {
    var response = await HttpUtil().post(
      'api/searchCourses',
      queryParameters: {'query': query},
    );
    return CourseListResponseEntity.fromJson(response);
  }
}

