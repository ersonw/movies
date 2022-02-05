class User {
  late String token;
  late String nickname;

  Map toJson() {
    Map map = {};
    map['token'] = token;
    map['nickname'] = nickname;
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