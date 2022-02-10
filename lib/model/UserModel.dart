import 'package:movies/data/User.dart';

import '../ProfileChangeNotifier.dart';

class UserModel extends ProfileChangeNotifier {
  User get user => profile.user;
  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user.token.isNotEmpty;
  String get token => user.token;
  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set token(String token){
    profile.user.token = token;
    notifyListeners();
  }
  set user(User user) {
    if (user != profile.user) {
      profile.user = user;
      notifyListeners();
    }
  }
}