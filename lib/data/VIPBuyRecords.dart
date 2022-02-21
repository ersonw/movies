import 'dart:convert';

import 'package:movies/data/VIPBuy.dart';

class VIPBuyRecords {
  VIPBuyRecords();

  int id = 0;
  int ctime = 0;
  String orderId = '';
  int status = 0;
  int amount = 0;
  VIPBuy vipBuy = VIPBuy();

  VIPBuyRecords.formJson(Map<String, dynamic> json)
      : id = json['id'],
        ctime = json['ctime'],
        orderId = json['orderId'],
        status = json['status'],
        amount = json['amount'],
        vipBuy = VIPBuy.formJson(json['vipBuy']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'ctime': ctime,
        'orderId': orderId,
        'status': status,
        'amount': amount,
        'vipBuy': vipBuy.toJson()
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
