import 'dart:convert';

import 'package:movies/data/Comment.dart';

class WolfFriend {
  WolfFriend();

  List<Comment> comments = [];
  int id = 0;
  String image = '';
  int vid = 0;
  int recommends = 0;

  WolfFriend.formJson(Map<String, dynamic> json)
      : comments =
            (json['comments'] as List).map((e) => Comment.formJson(e)).toList(),
        id = json['id'],
        image = json['image'],
        vid = json['vid'],
        recommends = json['recommends'];

  Map<String, dynamic> toJson() => {
        'comments': comments.map((e) => e.toJson()).toList(),
        'id': id,
        'image': image,
        'vid': vid,
        'recommends': recommends,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
