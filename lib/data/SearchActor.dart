import 'dart:convert';

class SearchActor {
  SearchActor();

  int id = 0;
  String name = '';
  String avatar = '';
  int work = 0;
  int collects = 0;
  bool collect = false;
  String measurements = '';

  SearchActor.formJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        collects = json['collects'],
        avatar = json['avatar'],
        collect = json['collect'],
        measurements = json['measurements'],
        work = json['work'];

  Map<String, dynamic> toJson() => {
        'collects': collects,
        'id': id,
        'name': name,
        'avatar': avatar,
        'work': work,
        'collect': collect,
        'measurements': measurements,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
