class User {
  String token = '';
  String nickname = '';
  String uid = '';
  String? invite = '';
  String? avatar = '';
  String? phone = '';
  int gold = 0;
  int diamond = 0;

  User();

  User.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        nickname = json['nickname'],
        uid = json['uid'],
        invite = json['invite'],
        avatar = json['avatar'],
        phone = json['phone'],
        gold = json['gold'],
        diamond = json['diamond'];

  Map toJson() {
    Map map = {};
    map['token'] = token;
    map['nickname'] = nickname;
    map['uid'] = uid;
    map['invite'] = invite;
    map['avatar'] = avatar;
    map['phone'] = phone;
    map['gold'] = gold;
    map['diamond'] = diamond;
    return map;
  }
}