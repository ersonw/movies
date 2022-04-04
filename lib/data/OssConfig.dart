import 'dart:convert';

class OssConfig {
  OssConfig();

  String? bucketName;
  String? endpoint;
  String? ossName;

  OssConfig.formJson(Map<String, dynamic> json)
      : bucketName = json['bucketName'],
        endpoint = json['endpoint'],
        ossName = json['ossName'];

  Map<String, dynamic> toJson() => {
        'bucketName': bucketName,
        'endpoint': endpoint,
        'ossName': ossName,
      };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
