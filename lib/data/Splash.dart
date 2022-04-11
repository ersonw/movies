import 'dart:convert';

class Splash{
  Splash();
  String image = '';
  int du =0;
  Splash.formJson(Map<String, dynamic> json):
      image = json['image'],
  du = json['du'];
  Map<String, dynamic> toJson() => {
    'image' : image,
    'du' : du,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}