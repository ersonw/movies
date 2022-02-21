import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:movies/data/OnlinePay.dart';

class OrderRecords {
  OrderRecords();

  int id = 0;
  int type = 0;
  OnlinePay onlinePay = OnlinePay();
  int amount = 0;
  int ctime = 0;
  int utime = 0;
  int status = 0;
  String orderId = '';
  String orderNo = '';

  OrderRecords.formJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        onlinePay = OnlinePay.formJson(json['onlinePay']),
        amount = json['amount'],
        ctime = json['ctime'],
        utime = json['utime'],
        status = json['status'],
        orderId = json['orderId'],
        orderNo = json['orderNo'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'onlinePay': onlinePay.toJson(),
        'amount': amount,
        'ctime': ctime,
        'utime': utime,
        'status': status,
        'orderId': orderId,
        'orderNo': orderNo,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
