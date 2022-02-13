import 'dart:convert';

import 'package:movies/data/Config.dart';
import 'package:movies/data/User.dart';

class Profile {
  User user = User();
  Config config = Config();

  Profile();

  Profile.fromJson(Map<String, dynamic> json)
      :user = User.fromJson(json['user']),
        config = Config.fromJson(json['config']);

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'config': config.toJson(),
      };
}
