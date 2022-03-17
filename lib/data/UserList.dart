import 'dart:convert';

class UserList {
  UserList();

  int id = 0;
  String avatar = '';
  String nickname = '';
  String signature = '';
  String bkImage = '';
  int follows = 0;
  int remommends = 0;
  int fans = 0;
  int work = 0;
  bool follow = false;

  UserList.formJson(Map<String, dynamic> json)
      : id = json['id'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        signature = json['signature'],
        bkImage = json['bkImage'],
        fans = json['fans'],
        work = json['work'],
        remommends = json['remommends'],
        follows = json['follows'],
        follow = json['follow'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'nickname': nickname,
        'bkImage': bkImage,
        'signature': signature,
        'fans': fans,
        'work': work,
        'follows': follows,
        'remommends': remommends,
        'follow': follow,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
