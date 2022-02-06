import 'EntityFactory.dart';

class BaseListEntity<T> {
  int code;
  String message;
  List<T> data;

  BaseListEntity({required this.code, required this.message, required this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = [];
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      for (var v in (json['data'] as List)) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      }
    }

    return BaseListEntity(
      code: json["code"],
      message: json["message"],
      data: mData,
    );
  }
}
