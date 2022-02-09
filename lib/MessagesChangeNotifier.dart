import 'package:flutter/cupertino.dart';
import 'package:movies/data/Messages.dart';

import 'data/Profile.dart';
import 'global.dart';

class MessagesChangeNotifier extends ChangeNotifier {
  Messages get messages => Global.messages;

  @override
  void notifyListeners() {
    Global.saveMessages(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}