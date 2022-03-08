import 'package:movies/ProfileChangeNotifier.dart';
import 'package:movies/data/BuyDiamond.dart';
import 'package:movies/data/BuyGold.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/OssConfig.dart';
import 'package:movies/data/VIPBuy.dart';

class ConfigModel extends ProfileChangeNotifier {
  Config get config => profile.config;
  OssConfig get ossConfig => profile.config.ossConfig;
  List<VIPBuy> get vipBuys => profile.config.vipBuys;
  List<BuyDiamond> get buyDiamonds => profile.config.buyDiamonds;
  List<BuyGold> get buyGolds => profile.config.buyGolds;
  List<OnlinePay> get onlinePays => profile.config.onlinePays;
  bool  get lock => profile.config.bootLock;
  String? get lockPasswd => profile.config.bootLockPasswd;
  List<String> get searchRecords => profile.searchRecords;

  set searchRecords(List<String> searchRecords){
    profile.searchRecords = searchRecords;
    notifyListeners();
  }
  set config(Config conf){
    profile.config = conf;
    notifyListeners();
  }
  set ossConfig(OssConfig ossConf){
    profile.config.ossConfig = ossConf;
    notifyListeners();
  }
  set vipBuys(List<VIPBuy> vipBuys){
    profile.config.vipBuys = vipBuys;
    notifyListeners();
  }
  set buyDiamonds(List<BuyDiamond> buyDiamonds){
    profile.config.buyDiamonds = buyDiamonds;
    notifyListeners();
  }
  set buyGolds(List<BuyGold> buyGolds){
    profile.config.buyGolds = buyGolds;
    notifyListeners();
  }
  set onlinePays(List<OnlinePay> onlinePays){
    profile.config.onlinePays = onlinePays;
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