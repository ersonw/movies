import 'package:movies/data/DianZanMessage.dart';
import 'package:movies/data/GuanZhuMessage.dart';
import 'package:movies/data/KefuMessage.dart';
import 'package:movies/data/ShenHeMessage.dart';
import 'package:movies/data/SystemMessage.dart';

class Messages {
  List<SystemMessage> systemMessage = [];
  List<KefuMessage> kefuMessage = [];
  List<ShenHeMessage> shenheMessage = [];
  List<DianZanMessage> dianzanMessage = [];
  List<GuanZhuMessage> guanzhuMessage = [];

  Messages();

  Messages.formJson(Map<String, dynamic> json)
      : systemMessage = (json['systemMessage'] as List)
            .map((i) => SystemMessage.formJson(i))
            .toList();

  Map<String, dynamic> toJson() => {
        'systemMessage': systemMessage.map((e) => e.toJson()).toList(),
      };
}
