import 'dart:convert';

class GoldRecord {
  GoldRecord();

  int id = 0;
  int gold = 0;
  int ctime = 0;
  String reason = '';

  GoldRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        gold = json['gold'],
        ctime = json['ctime'],
        reason = json['reason'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'gold': gold,
    'ctime': ctime,
    'reason': reason,
  };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
