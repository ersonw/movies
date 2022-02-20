import 'dart:convert';

class CrateOrder {
  CrateOrder();
  String title ='';
  String? describes ='';
  String? currency ='';
  int amount =0;
  CrateOrder.formJson(Map<String, dynamic> json):
      title = json['title'],
  describes = json['describes'],
  currency = json['currency'],
  amount = json['amount'];
  Map<String,dynamic> toJson() => {
    'title': title,
    'describes': describes,
    'currency': currency,
    'amount': amount,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}