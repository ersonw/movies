import 'package:movies/ProfileChangeNotifier.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/OssConfig.dart';

class ConfigModel extends ProfileChangeNotifier {
  Config get config => profile.config;
  OssConfig get ossConfig => profile.config.ossConfig;

  set config(Config conf){
    profile.config = conf;
    notifyListeners();
  }
  set ossConfig(OssConfig ossConf){
    profile.config.ossConfig = ossConf;
    notifyListeners();
  }
}