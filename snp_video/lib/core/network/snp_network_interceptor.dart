import 'package:dio/dio.dart';

class SNPNetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        'REQUEST[${options.method}] => PATH: ${options.path} => DATA: ${options.data}');

    if (options.data.runtimeType == FormData) {
      print("is formdata ");
      FormData fd = options.data;
      for (int i = 0; i < fd.fields.length; i++) {
        print("map : ${fd.fields[i]}");
      }
      for (int i = 0; i < fd.files.length; i++) {
        print("map2 : ${fd.files[i]}");
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}]');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions?.path} => ERROR: ${err.error}');
    return super.onError(err, handler);
  }
}
