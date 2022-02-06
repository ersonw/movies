import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies/functions.dart';
import 'package:movies/network/entity/BaseEntity.dart';
import 'package:movies/network/entity/BaseListEntity.dart';
import 'package:movies/network/entity/ErrorEntity.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';

import 'global.dart';
class DioManager {
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;
  late Dio dio;
  DioManager._internal() {
    // ignore: unnecessary_null_comparison
//    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: NWApi.baseApi,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 30000,
        receiveTimeout: 3000,
      );
      dio = Dio(options);
//    }
  }

  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future request<T>(NWMethod method, String path, {required Map<String, dynamic> params, required Function(T) success, required Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 200) {
          success(entity.data);
        } else {
//          error(ErrorEntity(code: entity.code, message: entity.message));
          ShowAlertDialog(Global.MainContext, '操作失败!', '${entity.message}');
        }
      } else {
        ShowAlertDialog(Global.MainContext, '操作失败!', '未知错误48');
//        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      ShowAlertDialog(Global.MainContext, '网络错误!', '原因:${e.message}');
//      error(createErrorEntity(e));
    }
  }

  // 请求，返回参数为 List
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future requestList<T>(NWMethod method, String path, {required Map<String, dynamic> params, required Function(List<T>) success, required Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.code == 200) {
//          success(entity.data);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
//    switch (error.type) {
//      case DioErrorType.CANCEL:{
//        return ErrorEntity(code: -1, message: "请求取消");
//      }
//      break;
//      case DioErrorType.CONNECT_TIMEOUT:{
//        return ErrorEntity(code: -1, message: "连接超时");
//      }
//      break;
//      case DioErrorType.SEND_TIMEOUT:{
//        return ErrorEntity(code: -1, message: "请求超时");
//      }
//      break;
//      case DioErrorType.RECEIVE_TIMEOUT:{
//        return ErrorEntity(code: -1, message: "响应超时");
//      }
//      break;
//      case DioErrorType.RESPONSE:{
//        try {
//          int errCode = (error.response.statusCode);
//          String errMsg = error.response.statusMessage;
//          return ErrorEntity(code: '$errCode', message: errMsg);
////          switch (errCode) {
////            case 400: {
////              return ErrorEntity(code: errCode, message: "请求语法错误");
////            }
////            break;
////            case 403: {
////              return ErrorEntity(code: errCode, message: "服务器拒绝执行");
////            }
////            break;
////            case 404: {
////              return ErrorEntity(code: errCode, message: "无法连接服务器");
////            }
////            break;
////            case 405: {
////              return ErrorEntity(code: errCode, message: "请求方法被禁止");
////            }
////            break;
////            case 500: {
////              return ErrorEntity(code: errCode, message: "服务器内部错误");
////            }
////            break;
////            case 502: {
////              return ErrorEntity(code: errCode, message: "无效的请求");
////            }
////            break;
////            case 503: {
////              return ErrorEntity(code: errCode, message: "服务器挂了");
////            }
////            break;
////            case 505: {
////              return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
////            }
////            break;
////            default: {
////              return ErrorEntity(code: errCode, message: "未知错误");
////            }
////          }
//        } on Exception catch(_) {
//          return ErrorEntity(code: -1, message: "未知错误");
//        }
//      }
//      break;
//      default: {
        return ErrorEntity(code: -1, message: error.message);
//      }
//    }
  }
}
