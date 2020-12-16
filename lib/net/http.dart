import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String BASE_API_URL = '';
const String TEST_URL_PATH = '';

enum Method {
  GET,
  POST,
  DELETE,
  PUT,
}

const MethodValues = {
  Method.GET: 'get',
  Method.POST: 'post',
  Method.DELETE: 'delete',
  Method.PUT: 'put',
};

typedef HttpSuccessCallback<T> = void Function(T data);
typedef HttpFailureCallback = void Function(ErrorEntity data);

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Http {
  // requestOptions可以重置Option
  static Future<T> request<T>(
    String baseUrl, {
    Method method = Method.GET,
    String path = '',
    String encode = 'utf-8',
    dynamic data,
    Map params,
    RequestOptions requestOptions,
    HttpSuccessCallback<T> success,
    HttpFailureCallback error,
  }) async {
    try {
      BaseOptions options = BaseOptions(
          baseUrl: baseUrl,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.bytes,
          receiveDataWhenStatusError: false,
          connectTimeout: 60000,
          receiveTimeout: 3000,);
      Dio dio = Dio(options);
      (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
//      dio.interceptors..add(NetApiInterceptor());]
      Response response = await dio.request(
        path,
        data: data,
        queryParameters: params,
        options: Options(method: MethodValues[method]),
      );
      String responseData  = utf8.decode(response.data);
      if (success != null) {
        success(responseData as T);
      }
      return responseData as T;
    } on DioError catch (e) {
      if (error != null) {
        error(createErrorEntity(e));
      }
    }
  }

  static ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(code: -1, message: '请求取消');
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: '连接超时');
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: '请求超时');
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: '响应超时');
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                return ErrorEntity(code: errCode, message: '请求语法错误');
                break;
              case 403:
                return ErrorEntity(code: errCode, message: '服务器拒绝执行');
                break;
              case 404:
                return ErrorEntity(code: errCode, message: '无法连接服务器');
                break;
              case 405:
                return ErrorEntity(code: errCode, message: '请求方法被禁止');
                break;
              case 500:
                return ErrorEntity(code: errCode, message: '服务器内部错误');
                break;
              case 502:
                return ErrorEntity(code: errCode, message: '无效的请求');
                break;
              case 503:
                return ErrorEntity(code: errCode, message: '服务器挂了');
                break;
              case 505:
                return ErrorEntity(code: errCode, message: '不支持HTTP协议请求');
                break;
              default:
                return ErrorEntity(code: errCode, message: '未知错误');
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: '未知错误');
          }
        }
        break;
      default:
        return ErrorEntity(code: -1, message: error.message);
    }
  }
}

class ErrorEntity {
  int code;
  String message;

  ErrorEntity({this.code, this.message});
}

class NetApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' data: ${options.data}' +
        'headers : ${options.headers}');
    return options;
  }

  @override
  onResponse(Response response) {
    debugPrint('---api-response--->resp----->${response.data}');
  }
}
