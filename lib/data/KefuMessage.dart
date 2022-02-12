import 'dart:convert';

import '../global.dart';

class KefuMessage {
  KefuMessage(){
    id = Global.generateMd5('${Global.uid}${DateTime.now().millisecondsSinceEpoch}');
    date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    status = 0;
  }
  String id = '';
  String? text;
  String? image;
  int date = 0;
  bool isMe = false;
  bool isRead = false;
  int status = 0;

  KefuMessage.formJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        image = json['image'],
        date = json['date'],
        isRead = json['isRead'] ?? false,
        status = json['status'] ?? 0,
        isMe = json['isMe'] ?? false;

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'text': text,
        'image': image,
        'date': date,
        'isRead' : isRead,
        'isMe': isMe,
        'status' : status,
      };
  @override
  String toString() {
    super.toString();
    return jsonEncode(toJson());
  }
}
