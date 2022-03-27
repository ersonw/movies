import 'dart:convert';

class BalanceRecord {
  BalanceRecord();

  int id = 0;
  int amount = 0;
  String reason = '';
  int status = 0;
  int addTime = 0;
  int updateTime = 0;

  BalanceRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        reason = json['reason'],
        status = json['status'],
        addTime = json['addTime'],
        updateTime = json['updateTime'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'reason': reason,
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
