import 'dart:convert';
import 'dart:math';

import 'SearchActor.dart';

class Player {
  Player();

  int id = 0;
  String title = '';
  int play = 0;
  int less = 0;
  int duration = 0;
  SearchActor actor = SearchActor();
  int recommendations = 0;
  String tag = '';
  String playUrl = '';
  String downloadUrl = '';
  String pic = '';
  int diamond = 0;
  bool favorite = false;
  bool download = false;
  bool member = false;
  int du = 0;

  Player.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        play = json['play'],
        less = json['less'] ?? 0,
        duration = json['duration'],
        actor = SearchActor.formJson(json['actor']),
        recommendations = json['recommendations'],
        playUrl = json['playUrl'],
        downloadUrl = json['downloadUrl'],
        pic = json['pic'],
        diamond = json['diamond'],
        favorite = json['favorite'],
        download = json['download'],
        member = json['member'],
        du = json['du'] ?? 0,
        tag = json['tag'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'play': play,
        'less': less,
        'duration': duration,
        'actor': actor.toJson(),
        'recommendations': recommendations,
        'tag': tag,
        'pic': pic,
        'playUrl': playUrl,
        'downloadUrl': downloadUrl,
        'diamond': diamond,
        'favorite': favorite,
        'download': download,
        'member': member,
        'du': du,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
