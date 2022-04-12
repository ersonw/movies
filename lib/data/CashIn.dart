import 'dart:convert';

class CashIn {
  CashIn();

  int id = 0;
  int amount = 0;
  int vip = 0;

  CashIn.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        vip = json['vip'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'vip': vip,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
