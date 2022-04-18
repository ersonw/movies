import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies/functions.dart';
import 'package:movies/model/UserModel.dart';
import 'package:movies/network/entity/BaseEntity.dart';
import 'package:movies/network/entity/BaseListEntity.dart';
import 'package:movies/network/entity/ErrorEntity.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';

import 'global.dart';

class DioManager {
  static DioManager _shared = DioManager._internal();

  factory DioManager() => _shared;
  late Dio dio;
  String _token = '';
  // late BaseOptions options;

  DioManager._internal() {
    _token = userModel.token;
    /// 自定义Header
    Map<String, dynamic> httpHeaders = {
      'Token': _token
    };
    String api=NWApi.baseApi;
    if(configModel.config.domain != null && configModel.config.domain.isNotEmpty){
      api = configModel.config.domain;
    }
    BaseOptions options = BaseOptions(
     // options = BaseOptions(
      baseUrl: api,
      headers: httpHeaders,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: false,
      connectTimeout: 30000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
    userModel.addListener(() {
      _token = userModel.token;
      /// 自定义Header
      Map<String, dynamic> httpHeaders = {
        'Token': _token
      };
      String api = NWApi.baseApi;
      if(configModel.config.domain != null && configModel.config.domain.isNotEmpty){
        api = configModel.config.domain;
      }
      BaseOptions options = BaseOptions(
        // options = BaseOptions(
        baseUrl: api,
        headers: httpHeaders,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 30000,
        receiveTimeout: 3000,
      );
      dio = Dio(options);
    });

  }

  Future<bool> upload<T>(String path, Map<String, dynamic> params) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NWMethodValues[NWMethod.POST]));
      BaseEntity entity = BaseEntity<T>.fromJson(response.data);
      if (entity.code == 200) {
        return true;
      }
    } on DioError catch (e) {
      // print(e.response?.statusCode);
      if (e.response?.statusCode == 105) {
        // ShowAlertDialog(Global.MainContext, '访问受限', '原因:游客无法访问');
        Global.showWebColoredToast('原因:游客无法访问');
      } else if (e.response?.statusCode == 106) {
        UserModel().token = '';
        // Global.saveProfile();
        // ShowAlertDialog(Global.MainContext, '访问受限', '原因:登录已失效');
        // Global.showWebColoredToast('原因:登录已失效');
      } else {
        print(dio.options.baseUrl+path);
        print(e.message);
        // ShowAlertDialog(Global.MainContext, '网络错误!', '原因:${e.message}');
      }
    }
    return false;
  }
  Future<String?> requestAsync<T>(NWMethod method, String path, Map<String, dynamic> params) async {
    // print(_token);
    List<int> bytes = utf8.encode(jsonEncode(params));
    String s = (base64.encode(bytes));
    try {
      Response response = await dio.request(path, queryParameters: {'s': s}, options: Options(method: NWMethodValues[method]));
      // Response response = await dio.request(path, queryParameters: params, options: Options(method: NWMethodValues[method]));
      BaseEntity entity = BaseEntity<T>.fromJson(response.data);
      if (entity.code == 200) {
        return entity.data;
      }else{
        Global.showWebColoredToast(entity.message);
      }
    } on DioError catch (e) {
      // print(e.response?.statusCode);
      if (e.response?.statusCode == 105) {
        // ShowAlertDialog(Global.MainContext, '访问受限', '原因:游客无法访问');
        // Global.showWebColoredToast('原因:游客无法访问');
      } else if (e.response?.statusCode == 106) {
        UserModel().token = '';
        // Global.saveProfile();
        // ShowAlertDialog(Global.MainContext, '访问受限', '原因:登录已失效');
        // Global.showWebColoredToast('原因:登录已失效');
      } else {
        print(dio.options.baseUrl+path);
        print(e.message);
        // ShowAlertDialog(Global.MainContext, '网络错误!', '原因:${e.message}');
      }
    }
    return null;
  }
  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future request<T>(
      NWMethod method,
      String path,
      {
        required Map<String, dynamic> params,
        Function(String?)? success,
        Function(ErrorEntity)? error
      }) async {
    try {
      Response response = await dio.request(path,
          queryParameters: params,
          options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 200) {
          success!(entity.data);
        } else {
//          error(ErrorEntity(code: entity.code, message: entity.message));
          ShowAlertDialog(Global.MainContext, '操作失败!', '${entity.message}');
        }
        if (entity.code == 106) {
          UserModel().token = '';
          // Global.profile.user.token = '';
          // Global.saveProfile();
        }
      } else {
        ShowAlertDialog(Global.MainContext, '操作失败!', '未知错误95');
//        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch (e) {
      // print(e.response?.statusCode);
      if (e.response?.statusCode == 105) {
        // ShowAlertDialog(Global.MainContext, '访问受限', '原因:游客无法访问');
        Global.showWebColoredToast('原因:游客无法访问');
      } else if (e.response?.statusCode == 106) {
        UserModel().token = '';
        // Global.saveProfile();
        // ShowAlertDialog(Global.MainContext, '访问受限', '原因:登录已失效');
        // Global.showWebColoredToast('原因:登录已失效');
      } else {
        print(dio.options.baseUrl+path);
        print(e.message);
        // ShowAlertDialog(Global.MainContext, '网络错误!', '原因:${e.message}');
      }
//      error(createErrorEntity(e));
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
