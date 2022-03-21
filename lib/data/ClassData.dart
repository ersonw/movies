import 'dart:convert';

import 'package:movies/data/SearchActor.dart';

class ClassData {
  ClassData();

  int id = 0;
  String title = '';
  String image = '';
  SearchActor actor = SearchActor();
  int play = 0;
  int remommends = 0;
  int diamond = 0;

  ClassData.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        actor = json['actor'] != null
            ? SearchActor.formJson(json['actor'])
            : SearchActor(),
        play = json['play'],
        diamond = json['diamond'],
        remommends = json['remommends'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'actor': actor.toJson(),
        'play': play,
        'remommends': remommends,
        'diamond': diamond,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
