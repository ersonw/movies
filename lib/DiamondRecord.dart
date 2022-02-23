import 'dart:convert';

class DiamondRecord {
  DiamondRecord();

  int id = 0;
  int diamond = 0;
  int ctime = 0;
  String reason = '';

  DiamondRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        diamond = json['diamond'],
        ctime = json['ctime'],
        reason = json['reason'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'diamond': diamond,
        'ctime': ctime,
        'reason': reason,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
