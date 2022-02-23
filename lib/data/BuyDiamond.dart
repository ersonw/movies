import 'dart:convert';

class BuyDiamond {
  BuyDiamond();

  int id = 0;
  int amount = 0;
  int diamond = 0;

  BuyDiamond.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        diamond = json['diamond'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'diamond': diamond,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
