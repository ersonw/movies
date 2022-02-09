class SystemMessage {
  SystemMessage();

  String date = '';
  String title = '';
  String str = '暂无消息';
  int id = 0;
  bool isRead = false;

  SystemMessage.formJson(Map<String, dynamic> json)
      : date = json['date'],
        title = json['title'],
        str = json['str'],
        isRead = json['isRead'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'title': title,
        'str': str,
        'id': id,
        'isRead': isRead,
      };
}
