import 'package:movies/data/User.dart';

import '../ProfileChangeNotifier.dart';

class UserModel extends ProfileChangeNotifier {
  User get user => profile.user;
  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user.token.isNotEmpty;
  String get token => user.token;
  String? get avatar => user.avatar;
  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set avatar(String? avatar){
    profile.user.avatar = avatar;
    notifyListeners();
  }
  set token(String token){
    profile.user.token = token;
    notifyListeners();
  }
  set user(User user) {
    // print('我已通知');
    profile.user = user;
    notifyListeners();
  }
}