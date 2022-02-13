import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/User.dart';
import 'package:movies/model/ConfigModel.dart';
import 'package:movies/model/UserModel.dart';
import 'package:movies/utils/UploadOssUtil.dart';
import 'dart:io';
import 'global.dart';

class AccountManager extends StatefulWidget {
  const AccountManager({Key? key}) : super(key: key);

  @override
  _AccountManager createState() => _AccountManager();
}

class _AccountManager extends State<AccountManager> {
  User _user = User();
  Config _config = Config();
  final UserModel _userModel = UserModel();
  final ConfigModel _configModel = ConfigModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = _userModel.user;
    _config = _configModel.config;
    _userModel.addListener(() {
      setState(() {
        _user = _userModel.user;
      });
    });
    _configModel.addListener(() {
      setState(() {
        _config = _configModel.config;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Column(
        children: [
          Expanded(child: _buildList()),
          SizedBox(
            width: double.infinity,
            height: 70.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 7.0, 16.0, 7.0),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              child: TextButton(
                onPressed: () {  },
                child: const Text('解除绑定',style: TextStyle(fontSize: 20,color: Colors.red),),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildAvatar() {
    if ((_userModel.avatar == null || _userModel.avatar == '') || _userModel.avatar?.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(
      _userModel.avatar!,
    );
  }

  _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        TextButton(
            onPressed: () async {
              List<Media>? res = await ImagesPicker.pick(
                count: 1,
                pickType: PickType.image,
                language: Language.System,
                cropOpt: CropOption(
                    aspectRatio: CropAspectRatio.custom,
                    cropType: CropType.circle),
              );
              if (res != null) {
                String image = res[0].thumbPath!;
                String? images = await UploadOssUtil.upload(
                    File(image), Global.getNameByPath(image));
                if (images != null) {
                  _userModel.avatar = images;
                 return Global.showWebColoredToast("上传成功！");
                }
              }
              Global.showWebColoredToast("修改头像失败！");
            },
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  // margin: EdgeInsets.only(left: vw()),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                        // image: AssetImage('assets/image/default_head.gif'),
                        image: _buildAvatar(),
                      )),
                ),
                const Text(
                  "修改头像",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                )
              ],
            )),
        ListTile(
            leading: const Icon(
              Icons.assessment,
              color: Colors.grey,
              size: 30,
            ),
            title: const Text('用户昵称'),
            // The Material switch has a platform adaptive constructor.
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch.adaptive(
                  value: _config.bootLock,
                  onChanged: (value) => setState(() {
                    // print(value);
                    // _configModel.lock = value;
                    // if (_config.bootLockPasswd == null || _configModel.lockPasswd == '') {
                    //   Navigator.of(context, rootNavigator: true).push<void>(
                    //     CupertinoPageRoute(
                    //       // fullscreenDialog: true,
                    //       builder: (context) => ,
                    //     ),
                    //   );
                    // } else {
                    //   _configModel.lock = value;
                    // }
                  }),
                ),
              ],
            )),
      ],
    );
  }
}
