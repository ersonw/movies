import 'dart:convert';

import 'package:movies/data/BuyDiamond.dart';
import 'package:movies/data/BuyGold.dart';
import 'package:movies/data/Download.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/OssConfig.dart';
import 'package:movies/data/VIPBuy.dart';

class Config {
  double version = 1.0;
  String hash = '';
  bool autoLogin = false;
  String bootImage = '';
  String domain = '';
  String url = '';
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
        url = json['url'],
        domain = json['domain'],
        force = json['force'] ?? false,
        version = json['version'] ?? 1.0,
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
        'url': url,
        'domain': domain,
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
