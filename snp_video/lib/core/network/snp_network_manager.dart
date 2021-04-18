import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'snp_network_config.dart';
import 'snp_network_interceptor.dart';

class SNPNetworkManager {
  Dio _dio;

  factory SNPNetworkManager() => _getInstance();

  static SNPNetworkManager get instance => _getInstance();

  // 静态私有成员，没有初始化
  static SNPNetworkManager _instance;

  // 私有构造函数
  SNPNetworkManager._internal() {
    // 初始化
    _dio = Dio();
    _dio.options.baseUrl = SNPNetworkConfig.baseURL;
    _dio.options.connectTimeout = SNPNetworkConfig.connectTimeOut;
    _dio.options.receiveTimeout = SNPNetworkConfig.receiveTimeout;
    // 拦截器
    // final onreq = (RequestOptions req, RequestInterceptorHandler handler) {
    //   print("sniper: request url : ${req.uri}");
    //   print("sniper: request data : ${req.data}");
    // };
    // final onresp =
    //     (Response<dynamic> resp, ResponseInterceptorHandler handler) {
    //   print("sniper: request statusCode : ${resp.statusCode}");
    //   print("sniper: request data : ${resp.data}");
    // };

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (Uri) {
        // 用1个开关设置是否开启代理
        return 'PROXY 192.168.3.7:8888';
      };
    };

    SNPNetworkInterceptor interceptor = SNPNetworkInterceptor();
    InterceptorsWrapper(
        onRequest: interceptor.onRequest,
        onResponse: interceptor.onResponse,
        onError: interceptor.onError);
    _dio.interceptors.add(interceptor);
  }

  // 静态、同步、私有访问点
  static SNPNetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new SNPNetworkManager._internal();
    }
    return _instance;
  }

  void reset() {
    _dio = Dio();
  }

  void clear() {
    _dio = null;
  }

  Future<Response> getData(String url,
      {Map<String, Object> params, Map<String, dynamic> headers}) async {
    if (headers != null) {}
    return await _dio.get(url, queryParameters: params);
  }

  Future<Response> postForm(String url, Map<String, Object> params) async {
    var option = Options(
        method: "POST", contentType: "application/x-www-form-urlencoded");
    return await _dio.post(url, data: params, options: option);
  }

  Future<Response> postJson(String url, Map<String, Object> params,
      {Map<String, dynamic> headers}) async {
    var option = Options(method: "POST", contentType: "application/json");
    return await _dio.post(url, data: params, options: option);
  }

  /**
   * 上传文件
   * 注：file是服务端接受的字段字段，如果接受字段不是这个需要修改
   */
  Future<Response> uploadFile(String url, Map<String, dynamic> params,
      {Function(double percent) progressCallback,
      Map<String, dynamic> headers}) async {
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    print(_dio.options.headers);
    var postData = FormData.fromMap(params); //file是服务端接受的字段字段，如果接受字段不是这个需要修改
    var option = Options(
        method: "POST",
        contentType: "multipart/form-data"); //上传文件的content-type 表单
    return await _dio.post(
      url,
      data: postData,
      options: option,
      onSendProgress: (int sent, int total) {
        if (progressCallback == null) {
          return;
        }
        progressCallback(sent / total * 1.0);
        // print("上传进度：" +
        //     NumUtil.getNumByValueDouble(sent / total * 100, 2)
        //         .toStringAsFixed(2) +
        //     "%"); //取精度，如：56.45%
      },
    );
  }

  // /**
  //  * 上传文件
  //  * 注：file是服务端接受的字段字段，如果接受字段不是这个需要修改
  //  */
  // Future<Response> uploadFile(String filePath, String fileName) async {
  //   var postData = FormData.fromMap({
  //     "file": await MultipartFile.fromFile(filePath, filename: fileName)
  //   }); //file是服务端接受的字段字段，如果接受字段不是这个需要修改
  //   var option = Options(
  //       method: "POST",
  //       contentType: "multipart/form-data"); //上传文件的content-type 表单
  //   return await dio.post(
  //     UPLOAD_FILE_N,
  //     data: postData,
  //     options: option,
  //     onSendProgress: (int sent, int total) {
  //       print("上传进度：" +
  //           NumUtil.getNumByValueDouble(sent / total * 100, 2)
  //               .toStringAsFixed(2) +
  //           "%"); //取精度，如：56.45%
  //     },
  //   );
  // }

  // /**
  //  * 下载文件
  //  */
  // Future<Response> downloadFile(String resUrl, String savePath) async {
  //   //还好我之前写过服务端代码，不然我根本没有相对路劲的概念
  //   return await dio.download(resUrl, savePath,
  //       onReceiveProgress: (int loaded, int total) {
  //     print("下载进度：" +
  //         NumUtil.getNumByValueDouble(loaded / total * 100, 2)
  //             .toStringAsFixed(2) +
  //         "%"); //取精度，如：56.45%
  //   });
  // }
}
