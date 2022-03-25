import 'dart:convert';

class GoldRecord {
  GoldRecord();

  int id = 0;
  int gold = 0;
  int addTime = 0;
  int updateTime = 0;
  String reason = '';

  GoldRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        gold = json['gold'],
        addTime = json['addTime'],
        updateTime = json['updateTime'],
        reason = json['reason'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'gold': gold,
    'addTime': addTime,
    'updateTime': updateTime,
    'reason': reason,
  };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
