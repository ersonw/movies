import 'dart:convert';

class Player {
  Player();

  int id = 0;
  String title = '';
  int play = 0;
  String duration = '';
  String actor = '';
  int recommendations = 0;
  String tag = '';

  Player.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        play = json['play'],
        duration = json['duration'],
        actor = json['actor'],
        recommendations = json['recommendations'],
        tag = json['tag'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'play': play,
        'duration': duration,
        'actor': actor,
        'recommendations': recommendations,
        'tag': tag,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
