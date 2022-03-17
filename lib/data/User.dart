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
  int expired = 0;
  int experience = 0;
  int remommends = 0;
  int follows = 0;
  int fans = 0;
  String signature = '';
  String bkImage = '';

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
        expired = json['expired'],
        experience = json['experience'],
        remommends = json['remommends'],
        follows = json['follows'],
        fans = json['fans'],
        signature = json['signature'],
        bkImage = json['bkImage'],
        diamond = json['diamond'];

  Map<String, dynamic> toJson() => {
        'token': token,
        'bkImage': bkImage,
        'signature': signature,
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
        'expired': expired,
        'experience': experience,
        'remommends': remommends,
        'follows': follows,
        'fans': fans,
      };

  @override
  String toString() {
    // TODO: implement toString
    super.toString();
    return jsonEncode(toJson());
  }
}
