import 'dart:convert';

import 'package:movies/data/Config.dart';
import 'package:movies/data/User.dart';

class Profile {
  bool isLock = false;
  String password = '';
  User user = User();
  Config config = Config();

  Profile();

  Profile.fromJson(Map<String, dynamic> json)
      : isLock = json['isLock'],
        password = json['password'],
        user = User.fromJson(json['user']),
        config = Config.fromJson(json['config']);

  Map<String, dynamic> toJson() => {
        'isLock': isLock,
        'password': password,
        'user': user.toJson(),
        'config': config.toJson(),
      };
}
