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
class JsonModelDemo {
  late String key;
  late String value;

  Map toJson(){
    Map map = {};
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}