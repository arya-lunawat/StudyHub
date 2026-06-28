import 'package:dio/dio.dart';
import 'package:study_hub/common/values/constant.dart';

import '../../pages/global.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil(){
    return _instance;
  }

  late Dio dio;


  HttpUtil._internal(){
    BaseOptions options = BaseOptions(
        baseUrl: AppConstants.SERVER_API_URL,
        connectTimeout: const Duration(seconds: 60),  // Increased from 10
        receiveTimeout: const Duration(seconds: 60),  // Increased from 10
        sendTimeout: const Duration(seconds: 60),     // Increased from 10
        headers: {},
        contentType: "application/json; charset=utf-8",
        responseType: ResponseType.json
    ); // BaseOptions
    dio = Dio(options);

    // Add interceptor for better error logging (optional but recommended)
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (object) => print(object),
    ));
  }

  Future post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if(authorization != null){
      requestOptions.headers!.addAll(authorization);
    }

    try {
      var response = await dio.post(
          path, data: data, queryParameters: queryParameters, options: requestOptions);
      return response.data;
    } on DioException catch (e) {
      print('API Error: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      rethrow;
    }
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    var accessToken = Global.storageService.getUserToken();
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}