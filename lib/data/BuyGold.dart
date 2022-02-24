import 'dart:convert';

class BuyGold {
  BuyGold();
  int id = 0;
  int amount = 0;
  int gold = 0;

  BuyGold.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        gold = json['gold'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'gold': gold,
  };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}