import 'dart:convert';

class UserVideo {
  UserVideo();
  int id = 0;
  String title = '';
  String image = '';
  int play = 0;
  int likes = 0;
  bool like = false;
  int duration = 0;

  UserVideo.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        play = json['play'],
        duration = json['duration'],
        like = json['like'],
        likes = json['likes'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'play': play,
    'likes': likes,
    'like': like,
    'duration': duration,
  };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}