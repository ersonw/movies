import 'dart:convert';

class UserList {
  UserList();

  int id = 0;
  String avatar = '';
  String nickname = '';
  int fans = 0;
  int work = 0;
  bool follow = false;

  UserList.formJson(Map<String, dynamic> json)
      : id = json['id'],
        avatar = json[''],
        nickname = json[''],
        fans = json[''],
        work = json[''];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'nickname': nickname,
        'fans': fans,
        'work': work,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
