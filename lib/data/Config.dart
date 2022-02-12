import 'package:movies/data/OssConfig.dart';

class Config {
  double version = 1.0;
  String hash = '';
  bool autoLogin = false;
  String bootImage = '';
  String url = '';
  bool force = false;
  OssConfig ossConfig = OssConfig();

  Config();

  Config.fromJson(Map<String, dynamic> json)
      : hash = json['hash'],
        url = json['url'],
        force = json['force'] ?? false,
        version = json['version'],
        autoLogin = json['autoLogin'] ?? false,
        bootImage = json['bootImage'],
        ossConfig = OssConfig.formJson(json['ossConfig'] ?? OssConfig().toJson());

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'url': url,
        'force': force,
        'version': version,
        'autoLogin': autoLogin,
        'bootImage': bootImage,
        'ossConfig': ossConfig.toJson(),
      };
}
