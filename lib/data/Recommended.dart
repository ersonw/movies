import 'dart:convert';

import 'package:movies/data/ClassData.dart';
import 'package:movies/data/SearchActor.dart';

class Recommended {
  Recommended();
  int id=0;
  String title = '';
  ClassData video = ClassData();
  double funny = 0;
  double hot = 0;
  double face = 0;

  Recommended.formJson(Map<String, dynamic> json)
      : title = json['title'],
        video = ClassData.formJson(json['video']),
        funny = json['funny'],
        hot = json['hot'],
        face = json['face'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'video': video.toJson(),
        'funny': funny,
        'hot': hot,
        'face': face,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
