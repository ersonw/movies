import 'dart:convert';

import 'package:movies/data/BuyDiamond.dart';
import 'package:movies/data/BuyGold.dart';
import 'package:movies/data/Download.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/OssConfig.dart';
import 'package:movies/data/VIPBuy.dart';

import '../global.dart';

class Config {
  // double version = double.parse(Global.packageInfo.version);
  int version = 0;
  String hash = '';
  String text = '';
  bool autoLogin = false;
  String bootImage = '';
  String domain = '';
  String wsDomain = '';
  String shareDomain = '';
  String urlIos = '';
  String urlAndroid = '';
  String groupLink = '';
  String kefuGameUrl = '';
  String activityUrl = '';
  String kefuUrl = '';
  bool force = false;
  bool bootLock = false;
  String? bootLockPasswd = '';
  OssConfig ossConfig = OssConfig();
  List<VIPBuy> vipBuys = [];
  List<OnlinePay> onlinePays = [];
  List<BuyDiamond> buyDiamonds = [];
  List<BuyGold> buyGolds = [];
  List<Download> downloads = [];

  Config();

  Config.fromJson(Map<String, dynamic> json)
      : hash = json['hash'],
        text = json['text'],
        urlIos = json['urlIos'],
        urlAndroid = json['urlAndroid'],
        groupLink = json['groupLink'],
        kefuGameUrl = json['kefuGameUrl'],
        kefuUrl = json['kefuUrl'],
        domain = json['domain'],
        wsDomain = json['wsDomain'],
        shareDomain = json['shareDomain'],
        activityUrl = json['activityUrl'],
        force = json['force'] ?? false,
        version = json['version'] ?? 0,
        autoLogin = json['autoLogin'] ?? false,
        bootImage = json['bootImage'],
        bootLock = json['bootLock'] ?? false,
        bootLockPasswd = json['bootLockPasswd'],
        downloads = json['downloads'] == null
            ? []
            : (json['downloads'] as List)
                .map((i) => Download.formJson(i))
                .toList(),
        vipBuys = json['vipBuys'] == null
            ? []
            : (json['vipBuys'] as List).map((i) => VIPBuy.formJson(i)).toList(),
        onlinePays = json['onlinePays'] == null
            ? []
            : (json['onlinePays'] as List)
                .map((i) => OnlinePay.formJson(i))
                .toList(),
        buyDiamonds = json['buyDiamonds'] == null
            ? []
            : (json['buyDiamonds'] as List)
                .map((i) => BuyDiamond.formJson(i))
                .toList(),
        buyGolds = json['buyGolds'] == null
            ? []
            : (json['buyGolds'] as List)
                .map((i) => BuyGold.formJson(i))
                .toList(),
        ossConfig =
            OssConfig.formJson(json['ossConfig'] ?? OssConfig().toJson());

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'text': text,
        'urlIos': urlIos,
        'urlAndroid': urlAndroid,
        'groupLink': groupLink,
        'kefuGameUrl': kefuGameUrl,
        'kefuUrl': kefuUrl,
        'domain': domain,
        'wsDomain': wsDomain,
        'shareDomain': shareDomain,
        'activityUrl': activityUrl,
        'force': force,
        'version': version,
        'autoLogin': autoLogin,
        'bootImage': bootImage,
        'bootLock': bootLock,
        'bootLockPasswd': bootLockPasswd,
        'ossConfig': ossConfig.toJson(),
        'downloads': downloads.map((e) => e.toJson()).toList(),
        'vipBuys': vipBuys.map((e) => e.toJson()).toList(),
        'onlinePays': onlinePays.map((e) => e.toJson()).toList(),
        'buyDiamonds': buyDiamonds.map((e) => e.toJson()).toList(),
        'buyGolds': buyGolds.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
