import 'dart:convert';

class SearchList {
  SearchList();

  String title = '';
  int id = 0;
  String image = '';
  String number = '';
  int play = 0;
  String account = '';
  int remommends = 0;


  SearchList.formJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        image = json['image'],
        number = json['number'],
        play = json['play'],
        account = json['account']
  ;

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'id': id,
        'image': image,
        'number': number,
        'play': play,
        'account': account,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
