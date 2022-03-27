import 'dart:convert';

class WithdrawalRecord {
  WithdrawalRecord();

  int id = 0;
  int amount=0;
  String reason='';
  String orderNo = '';
  String bank = '';
  String code = '';
  int status = 0;
  int addTime = 0;
  int updateTime = 0;
  bool open = false;

  WithdrawalRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        reason = json['reason'],
        orderNo = json['orderNo'],
        bank = json['bank'],
        code = json['code'],
        status = json['status'],
        addTime = json['addTime'],
        updateTime = json['updateTime'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderNo': orderNo,
        'amount': amount,
        'reason': reason,
        'bank': bank,
        'code': code,
        'status': status,
        'addTime': addTime,
        'updateTime': updateTime,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
