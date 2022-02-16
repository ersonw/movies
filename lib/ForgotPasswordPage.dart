import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CountryCodePage.dart';
import 'HttpManager.dart';
import 'KeFuMessagePage.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();

}
class _ForgotPasswordPage extends State<ForgotPasswordPage>{
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordSure = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  Timer _timer = Timer(const Duration(milliseconds: 10),() => {});
  int validTime = 120;

  String countDownText = '重新发送';
  String codeId = '';
  String countryCode = '+86';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  void _checkPhone() async{
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.checkPhone,
        {"data": countryCode+_controllerPhone.text}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['ready'] == false){
        Global.showWebColoredToast('手机号未注册，请先注册账号!');
      }
    }else{
      _controllerPhone.text = '';
    }
  }
  void _callBack(){
    Navigator.pop(context);
  }
  void _findBack()async{
    _commentFocus.unfocus();
    if(_controllerPhone.text.isEmpty){
      Global.showWebColoredToast('手机号必填!');
      return;
    }
    if(_controllerCode.text.isEmpty){
      Global.showWebColoredToast('验证码必填!');
      return;
    }
    if(codeId.isEmpty){
      Global.showWebColoredToast('未获取短信验证码或者验证码已过期，请重新获取!');
      return;
    }
    if(_controllerPasswordSure.text != _controllerPassword.text){
      Global.showWebColoredToast('两次密码不相同!');
      return;
    }
    if(_controllerPasswordSure.text.length < 5){
      Global.showWebColoredToast('密码必须大于或者等于6位数!');
      return;
    }
    Map<String, dynamic> parm = {
      'id': codeId,
      'code': _controllerCode.text,
      'phone': countryCode+_controllerPhone.text,
      'passwd': Global.generateMd5(_controllerPasswordSure.text),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET,
        NWApi.forgotPasswd,
        {"data": jsonEncode(parm)}
    ));
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['verify'] == true){
        Global.showWebColoredToast('修改成功!');
        Global.getUserInfo().then((value) => _callBack());
      }
    }else{
      _controllerCode.text = '';
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            // height: 70,
            child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40,right: 40,top: 20),
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
                        // focusNode: _commentFocus,
                        controller: _controllerPhone,
                        // autofocus: true,
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
            // height: 70,
            child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40,right: 40,top: 20),
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
                        controller: _controllerCode,
                        // autofocus: true,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          _commentFocus.unfocus();
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
                margin: const EdgeInsets.only(left: 40,right: 40,top: 20),
                decoration: const BoxDecoration(
                    color: Color(0xfff6f8fb),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: true,
                        // focusNode: _commentFocus,
                        controller: _controllerPassword,
                        // autofocus: openBus,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          if(_controllerPassword.text.length < 5){
                            Global.showWebColoredToast('密码必须大于或者等于6位数!');
                            return;
                          }
                          _commentFocus.nextFocus();
                          // _bindPhone();
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
          SizedBox(
            // height: 70,
            child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40,right: 40,top: 20,bottom: 20),
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
                        controller: _controllerPasswordSure,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          _findBack();
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
                            hintText: "确认密码(必须大于或者等于6位数)"),
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
                  _findBack();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                  decoration: const BoxDecoration(
                      color: Color(0xfff6f8fb),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: const Text('立即找回',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                )),
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerPasswordSure.clear();
    _controllerPassword.clear();
    _controllerPhone.clear();
    _controllerCode.clear();
    _timer.cancel();
  }
}