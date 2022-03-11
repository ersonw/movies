import 'dart:convert';

class Download {
  Download();

  String path = '';
  String url = '';
  String title = '';
  bool finish = false;
  bool error = false;
  double progress = 0;

  Download.formJson(Map<String, dynamic> json)
      : path = json['path'],
        url = json['url'],
        title = json['title'],
        finish = json['finish'],
        progress = json['progress'];

  Map<String, dynamic> toJson() => {
        'path': path,
        'url': url,
        'title': title,
        'finish': finish,
        'progress': progress,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
