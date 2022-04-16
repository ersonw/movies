import 'dart:convert';

class Featured {
  Featured();

  int id = 0;
  String title = '';
  List<Video> videos = [];

  Featured.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        videos =
            (json['videos'] as List).map((e) => Video.formJson(e)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'videos': videos.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}

class Video {
  Video();

  int id = 0;
  String title = '';
  String image = '';
  int play = 0;
  int recommendations = 0;
  int diamond = 0;
  int duration = 0;

  Video.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        play = json['play'],
        diamond = json['diamond'],
        duration = json['duration'],
        recommendations = json['recommendations'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'play': play,
        'diamond': diamond,
        'duration': duration,
        'recommendations': recommendations,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
