import 'dart:convert';

class OnlinePay {
  static const int PAY_ONLINE_VIP = 100;
  static const int PAY_ONLINE_GOLD = 101;
  static const int PAY_ONLINE_DIAMOND = 102;

  OnlinePay();
  String title ='';
  String iconImage = '';
  int id = 0;
  OnlinePay.formJson(Map<String, dynamic> json):
      title = json['title'],
  iconImage = json['iconImage'],
  id = json['id'];
  Map<String, dynamic> toJson() => {
    'title': title,
    'iconImage': iconImage,
    'id': id,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}