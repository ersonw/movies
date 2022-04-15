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
  void _changeUser(){
    setState(() {
      _user = userModel.user;
    });
  }
  void _changeConfig(){
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
      if(alive){
        _changeUser();
      }
    });
    configModel.addListener(() {
      if(alive){
        _changeConfig();
      }
    });
    _initCache();
  }
  Future<void> _initCache() async{
    double size = await Global.loadApplicationCache();
    setState(() {
      _cacheSize = Global.formatSize(size);
    });
  }
  _logout()async{
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getDiamondOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['state'] == 'ok') {
        Global.getUserInfo();
      }else if(map['msg'] != null){
        Global.showWebColoredToast(map['msg']);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Column(
        children: [
          Expanded(child: _buildList()),
          _user.phone==null || _user.phone == '' ? Container() : SizedBox(
            width: double.infinity,
            height: 70.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 7.0, 16.0, 7.0),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              child: TextButton(
                onPressed: ()async {
                 await Global.getUserInfo();
                 if(_user.phone != null && _user.phone != ''){
                   if(await ShowAlertDialogBool(context, '解绑设备', '确认要解绑手机号吗?')){
                     setState(() {
                       _user.phone = '';
                     });
                     Global.changeUserProfile(_user);
                     Global.showWebColoredToast('手机号解除绑定成功!');
                   }
                 }
                },
                child: const Text('解除手机号',style: TextStyle(fontSize: 20,color: Colors.red),),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildAvatar() {
    if ((_user.avatar == null || _user.avatar == '') || _user.avatar?.contains('http') == false) {
      return const AssetImage(ImageIcons.default_head);
    }
    return NetworkImage(
      _user.avatar!,
    );
  }
  _changeSex(int sex){
    if(sex == _user.sex) return;
    setState(() {
      _user.sex = sex;
    });
    Global.changeUserProfile(_user);
  }
  String _getPhoneShort(){
    return _user.phone != null && _user.phone !='' ? ('${_user.phone?.substring(0,6)}****${_user.phone?.substring(12)}') : '';
  }
  Future<String> getImage(isTakePhoto) async {
    // Navigator.pop(context); // 选完图片后 关闭底部弹框
    File? image = await ImagePicker.pickImage(
        source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
    if(image == null){
      return '';
    }
    return image.path;
  }
  _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ?
        TextButton(
            onPressed: () async {
              // List<Media>? res = await ImagesPicker.pick(
              //   count: 1,
              //   pickType: PickType.image,
              //   language: Language.System,
              //   cropOpt: CropOption(
              //       aspectRatio: CropAspectRatio.custom,
              //       cropType: CropType.circle),
              // );
              String res = await getImage(false);
              if (res.isNotEmpty) {
                String image = res;
                _user.avatar = image;
                Global.changeUserProfile(_user);
              }else{
                // Global.showWebColoredToast("修改头像失败！");
              }
              // print(await getImage(false));
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
            )
        ) : Container(),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ?
        TextButton(
          onPressed: () async{
            String input = await ShowInputDialogAsync(context, text: _user.nickname, hintText: '输入需要修改的昵称');
            if(input == '') return;
              setState(() {
                _user.nickname = input;
              });
              Global.changeUserProfile(_user);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.assessment,size: 30,color: Colors.grey,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: const Text('昵称',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: ((MediaQuery.of(context).size.width) / 2),
                    child: Text(_user.nickname,style: const TextStyle(color: Colors.grey,fontSize: 18,overflow: TextOverflow.ellipsis),textAlign: TextAlign.right,),
                  ),
                  // Text(_user.nickname,style: const TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ) : Container(),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ?
        TextButton(
          onPressed: () async{
            String input = await ShowInputDialogAsync(context, text: _user.email, hintText: '输入电子邮箱地址');
            if(input == '') return;
              setState(() {
                _user.email = input;
              });
              Global.changeUserProfile(_user);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.assessment,size: 30,color: Colors.grey,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: const Text('电子邮箱',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _user.email != null ? SizedBox(
                    width: ((MediaQuery.of(context).size.width) / 2),
                    child: Text(_user.email,style: const TextStyle(color: Colors.grey,fontSize: 18,overflow: TextOverflow.ellipsis),textAlign: TextAlign.right,),
                  ): Container(),
                  // Text(_user.email,style: const TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ) : Container(),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ?
        TextButton(
          onPressed: () async{
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child:  Image.asset( ImageIcons.sex,width: 30,color: Colors.grey, ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: const Text('性别',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),


                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_user.sex == 0 ? '男性':'女性',style: const TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ) : Container(),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ?
        TextButton(
          onPressed: () async{
            JhPickerTool.showDatePicker(context, dateType: DateType.YMD, value: DateTime.fromMillisecondsSinceEpoch(_user.birthday), clickCallBack: (t,p) {
              if(_user.birthday == p) return;
              setState(() {
                _user.birthday = p;
              });
              Global.changeUserProfile(_user);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child:  Image.asset(ImageIcons.age, width: 30,color: Colors.grey, ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: const Text('年龄',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),


                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(Global.getYearsOld(_user.birthday),style: const TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ) : Container(),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ?
        TextButton(
          onPressed: () {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(SystemTtf.guanbi, color: Colors.grey, size: 30,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: const Text('更换密码',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ) : Container(),
        (_user.phone != null || _user.phone != '') && (_user.email != null || _user.email != '') ? Container() :
        TextButton(
          onPressed: () {
            Navigator.push(Global.MainContext, SlideRightRoute(page: const LoginPage())).then((value) => setState(() {Global.getUserInfo();}));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.phone_android_outlined,color: Colors.grey,size: 30,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: const Text('账号登录',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_getPhoneShort(),style: const TextStyle(color: Colors.redAccent,fontSize: 18),),
                  const Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                // fullscreenDialog: true,
                title: _user.phone == null || _user.phone==''?"绑定手机": '更换手机',
                builder: (context) => const BindPhonePage(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.phone_android_outlined,color: Colors.grey,size: 30,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: Text(_user.phone == null || _user.phone==''?"绑定手机": '更换手机',style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),


                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_getPhoneShort(),style: const TextStyle(color: Colors.redAccent,fontSize: 18),),
                  const Icon(Icons.chevron_right,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.fact_check,
            size: 25,
          ),
          title: const Text('保存身份ID，账号防丢失',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
          // The Material switch has a platform adaptive constructor.
          onTap: () {
            Navigator.push(context, DialogRouter(QRCodeDialog(_user.uid)));
          },
        ),
      ],
    );
  }
}
