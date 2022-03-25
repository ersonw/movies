import 'dart:convert';

class GoldRecord {
  GoldRecord();

  int id = 0;
  int gold = 0;
  int add_time = 0;
  int update_time = 0;
  String reason = '';

  GoldRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        gold = json['gold'],
        add_time = json['add_time'],
        update_time = json['update_time'],
        reason = json['reason'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'gold': gold,
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
