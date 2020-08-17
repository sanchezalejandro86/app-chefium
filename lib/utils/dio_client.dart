import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio _dio = Dio(BaseOptions(
    //baseUrl: 'https://api-chefium.herokuapp.com/v1',
    //baseUrl: 'http://192.168.5.108:3000/v1',
    baseUrl: 'http://192.168.1.19:3000/v1',
  ));
  static Dio get initDio => _dio;
  static Dio get authDio => _dio..interceptors.add(AppInterceptors());
}

class AppInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('token');

    options.headers.addAll({"Authorization": "Bearer $header"});

    return options;
  }

  @override
  Future<DioError> onError(DioError dioError) async {
    return dioError;
  }

  @override
  Future<dynamic> onResponse(Response options) async {}
}
