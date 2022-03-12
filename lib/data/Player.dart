import 'dart:convert';
import 'dart:math';

import 'SearchActor.dart';

class Player {
  Player();

  int id = 0;
  String title = '';
  int play = 0;
  int duration = 0;
  SearchActor actor = SearchActor();
  int recommendations = 0;
  String tag = '';
  String playUrl = '';
  String downloadUrl = '';
  String pic = '';
  int diamond = 0;
  bool favorite = false;

  Player.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        play = json['play'],
        duration = json['duration'],
        actor = SearchActor.formJson(json['actor']),
        recommendations = json['recommendations'],
        playUrl = json['playUrl'],
        downloadUrl = json['downloadUrl'],
        pic = json['pic'],
        diamond = json['diamond'],
        favorite = json['favorite'],
        tag = json['tag'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'play': play,
        'duration': duration,
        'actor': actor.toJson(),
        'recommendations': recommendations,
        'tag': tag,
        'pic': pic,
        'playUrl': playUrl,
        'downloadUrl': downloadUrl,
        'diamond': diamond,
        'favorite': favorite,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
