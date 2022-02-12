import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/data/KefuMessage.dart';

class KeFuMessageModel extends MessagesChangeNotifier {
  List<KefuMessage> get kefuMessages => messages.kefuMessage;

  set kefuMessages(List<KefuMessage> kefuMessage){
    messages.kefuMessage = kefuMessages;
    notifyListeners();
  }
  //信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  int getStatus(String id){
    for (int i = 0; i < kefuMessages.length; i++) {
      if (kefuMessages[i].id.contains(id)) {
        notifyListeners();
        return kefuMessages[i].status;
      }
    }
    return 0;
  }
  void status(String id, int status){
    for (int i = 0; i < kefuMessages.length; i++) {
      if (kefuMessages[i].id.contains(id)) {
        kefuMessages[i].status = status;
        notifyListeners();
        return;
      }
    }
  }
  void del(KefuMessage message){
    for (int i = 0; i < kefuMessages.length; i++) {
      if (kefuMessages[i].id.contains(message.id)) {
        kefuMessages.removeAt(i);
        notifyListeners();
        return;
      }
    }
  }
  void change(KefuMessage message){
    for (int i = 0; i < kefuMessages.length; i++) {
      if (kefuMessages[i].id.contains(message.id)) {
        kefuMessages[i] = message;
        notifyListeners();
        return;
      }
    }
  }
  int add(KefuMessage message) {
    bool have = false;
    for (int i = 0; i < kefuMessages.length; i++) {
      if (kefuMessages[i] == message || kefuMessages[i].id.contains(message.id)) {
        have = true;
      }
    }
    if (!have) {
      kefuMessages.add(message);
      return kefuMessages.length - 2;
    }
    return 0;
  }

  void read() {
    kefuMessages = kefuMessages.map((e) {
      e.isRead = true;
      return e;
    }).toList();
    notifyListeners();
  }
}
