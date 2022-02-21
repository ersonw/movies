import 'package:flutter/cupertino.dart';

import 'global.dart';

class LoadingChangeNotifier extends ChangeNotifier {
  bool get isLoading => Global.isLoading;
  set isLoading(bool isLoading){
    Global.isLoading = isLoading;
    notifyListeners();
  }
}