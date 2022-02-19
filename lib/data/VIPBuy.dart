import 'dart:convert';

class VIPBuy {
  VIPBuy();

  int id = 0;
  int type = 0;
  int amount = 0;
  int original = 0;
  String title = '';
  String describes = '';
  String image = '';
  String currency = '';
  bool isText = false;

  VIPBuy.formJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        amount = json['amount'],
        original = json['original'],
        title = json['title'],
        image = json['image'] ?? '',
        currency = json['currency'] ?? '',
        isText = json['isText'] ?? false,
        describes = json['describes'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'original': original,
        'title': title,
        'describes': describes,
        'image': image,
        'currency': currency,
        'isText': isText,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
