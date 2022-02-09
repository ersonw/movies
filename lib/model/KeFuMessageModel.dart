import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/data/KefuMessage.dart';

class KeFuMessageModel extends MessagesChangeNotifier {
  List<KefuMessage> get kefuMessages => messages.kefuMessage;

  set kefuMessages(List<KefuMessage> kefuMessage){
    messages.kefuMessage = kefuMessages;
    notifyListeners();
  }
  //信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  void add(KefuMessage message) {
    bool have = false;
    for (int i = 0; i < kefuMessages.length; i++) {
      if (kefuMessages[i] == message) {
        have = true;
      }
    }
    if (!have) {
      kefuMessages.add(message);
      notifyListeners();
    }
  }

  void read() {
    kefuMessages = kefuMessages.map((e) {
      e.isRead = true;
      return e;
    }).toList();
    notifyListeners();
  }
}
