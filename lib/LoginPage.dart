import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CountryCodePage.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'data/User.dart';
import 'functions.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();

}
class _LoginPage extends State<LoginPage>{
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  bool eyes = false;
  bool _isNumber = false;
  String countryCode = '+86';
  String codeId = '';
  String codeText = '';

  @override
  void initState() {
    super.initState();
    usernameEditingController.addListener(() {
      if(usernameEditingController.text.isNotEmpty && int.tryParse(usernameEditingController.text) != null){
        setState(() {
          _isNumber = true;
        });
      }else{
        setState(() {
          _isNumber = false;
        });
      }
    });
  }
  _login() async{
    if(usernameEditingController.text.isEmpty || passwordEditingController.text.isEmpty){
      Global.showWebColoredToast('账号或者密码不允许为空');
      return;
    }
    if(_isNumber){
      _checkPhone(callback: (v){
        if(v == true){
          _loginPhone();
        }else{
          Global.showWebColoredToast('手机号未注册!');
        }
      });
    }else{
      _loginEmail();
    }
  }
  _loginEmail()async{
    String uid = await Global.getUUID();
    Map<String, dynamic> parm = {
      'identifier': uid,
      'email': usernameEditingController.text,
      'passwd': Global.generateMd5(passwordEditingController.text),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.login, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null) {
        if(map['verify'] == true) {
          User user = userModel.user;
          user.token = map['token'];
          userModel.user = user;
          _callBack();
          Global.getUserInfo();
        }
        if(map['msg'] != null) {
          Global.showWebColoredToast(map['msg']);
        }
      }
    }
  }
  void _checkPhone({Function? callback}) async{
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.checkPhone,
        {"data": countryCode+usernameEditingController.text}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      callback!(map['ready']);
    }
  }
  void _sendSms() async{
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.sendSms,
        {"data": countryCode+usernameEditingController.text}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      codeId = map['id'];
      // print(codeId);
    }
  }
  void _callBack(){
    Navigator.pop(context);
  }
  Future<bool> _bindPhone() async{
    // print(codeId);
    Map<String, dynamic> parm = {
      'id': codeId,
      'identifier': Global.uid,
      'code': codeText,
      'passwd': Global.generateMd5(passwordEditingController.text),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.register,
        {"data": jsonEncode(parm)}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['verify'] == true){
        await Global.reportOpen(Global.REPORT_BIND_PHONE);
        Global.showWebColoredToast('绑定成功!');
        Global.getUserInfo();
        return true;
      }
    }
    return false;
  }
  void _loginPhone() async{
    Map<String, dynamic> parm = {
      'identifier': Global.uid,
      'phone': countryCode+usernameEditingController.text,
      'passwd': Global.generateMd5(passwordEditingController.text),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.loginPhone,
        {"data": jsonEncode(parm)}
    ));
    // print(result);
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['verify'] == true){
        await Global.reportOpen(Global.REPORT_PHONE_LOGIN);
        Global.showWebColoredToast('登录成功!');
        _callBack();
      }
    }
  }
  _showCodeDialog({bool verify = false}){
    Global.showVerifyCodeDialog('$countryCode${usernameEditingController.text}',verify: verify, callback: (String code) async{
      if(code.isEmpty){
        _sendSms();
        return true;
      }else if(code == '1'){
        _showCodeDialog(verify: true);
        return true;
      }else{
        codeText = code;
        if(await _bindPhone()){
          _callBack();
          return true;
        }
      }
      return false;
    });
  }
  _register() async{
    if(usernameEditingController.text.isEmpty || passwordEditingController.text.isEmpty){
      Global.showWebColoredToast('账号或者密码不允许为空');
      return;
    }
    if(_isNumber){
      _checkPhone(callback: (v)async{
        print(v);
        if(v){
          // Global.showWebColoredToast('手机号已被注册!');
          if(await ShowAlertDialogBool(context,'注册','手机号已被注册!是否直接登录？')){
            _loginPhone();
          }
        }else{
          _showCodeDialog();
        }
      });
    }else{
      Global.showWebColoredToast('请输入正确的手机号注册');
    }
    return;
    String uid = await Global.getUUID();
    Map<String, dynamic> parm = {
      'identifier': uid,
      'email': usernameEditingController.text,
      'passwd': Global.generateMd5(passwordEditingController.text),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.registerEmail, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null) {
        if(map['verify'] == true) {
          User user = userModel.user;
          user.token = map['token'];
          userModel.user = user;
          Navigator.pop(context);
          Global.getUserInfo();
        }
        if(map['msg'] != null) {
          Global.showWebColoredToast(map['msg']);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                height: 250,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageIcons.bgLogin1),
                      fit: BoxFit.fill,
                    )
                ),
              ),
              SizedBox(
                height: 70,
                width: 70,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    // height: 30,
                    // width: 30,
                    margin: const EdgeInsets.only(left: 20,top:20),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageIcons.iconLoginBack),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: ((MediaQuery.of(context).size.width) / 1),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white, // 底色
              boxShadow: [
                BoxShadow(
                  blurRadius: 10, //阴影范围
                  spreadRadius: 0.1, //阴影浓度
                  color: Colors.grey.withOpacity(0.2), //阴影颜色
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top:10,bottom: 20),
                      child: const Text('登录', style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      height: 45,
                      // width: ((MediaQuery.of(context).size.width) / 1.6),
                      margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                      decoration: const BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                      ),
                      child: Row(
                        children: [
                          _isNumber ? TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push<void>(
                                CupertinoPageRoute(
                                  title: '国家代码选择',
                                  builder: (context) => CountryCodePage(callback: (String code) {
                                    setState(() {
                                      countryCode = code;
                                    });
                                  },),
                                ),
                              );
                            },
                            child: Text(countryCode,style: const TextStyle(color: Colors.black),),
                          ) : Container(),
                          Expanded(
                            child: TextField(
                              controller: usernameEditingController,
                              // style: TextStyle(color: Colors.white38),
                              onEditingComplete: () {
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: '请输入手机号码(+8613800138000)',
                                hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    Container(
                      height: 45,
                      // width: ((MediaQuery.of(context).size.width) / 1.6),
                      margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                      decoration: const BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: passwordEditingController,
                              // style: TextStyle(color: Colors.white38),
                              onEditingComplete: () {
                              },
                              obscureText: !eyes,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: const InputDecoration(
                                hintText: '请输入密码',
                                hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                eyes = !eyes;
                              });
                            },
                            child: Icon(eyes ? Icons.remove_red_eye : Icons.visibility_off_outlined,size: 30,color: Colors.grey,),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 45,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30))),
                            ),
                            onPressed: () {
                              _register();
                            },
                            child: const Text(
                              '注册',
                              style: TextStyle(color: Colors.white,fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 45,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30))),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: const Text(
                              '登录',
                              style: TextStyle(color: Colors.white,fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // usernameEditingController.dispose();
    // passwordEditingController.dispose();
    super.dispose();
  }
}