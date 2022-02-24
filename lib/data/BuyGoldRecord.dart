import 'dart:convert';

class BuyGoldRecord {
  BuyGoldRecord();
  int id = 0;
  int ctime = 0;
  String orderId = '';
  int status = 0;
  int amount = 0;
  BuyGoldRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        ctime = json['ctime'],
        orderId = json['orderId'],
        status = json['status'],
        amount = json['amount'];
  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'ctime': ctime,
        'orderId': orderId,
        'status': status,
        'amount': amount,
      };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}