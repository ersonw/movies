class Config {
  double version = 1.0;
  String hash = '';
  bool autoLogin = false;
  String bootImage = '';
  String url = '';
  bool force = false;

  Config();

  Config.fromJson(Map<String, dynamic> json)
      : hash = json['hash'],
        url = json['url'],
        force = json['force'],
        version = json['version'],
        autoLogin = json['autoLogin'],
        bootImage = json['bootImage'];

  Map toJson() {
    Map map = {};
    map['hash'] = hash;
    map['url'] = url;
    map['force'] = force;
    map['version'] = version;
    map['autoLogin'] = autoLogin;
    map['bootImage'] = bootImage;
    return map;
  }
}