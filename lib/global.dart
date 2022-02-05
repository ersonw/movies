import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies/functions.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
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
    _readConfig();
  }
  static Future<int> _readConfig() async {
    try {
      File file = await _getLocalFile('system.conf');
      // read the variable as a string from the file.
//    Map<String, dynamic> config = JSON.decode(await file.readAsString());
      print(await file.readAsString());
      return 1;
    } on FileSystemException {
      return 0;
    }
  }
  static Future<File> _getLocalFile(String filename) async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/$filename');
  }
  // 持久化Profile信息
  // static saveProfile() =>
  //     _prefs.setString("profile", jsonEncode(profile.toJson()));
}