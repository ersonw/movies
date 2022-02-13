class User {
  String token = '';
  String nickname = '';
  int sex = 0;
  int birthday = 0;
  String uid = '';
  String? invite = '';
  String? avatar = 'http://htm-download.oss-cn-hongkong.aliyuncs.com/default_head.gif';
  String? phone = '';
  int gold = 0;
  int diamond = 0;

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
        diamond = json['diamond'];

  Map toJson() {
    Map map = {};
    map['token'] = token;
    map['nickname'] = nickname;
    map['sex'] = sex;
    map['birthday'] = birthday;
    map['uid'] = uid;
    map['invite'] = invite;
    map['avatar'] = avatar;
    map['phone'] = phone;
    map['gold'] = gold;
    map['diamond'] =
    diamond;
    return
    map;
  }
}