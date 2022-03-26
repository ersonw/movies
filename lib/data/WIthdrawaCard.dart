import 'dart:convert';

class WithdrawalCard {
  WithdrawalCard();
  int id=0;
  String name='';
  String bank='';
  String code='';
  WithdrawalCard.formJson(Map<String,dynamic> json):
      id=json['id'],
  name=json['name'],
  bank=json['bank'],
  code=json['code'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bank': bank,
    'code': code,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}