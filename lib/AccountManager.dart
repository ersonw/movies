import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/BindPhonePage.dart';
import 'package:movies/ChangePasswordPage.dart';
import 'package:movies/InviteCodeInputPage.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/User.dart';
import 'package:movies/functions.dart';
import 'dart:io';
import 'package:movies/system_ttf.dart';
import 'package:movies/utils/JhPickerTool.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'package:image_picker/image_picker.dart';
import 'LoginPage.dart';
import 'QRCodeDialog.dart';
import 'SlideRightRoute.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class AccountManager extends StatefulWidget {
  const AccountManager({Key? key}) : super(key: key);

  @override
  _AccountManager createState() => _AccountManager();
}

class _AccountManager extends State<AccountManager> {
  User _user = User();
  Config _config = Config();
  String _cacheSize = '';
  bool alive = true;

  void _changeUser() {
    setState(() {
      _user = userModel.user;
    });
  }

  void _changeConfig() {
    setState(() {
      _config = configModel.config;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    alive = false;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = userModel.user;
    _config = configModel.config;
    userModel.addListener(() {
      if (alive) {
        _changeUser();
      }
    });
    configModel.addListener(() {
      if (alive) {
        _changeConfig();
      }
    });
    _initCache();
  }

  Future<void> _initCache() async {
    double size = await Global.loadApplicationCache();
    setState(() {
      _cacheSize = Global.formatSize(size);
    });
  }

  _logout() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getDiamondOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['state'] == 'ok') {
        Global.getUserInfo();
      } else if (map['msg'] != null) {
        Global.showWebColoredToast(map['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: const CupertinoNavigationBar(),
      child: Column(
        children: [
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  _buildAvatar() {
    if ((_user.avatar == null || _user.avatar == '') ||
        _user.avatar?.contains('http') == false) {
      return const AssetImage(ImageIcons.default_head);
    }
    return NetworkImage(
      _user.avatar!,
    );
  }

  _changeSex(int sex) {
    if (sex == _user.sex) return;
    setState(() {
      _user.sex = sex;
    });
    Global.changeSex(sex);
  }

  String _getPhoneShort() {
    return _user.phone != null && _user.phone != ''
        ? ('${_user.phone?.substring(0, 6)}****${_user.phone?.substring(12)}')
        : '';
  }

  Future<String> getImage(isTakePhoto) async {
    // Navigator.pop(context); // 选完图片后 关闭底部弹框
    File? image = await ImagePicker.pickImage(
        source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
    if (image == null) {
      return '';
    }
    return image.path;
  }

  _buildBgImage(String avatar) {
    if ((avatar == null || avatar == '') || avatar.contains('http') == false) {
      return null;
      // return const DecorationImage(
      //   image: AssetImage(ImageIcons.bgImage),
      //   fit: BoxFit.fill,
      // );
    }
    return DecorationImage(
      image: NetworkImage(avatar),
      fit: BoxFit.fill,
    );
  }

  _buildList() {
    return ListView(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            InkWell(
              onTap: () async {
                // String res = await getImage(false);
                // if (res.isNotEmpty) {
                //   String image = res;
                //   // _user.avatar = image;
                //   Global.changeBgImage(image);
                // }
              },
              child: Container(
                height: 210,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    // borderRadius: BorderRadius.circular(50.0),
                    image: _buildBgImage(_user.bkImage),),
              ),
            ),
            Container(
              width: ((MediaQuery.of(context).size.width) / 1),
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ((MediaQuery.of(context).size.width) / 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios,color: Colors.black,),
                          ),
                        ],
                      ),
                    ),
                    const Text('账号管理',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                  ]
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                width: ((MediaQuery.of(context).size.width) / 1),
                child: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    height: 210,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            width: 100,
                            height: 100,
                            // margin: EdgeInsets.only(left: vw()),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(50.0),
                              image: DecorationImage(
                                // image: AssetImage('assets/image/default_head.gif'),
                                image: _buildAvatar(),
                                fit: BoxFit.fill,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10, //阴影范围
                                  spreadRadius: 0.1, //阴影浓度
                                  color: Colors.grey.withOpacity(0.2), //阴影颜色
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            String res = await getImage(false);
                            if (res.isNotEmpty) {
                              String image = res;
                              // _user.avatar = image;
                              Global.changeAvatar(image);
                            } else {
                              // Global.showWebColoredToast("修改头像失败！");
                            }
                          },
                          child: const Text(
                            "修改头像",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 50)),
                  InkWell(
                    onTap: () async {
                      String input = await ShowInputDialogAsync(context,
                          text: _user.nickname, hintText: '输入需要修改的昵称');
                      if (input == '') return;
                      Global.changeNickname(input);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black26,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("昵称", style: TextStyle(fontSize: 16)),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            SizedBox(
                              width: ((MediaQuery.of(context).size.width) / 2),
                              child: Text(
                                _user.nickname,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  InkWell(
                    onTap: () async {
                      String input = await ShowInputDialogAsync(context,
                          text: _user.email != null ? _user.email : '', hintText: '输入电子邮箱地址');
                      if (input == '') return;
                      // setState(() {
                      //   _user.email = input;
                      // });
                      Global.changeEmail(input);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.black26,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("电子邮箱", style: TextStyle(fontSize: 16)),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            SizedBox(
                              width: ((MediaQuery.of(context).size.width) / 2),
                              child: Text(
                                _user.email != null ? _user.email : '',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  InkWell(
                    onTap: () async {
                      List<BottomMenu> lists = [];
                      BottomMenu botton = BottomMenu();
                      botton.title = '男性';
                      botton.fn = () => _changeSex(0);
                      lists.add(botton);
                      botton = BottomMenu();
                      botton.title = '女性';
                      botton.fn = () => _changeSex(1);
                      lists.add(botton);
                      await ShowBottomMenu(context, lists, text: '请选择性别');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            Icon(
                              Icons.transgender_outlined,
                              size: 20,
                              color: Colors.black26,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("性别", style: TextStyle(fontSize: 16)),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            SizedBox(
                              width: ((MediaQuery.of(context).size.width) / 2),
                              child: Text(
                                _user.sex == 0 ? '男性' : '女性',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  InkWell(
                    onTap: () async {
                      JhPickerTool.showDatePicker(context,
                          dateType: DateType.YMD,
                          value:
                          DateTime.fromMillisecondsSinceEpoch(_user.birthday),
                          clickCallBack: (t, p) {
                            if (_user.birthday == p) return;
                            // setState(() {
                            //   _user.birthday = p;
                            // });
                            Global.changeAge(p);
                          });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            Icon(
                              Icons.data_usage_outlined,
                              size: 20,
                              color: Colors.black26,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("年龄'", style: TextStyle(fontSize: 16)),
                          ]),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            SizedBox(
                              width: ((MediaQuery.of(context).size.width) / 2),
                              child: Text(
                                Global.getYearsOld(_user.birthday),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push<void>(
                        CupertinoPageRoute(
                          // fullscreenDialog: true,
                          title: '更改密码',
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            Icon(
                              Icons.password_outlined,
                              size: 20,
                              color: Colors.black26,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("更换密码", style: TextStyle(fontSize: 16)),
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Global.toBindPhonePage();
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(
                              Icons.phone_iphone,
                              size: 20,
                              color: Colors.black26,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                                _user.phone == null || _user.phone == ''
                                    ? "绑定手机"
                                    : '更换手机',
                                style: const TextStyle(fontSize: 16)),
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:  [
                                _user.phone != null && _user.phone != '' ? Text('${_user.phone?.substring(0,4)}****${_user.phone?.substring(9)}', style: TextStyle(color: Colors.red)) : Container(),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Global.showIDDIalog();
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: const [
                            Icon(
                              Icons.format_indent_decrease,
                              size: 20,
                              color: Colors.black26,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("保存身份ID，账号防丢失", style: TextStyle(fontSize: 16)),
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ]),
                        ]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  _user.phone != null && _user.phone != ''
                      ? InkWell(
                    onTap: () async {
                      if (await ShowAlertDialogBool(context, '危险提示',
                          '解除绑定手机号之后将无法找回账号并且部分功能将限制使用，确定解除绑定手机号吗？')) {
                        Global.unBindPhone();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            // Colors.redAccent,
                            Color(0xFFFC8A7D),
                            Color(0xffff0010),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 1.0, color: Colors.black12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 30, right: 30),
                        child: const Text(
                          '解绑手机号',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                      : Container(),
                ])),
          ],
        )
      ],
    );
  }
}
