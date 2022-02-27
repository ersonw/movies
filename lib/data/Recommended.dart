import 'dart:convert';

class Recommended {
  Recommended();

  String title = '';
  String image = '';
  String actor = '';
  double funny = 0;
  double hot = 0;
  double face = 0;
  int type = 0;
  int diamond = 0;
  int vid = 0;

  Recommended.formJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        actor = json['actor'],
        funny = json['funny'],
        hot = json['hot'],
        face = json['face'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'actor': actor,
        'funny': funny,
        'hot': hot,
        'face': face,
        'type': type,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
