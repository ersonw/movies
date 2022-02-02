// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/antd_ttf.dart';
import 'package:movies/system_ttf.dart';

import 'widgets.dart';

class SettingsTab extends StatefulWidget {
  static const title = '设置';
  static const androidIcon = Icon(Icons.settings);
  static const iosIcon = Icon(SystemTtf.shezhi, size: 42,);

  const SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  var lockCode = false;

  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        ListTile(
          leading: const Icon(SystemTtf.guanbi, color: Colors.red, size: 30,),
          title: const Text('设置锁屏密码'),
          // The Material switch has a platform adaptive constructor.
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch.adaptive(
                value: lockCode,
                onChanged: (value) => setState(() => lockCode = value),
              ),
            ],
          )
        ),
        ListTile(
          leading: const Icon(SystemTtf.bianji, size: 30,),
          title: const Text('修改锁屏密码'),
          // The Material switch has a platform adaptive constructor.
          onTap: () => {
          },
          trailing: Icon(AntdTtf.right)
        ),
        ListTile(
          leading: const Icon(SystemTtf.shanchu, size: 30,),
          title: const Text('清理缓存'),
          // The Material switch has a platform adaptive constructor.
          onTap: () => {
          },
          trailing: Text('0K')
        ),
        ListTile(
          leading: const Icon(AntdTtf.idcard, size: 30,),
          title: const Text('账号丢失找回'),
          // The Material switch has a platform adaptive constructor.
          onTap: () => {
          },
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
