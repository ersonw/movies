import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/CountryCodePage.dart';
import 'package:movies/HttpManager.dart';
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
  final TextEditingController _controllerCode = TextEditingController();
  late Timer _timer;

  static const int newPhoneInput = 100;
  static const int changePhoneInput = 101;
  static const int verifyCodeAndSetPassword = 102;
  static const int verifyPasswordLogin = 103;

  int type = 0;
  int validTime = 120;
  String countryCode = '+86';
  String phone = '';
  String countDownText = '重新发送';

  bool next = false;
  User _user = User();
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
  void _checkPhone(String phone) async{
    String? result = (await DioManager().requestAsync(
        NWMethod.POST,
        NWApi.checkPhone,
        {"data": countryCode+phone}
    ));
    print(result);
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['ready'] == true){
        setState(() {
          type = verifyPasswordLogin;
        });
      }else{
        setState(() {
          type = verifyCodeAndSetPassword;
        });
      }
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
  void _sendSms(){
    _countDown();
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
                      controller: _controllerPhone,
                      // autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {},
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
                  phone = _controllerPhone.text;
                  _controllerPhone.text = "";
                  _checkPhone(phone);
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
                      controller: _controllerCode,
                      // autofocus: true,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {},
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
                      controller: _controllerPhone,
                      // autofocus: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      // onSubmitted: (value) => {
                      //   setState(() => {_inputString = value})
                      // },
                      onEditingComplete: () {
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
                          hintText: "设置密码"),
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
                onPressed: () {  },
                child: const Text("收不到验证码？",style: TextStyle(color: Colors.grey),),
              ),
            )
          ],
        ),
        SizedBox(
          child: TextButton(
              onPressed: () {
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
      case verifyCodeAndSetPassword:
        page = _verifyCodeAndSetPassword;
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