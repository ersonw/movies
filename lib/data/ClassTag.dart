import 'dart:convert';

class ClassTag {
  ClassTag();

  int id = 0;
  String title = '';

  ClassTag.formJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
