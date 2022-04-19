import 'dart:convert';

class Trumpet {
  Trumpet();
  int id = 0;
  String text = '';
  Trumpet.formJson(Map<String, dynamic> json):
      id = json['id'],
  text = json['text'];
  Map<String, dynamic> toJson() => {
    'id' : id,
    'text': text,
  };
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}