import 'dart:convert';

import 'package:movies/data/Config.dart';
import 'package:movies/data/User.dart';

class Profile {
  User user = User();
  Config config = Config();
  List<String> searchRecords = [];

  Profile();

  Profile.fromJson(Map<String, dynamic> json)
      :user = User.fromJson(json['user']),
  searchRecords = (json['searchRecords'] as List).map((e) => e.toString()).toList(),
        config = Config.fromJson(json['config']);

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'config': config.toJson(),
    'searchRecords': searchRecords,
      };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
