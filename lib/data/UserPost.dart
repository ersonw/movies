import 'dart:convert';

class UserPost {
  UserPost();

  int id = 0;
  User user = User();
  String title = '';
  String context = '';
  int postTime = 0;
  List<String> images = [];
  bool isCollect = false;
  bool isRecommend = false;
  int comments = 0;
  int likes = 0;

  UserPost.formJson(Map<String, dynamic> json)
      : id = json['id'],
        user = User.formJson(json['user']),
        title = json['title'],
        context = json['context'],
        postTime = json['postTime'],
        images = (json['images'] as List).map((e) => e.toString()).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user.toJson(),
        'title': title,
        'context': context,
        'postTime': postTime,
        'images': images,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}

class User {
  User();

  int id = 0;
  String avatar = '';
  String nickname = '';
  int vip = 0;
  int level = 0;
  bool follow = false;

  User.formJson(Map<String, dynamic> json)
      : id = json['id'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        vip = json['vip'],
        level = json['level'],
        follow = json['follow'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'nickname': nickname,
        'vip': vip,
        'level': level,
        'follow': follow,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
