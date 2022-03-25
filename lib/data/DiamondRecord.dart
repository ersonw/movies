import 'dart:convert';

class DiamondRecord {
  DiamondRecord();

  int id = 0;
  int diamond = 0;
  int addTime = 0;
  int updateTime = 0;
  String reason = '';

  DiamondRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        diamond = json['diamond'],
        addTime = json['addTime'],
        updateTime = json['updateTime'],
        reason = json['reason'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'diamond': diamond,
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
