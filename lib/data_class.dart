class User {
  String token = '';
  String nickname = '';
  String uid = '';

  User();

  User.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        nickname = json['nickname'],
        uid = json['uid'];

  Map toJson() {
    Map map = {};
    map['token'] = token;
    map['nickname'] = nickname;
    map['uid'] = uid;
    return map;
  }
}

class Config {
  String hash = '';
  bool autoLogin = false;
  String bootImage = '';

  Config();

  Config.fromJson(Map<String, dynamic> json)
      : hash = json['hash'],
        autoLogin = json['autoLoin'],
        bootImage = json['bootImage'];

  Map toJson() {
    Map map = {};
    map['hash'] = hash;
    map['autoLogin'] = autoLogin;
    map['bootImage'] = bootImage;
    return map;
  }
}

class JsonModelDemo {
  late String key;
  late String value;

  Map toJson() {
    Map map = {};
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}
