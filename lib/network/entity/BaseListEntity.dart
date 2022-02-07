import 'EntityFactory.dart';

class BaseEntity<T> {
  int code;
  String message;
  String data;

  BaseEntity({required this.code, required this.message, required this.data});

  factory BaseEntity.fromJson(json) {
    return BaseEntity(
      code: json["code"],
      message: json["message"],
      // data值需要经过工厂转换为我们传进来的类型
      data: json["data"],
    );
  }
}