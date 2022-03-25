import 'dart:convert';

class DiamondRecord {
  DiamondRecord();

  int id = 0;
  int diamond = 0;
  int add_time = 0;
  int update_time = 0;
  String reason = '';

  DiamondRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        diamond = json['diamond'],
        add_time = json['add_time'],
        update_time = json['update_time'],
        reason = json['reason'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'diamond': diamond,
        'add_time': add_time,
        'update_time': update_time,
        'reason': reason,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
