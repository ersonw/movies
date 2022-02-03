import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class Global {
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static late final cameras;
  static late final firstCamera;
  static late final lastCamera;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    firstCamera = cameras.first;
    lastCamera = cameras.last;
  }

  // 持久化Profile信息
  // static saveProfile() =>
  //     _prefs.setString("profile", jsonEncode(profile.toJson()));
}