import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:movies/data_class.dart';
import 'package:movies/http_manager.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Profile.dart';
class Global {
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static late final cameras;
  static late final firstCamera;
  static late final lastCamera;
  static late BuildContext MainContext;
  static late final String uid;
  static Profile profile = Profile();
  static late SharedPreferences _prefs;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
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
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    // firstCamera = cameras.first;
    // lastCamera = cameras.last;
    //  await _readConfig();
    uid = await GetUUID();
    // User user = User();
    // user.uid = uid;
    // profile.user = user;
    // saveProfile();
    // print(_profile);
  }
  static Future<void> GetUserInfo() async {
    DioManager().request(
        NWMethod.POST,
        NWApi.getInfo,
        params: {'identifier': uid},
        success: (data){
          print("success data = $data");
        }, error:(error) {});
  }
  static Future<String> GetUUID() async{
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
  static Future<int> _readConfig() async {
    try {
      File file = await _getLocalFile('system.json');
      // read the variable as a string from the file.
//    Map<String, dynamic> config = JSON.decode(await file.readAsString());
//       print(await file.readAsString());
//       file.writeAsStringSync('sadasd');
      return 1;
    } on FileSystemException {
      return 0;
    }
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
}