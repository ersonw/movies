import 'dart:convert';

class ShareRecord {
  ShareRecord();

  int id = 0;
  int status = 0;
  int uid = 0;
  String reason = '';
  String nickname = '';

  ShareRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        uid = json['uid'],
        reason = json['reason'],
        nickname = json['nickname'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'uid': uid,
        'reason': reason,
        'nickname': nickname,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
