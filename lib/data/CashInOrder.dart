import 'dart:convert';

class CashInOrder {
  CashInOrder();

  int id = 0;
  int amount = 0;
  String orderId = '';
  int updateTime = 0;
  int status = 0;

  CashInOrder.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        orderId = json['orderId'],
        updateTime = json['updateTime'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'orderId': orderId,
        'updateTime': updateTime,
        'status': status,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
