import 'dart:convert';

class Game {
  Game();
  String name = '';
  int id = 0;
  String image = '';
  Game.formJson(Map<String, dynamic> json):
      name = json['name'],
  id = json['id'],
  image = json['image'];
  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'image': image,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}