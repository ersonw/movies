import 'dart:convert';

class SearchActor {
  SearchActor();

  String name = '';
  String avatar = '';
  int work = 0;
  bool collect = false;

  SearchActor.formJson(Map<String, dynamic> json)
      : name = json['name'],
        avatar = json['avatar'],
        collect = json['collect'],
        work = json['work'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
        'work': work,
    'collect': collect,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
