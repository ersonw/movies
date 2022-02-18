import 'dart:convert';

import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/OssConfig.dart';
import 'package:movies/data/VIPBuy.dart';

class Config {
  double version = 1.0;
  String hash = '';
  bool autoLogin = false;
  String bootImage = '';
  String url = '';
  bool force = false;
  bool bootLock = false;
  String? bootLockPasswd = '';
  OssConfig ossConfig = OssConfig();
  List<VIPBuy> vipBuys = [];
  List<OnlinePay> onlinePays = [];

  Config();

  Config.fromJson(Map<String, dynamic> json)
      : hash = json['hash'],
        url = json['url'],
        force = json['force'] ?? false,
        version = json['version'] ?? 1.0,
        autoLogin = json['autoLogin'] ?? false,
        bootImage = json['bootImage'],
        bootLock = json['bootLock'] ?? false,
        bootLockPasswd = json['bootLockPasswd'],
        vipBuys = json['vipBuys'] ?? [],
        onlinePays = json['onlinePays'] ?? [],
        ossConfig =
            OssConfig.formJson(json['ossConfig'] ?? OssConfig().toJson());

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'url': url,
        'force': force,
        'version': version,
        'autoLogin': autoLogin,
        'bootImage': bootImage,
        'bootLock': bootLock,
        'bootLockPasswd': bootLockPasswd,
        'ossConfig': ossConfig.toJson(),
        'vipBuys': vipBuys.map((e) => e.toJson()).toList(),
        'onlinePays': onlinePays.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
