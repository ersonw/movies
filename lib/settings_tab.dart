// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/ProfileChangeNotifier.dart';
import 'package:movies/antd_ttf.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/functions.dart';
import 'package:movies/global.dart';
import 'package:movies/model/ConfigModel.dart';
import 'package:movies/system_ttf.dart';

import 'LockScreenCustom.dart';
import 'widgets.dart';

class SettingsTab extends StatefulWidget {
  static const title = '设置';
  static const androidIcon = Icon(Icons.settings);
  static const iosIcon = Icon(
    SystemTtf.shezhi,
    size: 42,
  );

  const SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final ConfigModel _configModel = ConfigModel();
  Config _config = Config();
  String _cacheSize = '';
  @override
  void initState() {
    super.initState();
    _config = _configModel.config;
    _configModel.addListener(() {
      setState(() {
        _config = _configModel.config;
      });
    });
    _initCache();
  }
  Future<void> _initCache() async{
    double size = await Global.loadApplicationCache();
    setState(() {
      _cacheSize = Global.formatSize(size);
    });
  }
  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        ListTile(
            leading: const Icon(
              SystemTtf.guanbi,
              color: Colors.red,
              size: 30,
            ),
            title: const Text('设置锁屏密码'),
            // The Material switch has a platform adaptive constructor.
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch.adaptive(
                  value: _config.bootLock,
                  onChanged: (value) => setState(() {
                    // print(value);
                    // _configModel.lock = value;
                    if (_config.bootLockPasswd == null || _configModel.lockPasswd == '') {
                      Navigator.of(context, rootNavigator: true).push<void>(
                        CupertinoPageRoute(
                          // fullscreenDialog: true,
                          builder: (context) =>
                              LockScreenCustom(LockScreenCustom.setPasswd),
                        ),
                      );
                    } else {
                      _configModel.lock = value;
                    }
                  }),
                ),
              ],
            )),
        ListTile(
            leading: const Icon(
              SystemTtf.bianji,
              size: 30,
            ),
            title: const Text('修改锁屏密码'),
            // The Material switch has a platform adaptive constructor.
            onTap: () {
              Navigator.of(context, rootNavigator: true).push<void>(
                CupertinoPageRoute(
                  // fullscreenDialog: true,
                  builder: (context) =>
                      LockScreenCustom((_configModel.lockPasswd == null || _configModel.lockPasswd == '') ? LockScreenCustom.setPasswd : LockScreenCustom.changePasswd),
                ),
              );
            },
            trailing: const Icon(AntdTtf.right)),
        ListTile(
            leading: const Icon(
              SystemTtf.bianji,
              size: 30,
            ),
            title: const Text('重置锁屏密码'),
            // The Material switch has a platform adaptive constructor.
            onTap: () async{
              if(_configModel.lockPasswd == null || _configModel.lockPasswd == ''){
                ShowAlertDialog(context, '重置锁屏密码', '未设置锁屏密码，请先配置锁屏密码!');
              }else{
                if(await ShowAlertDialogBool(context, '重置锁屏密码', '密码一旦重置不可找回，如需开启锁屏可重新设置密码,确定要重置锁屏密码吗？')){
                  setState(() {
                    _configModel.lockPasswd = '';
                    _configModel.lock = false;
                  });
                }
              }
            },
            trailing: const Icon(AntdTtf.right)),
        ListTile(
            leading: const Icon(
              SystemTtf.shanchu,
              size: 30,
            ),
            title: const Text('清理缓存'),
            // The Material switch has a platform adaptive constructor.
            onTap: () async{
              if(await ShowAlertDialogBool(context, '清除缓存', '一键清除缓存将清除应用所有缓存，包括视频数据等等，确定继续吗？')){
                await Global.clearApplicationCache();
                setState(() {
                  _initCache();
                });
              }
            },
            trailing: Text(_cacheSize)),
        ListTile(
          leading: const Icon(
            AntdTtf.idcard,
            size: 30,
          ),
          title: const Text('账号丢失找回'),
          // The Material switch has a platform adaptive constructor.
          onTap: () => {},
        ),
      ],
    );
  }

  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsTab.title),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildList(),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
