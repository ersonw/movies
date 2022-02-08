import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/Messages.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/data/User.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/Profile.dart';
import 'package:movies/functions.dart';
import 'package:movies/HttpManager.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/Profile.dart';
class Global {
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static late final cameras;
  static late final firstCamera;
  static late final lastCamera;
  static late BuildContext MainContext;
  static late final String uid;
  static Profile profile = Profile();
  static Messages messages = Messages();
  static late SharedPreferences _prefs;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    // bool data = await fetchData();
    // print(data);
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    var _messages = _prefs.getString("messages");
    if(_messages != null){
      try{
        messages = Messages.formJson(jsonDecode(_messages));
      }catch(e){
        print(e);
      }
    }
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    uid = await getUUID();
    print(_messages);
    await _init();
  }
  static Future<void> _init() async {
    if(profile.config.hash == null || profile.config.hash.isEmpty){
      getConfig();
    }
    // await checkVersion();
    if(profile.config.autoLogin){
      if(profile.user.token == null || profile.user.token.isEmpty){
        await getUserInfo();
      }
    }
    getSystemMessage();
  }
  static Future<void> checkVersion() async {
    DioManager().request(
        NWMethod.GET,
        NWApi.checkVersion,
        params: {},
        success: (data){
          // print("success data = $data");
          if(data != null && data.isNotEmpty){
            Config config = Config.fromJson(jsonDecode(data));
            if(config.hash != profile.config.hash){
              getConfig();
            }
            if(MainContext != null){
              if(config.version.compareTo(profile.config.version) > 0){
                ShowOptionDialog(MainContext, '新版本上线', '目前版本：${profile.config.version}\n最新版本:${config.version}', config.url, config.force);
              }
            }
          }
        }, error:(error) {
          // print(error);
    });
  }
  static Future<void> getConfig() async {
    DioManager().request(
        NWMethod.GET,
        NWApi.baseConfig,
        params: {},
        success: (data){
          // print("success data = $data");
          if(data != null && data.isNotEmpty) {
            Config config = Config.fromJson(jsonDecode(data));
            profile.config.hash = config.hash;
            profile.config.autoLogin = config.autoLogin;
            profile.config.force = config.force;
            profile.config.url = config.url;
            profile.config.bootImage = config.bootImage;
            saveProfile();
          }
        }, error:(error) {});
  }
  static Future<void> getSystemMessage() async {
    DioManager().request(
        NWMethod.GET,
        NWApi.getSystemMessage,
        params: {},
        success: (data) async{
          // print("success data = $data");
          if(data != null && data.isNotEmpty) {
            SystemMessage message = SystemMessage.formJson(jsonDecode(data));
            bool have = false;
            List<SystemMessage> systemMessages = messages.systemMessage;
            for(int i=0; i< systemMessages.length; i++){
              if(systemMessages[i].id == message.id){
                have = true;
              }
            }
            if(!have){
              messages.systemMessage.add(message);
            }
            // messages.systemMessage = [];
            saveMessages();
          }
        }, error:(error) {});
  }
  static Future<void> getUserInfo() async {
    DioManager().request(
        NWMethod.POST,
        NWApi.getInfo,
        params: {'identifier': uid},
        success: (data){
          // print("success data = $data");
          if(data != null) {
            profile.user = User.fromJson(jsonDecode(data));
            saveProfile();
          }
        }, error:(error) {});
  }
  static Future<String> getUUID() async{
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String uid = '';
    try {
      if (Platform.isAndroid) {
        var build =  await deviceInfoPlugin.androidInfo;
        uid = build.androidId;
        // print(uid);
        //UUID for Android
      } else if (Platform.isIOS) {
        var build =  await deviceInfoPlugin.iosInfo;
        uid = build.identifierForVendor;
      }
    // ignore: nullable_type_in_catch_clause
    } on PlatformException {
      print('Failed to get platform version');
    }
    return uid;
  }
  static Future<File> _getLocalFile(String filename) async {
    // get the path to the document directory.
    // String dir = (await getApplicationDocumentsDirectory()).path;
    String dir = (await getTemporaryDirectory()).parent.path;
    // String dir = (await getApplicationSupportDirectory()).path;
    // print('$dir/$filename');
    return File('$dir/$filename');
  }
//  持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
  static saveMessages() => _prefs.setString('messages', jsonEncode(messages.toJson()));
}