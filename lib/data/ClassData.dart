import 'dart:convert';

class ClassData {
  ClassData();

  int id = 0;
  String title = '';
  String image = '';
  String actor = '';
  int play = 0;
  int remommends = 0;

  ClassData.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        actor = json['actor'],
        play = json['play'],
        remommends = json['remommends'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'actor': actor,
        'play': play,
        'remommends': remommends,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
