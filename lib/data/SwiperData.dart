import 'dart:convert';

class SwiperData {
  SwiperData();

  String image = '';
  int id = 0;
  String url = '';

  SwiperData.formJson(Map<String, dynamic> json)
      : image = json['image'],
        id = json['id'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'url': url,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
