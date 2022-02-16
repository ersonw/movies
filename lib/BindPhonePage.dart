import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/CountryCodePage.dart';
import 'package:movies/ForgotPasswordPage.dart';
import 'package:movies/HttpManager.dart';
import 'package:movies/KeFuMessagePage.dart';
import 'package:movies/data/User.dart';
import 'package:movies/global.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';

class BindPhonePage extends StatefulWidget {
  const BindPhonePage({Key? key}) : super(key: key);

  @override
  _BindPhonePage createState() => _BindPhonePage();

}
class _BindPhonePage extends State<BindPhonePage> {
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPhoneOld = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  Timer _timer = Timer(const Duration(milliseconds: 10),() => {});

  static const int newPhoneInput = 100;
  static const int changePhoneInput = 101;
  static const int verifyCodeAndSetPassword = 102;
  static const int verifyPasswordLogin = 103;
  User _user = User();
  int type = 0;
  int validTime = 120;
  String countryCode = '+86';
  String phone = '';

  String countDownText = '重新发送';
  String codeId = '';
  @override
  void initState() {
    super.initState();
    _user = userModel.user;
    if(_user.phone == null || _user.phone == ''){
      type = newPhoneInput;
    }else{
      type = changePhoneInput;
    }
  }
  void _callBack(){
    Navigator.pop(context);
  }
  void _checkPhone() async{
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.checkPhone,
        {"data": countryCode+_controllerPhone.text}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['ready'] == true){
        setState(() {
          type = verifyPasswordLogin;
        });
      }else{
        _sendSms();
        setState(() {
          type = verifyCodeAndSetPassword;
        });
      }
    }else{
      _controllerPhone.text = '';
    }
  }
  void _countDown(){
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) => {
          setState(() {
            if (validTime < 1) {
              countDownText = '重新发送';
              validTime = 120;
              _timer.cancel();
            } else {
              --validTime;
              countDownText = '${validTime}S';
            }
          })
        });
  }
  void _sendSms() async{
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.sendSms,
        {"data": countryCode+_controllerPhone.text}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      codeId = map['id'];
      _countDown();
    }
  }
  void _bindPhone() async{
    Map<String, dynamic> parm = {
      'id': codeId,
    'identifier': Global.uid,
    'code': _controllerCode.text,
    'passwd': Global.generateMd5(_controllerPassword.text),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.register,
        {"data": jsonEncode(parm)}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['verify'] == true){
        Global.showWebColoredToast('绑定成功!');
        Global.getUserInfo().then((value) => _callBack());
      }
    }
  }
  void _loginPhone() async{
    Map<String, dynamic> parm = {
      'identifier': Global.uid,
      'phone': countryCode+_controllerPhone.text,
      'passwd': Global.generateMd5(_controllerPassword.text),
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
        Global.showWebColoredToast('登录成功!');
        setState(() {
          // userModel.user = User();
          Global.getUserInfo().then((value) => _callBack());
        });
      }
    }
  }
  Widget _buildBindNewPhone(){

    return Column(
      children: [
        SizedBox(
          // height: 70,
          child: Container(
              height: 50,
              margin: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  TextButton(
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
                  ),
                  Expanded(
                    child: TextField(
                      // obscureText: true,
                      focusNode: _commentFocus,
                      controller: _controllerPhone,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
                        if(_controllerPhone.text.length > 6){
                          _checkPhone();
                          _commentFocus.unfocus();
                        }else{
                          Global.showWebColoredToast('手机号码格式不正确!');
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "请输入手机号"),
                    ),
                  ),
                ],
              )
          ),
        ),
        const Text('亲：点击国家代码可以切换的哟～',style: TextStyle(color: Colors.grey),),
        SizedBox(
          child: TextButton(
              onPressed: () {
                if(_controllerPhone.text.length > 6){
                  _checkPhone();
                  _commentFocus.unfocus();
                }else{
                  Global.showWebColoredToast('手机号码格式不正确!');
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                decoration: const BoxDecoration(
                    color: Color(0xfff6f8fb),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: const Text('下一步',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
              )),
        )
      ],
    );
  }
  Widget _verifyCodeAndSetPassword(){
    bool openBus = false;
    return Column(
      children: [
        SizedBox(
          // height: 70,
          child: Container(
              height: 50,
              margin: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // obscureText: true,
                      focusNode: _commentFocus,
                      controller: _controllerCode,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
                        _commentFocus.unfocus();
                        openBus = true;
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "请输入验证码"),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(countDownText == '重新发送' ? Colors.yellow : Colors.transparent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    ),
                    onPressed: () {
                      if(countDownText == '重新发送'){
                        _sendSms();
                      }
                    },
                    child: Text(countDownText,style: const TextStyle(color: Colors.black),),
                  ),
                ],
              )
          ),
        ),
        SizedBox(
          // height: 70,
          child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 40,right: 40),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      focusNode: _commentFocus,
                      controller: _controllerPassword,
                      autofocus: openBus,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
                        if(_controllerPassword.text.length < 5){
                          Global.showWebColoredToast('密码必须大于或者等于6位数!');
                          return;
                        }
                        _commentFocus.unfocus();
                        _bindPhone();
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "设置密码(必须大于或者等于6位数)"),
                    ),
                  ),
                ],
              )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 40),
              child: TextButton(
                onPressed: () {
                  _commentFocus.unfocus();
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      // fullscreenDialog: true,
                      title: '找回密码',
                      builder: (context) => const KeFuMessagePage(),
                    ),
                  );
                },
                child: const Text("收不到验证码？",style: TextStyle(color: Colors.grey),),
              ),
            )
          ],
        ),
        SizedBox(
          child: TextButton(
              onPressed: () {
                if(_controllerPassword.text.length < 5){
                  Global.showWebColoredToast('密码必须大于或者等于6位数!');
                  return;
                }
                _commentFocus.unfocus();
                _bindPhone();
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                decoration: const BoxDecoration(
                    color: Color(0xfff6f8fb),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: const Text('立即绑定',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
              )),
        )
      ],
    );
  }
  Widget _verifyPasswordLogin(){
    return Column(
      children: [
        SizedBox(
          // height: 70,
          child: Container(
              height: 50,
              margin: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      focusNode: _commentFocus,
                      controller: _controllerPassword,
                      autofocus: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
                        if(_controllerPassword.text.isNotEmpty){
                          _loginPhone();
                          _commentFocus.unfocus();
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "登录密码"),
                    ),
                  ),
                ],
              )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 40),
              child: TextButton(
                onPressed: () {
                  _commentFocus.unfocus();
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      // fullscreenDialog: true,
                      title: '找回密码',
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text("忘记密码？",style: TextStyle(color: Colors.grey),),
              ),
            )
          ],
        ),
        SizedBox(
          child: TextButton(
              onPressed: () {
                if(_controllerPassword.text.isNotEmpty){
                  _loginPhone();
                  _commentFocus.unfocus();
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                decoration: const BoxDecoration(
                    color: Color(0xfff6f8fb),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: const Text('立即登录',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
              )),
        )
      ],
    );
  }
  Widget _changePhoneInput(){
    return Column(
      children: [
        SizedBox(
          // height: 70,
          child: Container(
              height: 50,
              margin: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // obscureText: true,
                      // focusNode: _commentFocus,
                      controller: _controllerPhoneOld,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
                        _commentFocus.nextFocus();
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "请输入完整原手机号(包括+)"),
                    ),
                  ),
                ],
              )
          ),
        ),
        SizedBox(
          // height: 70,
          child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  TextButton(
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
                  ),
                  Expanded(
                    child: TextField(
                      // obscureText: true,
                      focusNode: _commentFocus,
                      controller: _controllerPhone,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
                        if(_controllerPhone.text.length > 6){
                          _checkPhone();
                          _commentFocus.unfocus();
                        }else{
                          Global.showWebColoredToast('手机号码格式不正确!');
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "请输入手机号"),
                    ),
                  ),
                ],
              )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Container(
              margin: const EdgeInsets.only(left: 40),
              child: const Text('亲：点击国家代码可以切换的哟～',style: TextStyle(color: Colors.grey),),
            )
          ],
        ),
        SizedBox(
          child: TextButton(
              onPressed: () {
                if(_controllerPhone.text.length > 6){
                  _checkPhone();
                  _commentFocus.unfocus();
                }else{
                  Global.showWebColoredToast('手机号码格式不正确!');
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                decoration: const BoxDecoration(
                    color: Color(0xfff6f8fb),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: const Text('下一步',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
              )),
        )
      ],
    );
  }
  Widget _build(Function? fn){
    if(fn != null){
      return fn();
    }
    return Container();
  }
  @override
  Widget build(BuildContext context) {
    Function? page;
    switch(type){
      case newPhoneInput:
        page = _buildBindNewPhone;
        break;
      case changePhoneInput:
        page = _changePhoneInput;
        break;
      case verifyCodeAndSetPassword:
        page = _verifyCodeAndSetPassword;
        break;
      case verifyPasswordLogin:
        page = _verifyPasswordLogin;
        break;
      default:
        break;
    }
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: _build(page),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _controllerCode.clear();
    _controllerPhone.clear();
  }
}