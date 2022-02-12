import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/data/SystemMessage.dart';

class SystemMessageModel extends MessagesChangeNotifier {
  List<SystemMessage> get systemMessages => messages.systemMessage;

  set systemMessages(List<SystemMessage> systemMessages){
    messages.systemMessage = systemMessages;
    notifyListeners();
  }
  void read(){
    for(int i=0;i< systemMessages.length;i++){
      systemMessages[i].isRead = true;
    }
  }
}