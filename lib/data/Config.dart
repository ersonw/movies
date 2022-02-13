import 'package:movies/data/OssConfig.dart';

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
      };
}
