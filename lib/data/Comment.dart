import 'dart:convert';

class Comment {
  Comment();

  int id = 0;
  int uid = 0;
  String nickname = '';
  String avatar = '';
  bool isFirst = false;
  String context = '';
  int likes = 0;

  Comment.formJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        nickname = json['nickname'],
        avatar = json['avatar'],
        isFirst = json['isFirst'],
        context = json['context'],
        likes = json['likes'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'nickname': nickname,
        'avatar': avatar,
        'isFirst': isFirst,
        'context': context,
        'likes': likes,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
