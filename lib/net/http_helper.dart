import 'package:dio/dio.dart';
import 'http.dart';


// 网络请求工具类
class HttpHelper {
  static Future<T> get<T>(String url,
      {String encode = 'utf-8',HttpSuccessCallback<T> success, HttpFailureCallback error}) async {
    return Http.request<T>(url, success: success, encode: encode, error: error);
  }

  static Future<T> postForm<T>(String url, FormData data,
      {String encode = 'utf-8', HttpSuccessCallback<T> success, HttpFailureCallback error}) async {
    return Http.request<T>(url,
        method: Method.POST, data: data, encode: encode,success: success, error: error);
  }

  static Future<T> postBody<T>(String url,
      {Map data ,String encode = 'utf-8', HttpSuccessCallback<T> success, HttpFailureCallback error}) async {
    return Http.request<T>(url,
        method: Method.POST, data: data, encode: encode,success: success, error: error);
  }
}
