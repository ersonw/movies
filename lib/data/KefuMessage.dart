class KefuMessage {
  KefuMessage();

  String? text;
  String? image;
  int date = 0;
  bool isMe = false;
  bool isRead = true;

  KefuMessage.formJson(Map<String, dynamic> json)
      : text = json['text'],
        image = json['image'],
        date = json['date'],
        isRead = json['isRead'],
        isMe = json['isMe'];

  Map<String, dynamic> toJson() =>
      {
        'text': text,
        'image': image,
        'date': date,
        'isRead' : isRead,
        'isMe': isMe,
      };
}
