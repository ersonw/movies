import 'dart:convert';

class User {
  String token = '';
  String nickname = '';
  int sex = 0;
  int birthday = 0;
  String uid = '';
  String? invite = '';
  String? avatar = '';
  String? phone = '';
  int gold = 0;
  int diamond = 0;
  int superior = 0;

  User();

  User.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        nickname = json['nickname'],
        sex = json['sex'],
        birthday = json['birthday'],
        uid = json['uid'],
        invite = json['invite'],
        avatar = json['avatar'],
        phone = json['phone'],
        gold = json['gold'],
        superior = json['superior'],
        diamond = json['diamond'];

  Map<String, dynamic> toJson() => {
    'token': token,
    'nickname': nickname,
    'sex': sex,
    'birthday': birthday,
    'uid': uid,
    'invite': invite,
    'avatar': avatar,
    'phone': phone,
    'gold': gold,
    'diamond': diamond,
    'superior': superior,
  };
  @override
  String toString() {
    // TODO: implement toString
    super.toString();
    return jsonEncode(toJson());
  }
}