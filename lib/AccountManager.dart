import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:movies/BindPhonePage.dart';
import 'package:movies/ChangePasswordPage.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/User.dart';
import 'package:movies/functions.dart';
import 'package:movies/image_icon.dart';
import 'package:movies/system_ttf.dart';
import 'package:movies/utils/JhPickerTool.dart';
import 'global.dart';

class AccountManager extends StatefulWidget {
  const AccountManager({Key? key}) : super(key: key);

  @override
  _AccountManager createState() => _AccountManager();
}

class _AccountManager extends State<AccountManager> {
  User _user = User();
  Config _config = Config();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = userModel.user;
    _config = configModel.config;
    userModel.addListener(() {
      setState(() {
        _user = userModel.user;
      });
    });
    configModel.addListener(() {
      setState(() {
        _config = configModel.config;
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
          _user.phone==null || _user.phone == '' ? Container() : SizedBox(
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
    if ((_user.avatar == null || _user.avatar == '') || _user.avatar?.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
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
                setState(() {
                  _user.avatar = image;
                });
                Global.changeUserProfile(_user);
              }else{
                // Global.showWebColoredToast("修改头像失败！");
              }
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
        ),
        TextButton(
          onPressed: () async{
            String input = await ShowInputDialogAsync(context, hintText: '输入需要修改的昵称');
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
                children: const [
                  Icon(Icons.assessment,size: 30,color: Colors.grey,),
                  Text('昵称',style: TextStyle(color: Colors.black,fontSize: 18),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_user.nickname,style: TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(SystemTtf.you,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ),
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
                children: const [
                  Image( width: 30,color: Colors.grey, image: ImageIcons.sex,),
                  Text('性别',style: TextStyle(color: Colors.black,fontSize: 18),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_user.sex == 0 ? '男性':'女性',style: TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(SystemTtf.you,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ),
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
                children: const [
                  Image( width: 30,color: Colors.grey, image: ImageIcons.age,),
                  Text('年龄',style: TextStyle(color: Colors.black,fontSize: 18),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(Global.getYearsOld(_user.birthday),style: const TextStyle(color: Colors.grey,fontSize: 18),),
                  const Icon(SystemTtf.you,size: 30,color: Colors.grey,),
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
                children: const [
                  Icon(
                    SystemTtf.guanbi,
                    color: Colors.grey,
                    size: 30,
                  ),
                  Text('更换密码',style: TextStyle(color: Colors.black,fontSize: 18),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(SystemTtf.you,size: 30,color: Colors.grey,),
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
                  const Icon(Icons.phone_android_outlined,color: Colors.grey,size: 30,),
                  Text(_user.phone == null || _user.phone==''?"绑定手机": '更换手机',style: const TextStyle(color: Colors.black,fontSize: 18),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_getPhoneShort(),style: const TextStyle(color: Colors.redAccent,fontSize: 18),),
                  const Icon(SystemTtf.you,size: 30,color: Colors.grey,),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
