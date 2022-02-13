import 'package:movies/ProfileChangeNotifier.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/OssConfig.dart';

class ConfigModel extends ProfileChangeNotifier {
  Config get config => profile.config;
  OssConfig get ossConfig => profile.config.ossConfig;
  bool  get lock => profile.config.bootLock;
  String? get lockPasswd => profile.config.bootLockPasswd;

  set config(Config conf){
    profile.config = conf;
    notifyListeners();
  }
  set ossConfig(OssConfig ossConf){
    profile.config.ossConfig = ossConf;
    notifyListeners();
  }
  set lock(bool lock){
    if(lock && lockPasswd == null){
      return;
    }
    profile.config.bootLock = lock;
    notifyListeners();
  }
  set lockPasswd(String? lockPasswd){
    profile.config.bootLockPasswd = lockPasswd;
    notifyListeners();
  }
}