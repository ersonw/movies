import 'dart:convert';

class VIPBuy {
  VIPBuy();
  double amount = 0;
  double original = 0;
  String title = '';
  String describe = '';
  VIPBuy.formJson(Map<String, dynamic> json) :
      amount = json['amount'],
  original = json['original'],
  title = json['title'],
  describe = json['describe'];

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'original': original,
    'title': title,
    'describe': describe,
  };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}