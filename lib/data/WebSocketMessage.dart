import 'dart:convert';

class WebSocketMessage {
  static const int login = 100;
  static const int login_success = 101;
  static const int login_fail = 102;
  static const int message_kefu_sending = 103;
  static const int message_kefu_send_success = 104;
  static const int message_kefu_send_fail = 105;
  static const int message_kefu_recevie = 106;
  static const int user_change = 107;
  static const int user_change_fail = 108;
  static const int user_change_success = 109;

  WebSocketMessage();

  int code = 0;
  String? message;
  String? data;

  WebSocketMessage.formJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        data = json['data'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data,
      };

  @override
  String toString() {
    super.toString();
    return jsonEncode(toJson());
  }
}
