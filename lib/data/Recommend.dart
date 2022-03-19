import 'dart:convert';

import 'package:movies/data/ClassData.dart';

class Recommend {
  Recommend();

  int id = 0;
  int vid = 0;
  String reason = '';
  ClassData data = ClassData();

  Recommend.formJson(Map<String, dynamic> json)
      : id = json['id'],
        vid = json['vid'],
        reason = json['reason'],
        data = ClassData.formJson(json['data']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'vid': vid,
        'reason': reason,
        'data': data.toJson(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
