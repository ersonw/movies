import 'dart:convert';

import 'package:movies/data_class.dart';

class Profile {
  User user = User();

  Profile();
  Profile.fromJson(Map<String, dynamic> json) : user = User.fromJson(json['user']);

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };
}
