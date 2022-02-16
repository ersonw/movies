import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/User.dart';
import 'package:movies/global.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPage createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  User _user = User();
  final TextEditingController _controllerSoure = TextEditingController();
  final TextEditingController _controllerNew = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = userModel.user;
    userModel.addListener(() => _user = userModel.user);
  }

  @override
  Widget build(BuildContext context) {
    // bool obscureText = true;
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: Column(
          children: [
            SizedBox(
              // height: 70,
              child: Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 40, left: 40, right: 40),
                  decoration: const BoxDecoration(
                      color: Color(0xfff6f8fb),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: TextField(
                    obscureText: true,
                    controller: _controllerSoure,
                    // autofocus: true,
                    keyboardType: TextInputType.visiblePassword,
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
                        hintText: "输入原密码(没有请留空)"),
                  ),
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       obscureText = !obscureText;
            //     });
            //   },
            //   child: Icon(obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,size: 20,color: obscureText ? Colors.black : Colors.grey,),
            // ),
            SizedBox(
              // height: 70,
              child: Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                  decoration: const BoxDecoration(
                      color: Color(0xfff6f8fb),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: TextField(
                    obscureText: true,
                    controller: _controllerNew,
                    // autofocus: true,
                    keyboardType: TextInputType.visiblePassword,
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
                        hintText: "设置密码(必须大于或者等于6位数)"),
                  ),
                )
              ),
            ),
            SizedBox(
              child: TextButton(
                  onPressed: () {
                    if(_controllerNew.text == ''){
                      Global.showWebColoredToast('新密码不能为空密码!');
                      return;
                    }
                    if(_controllerSoure.text == _controllerNew.text){
                      Global.showWebColoredToast('新密码与旧密码相同!');
                      return;
                    }
                    if(_controllerNew.text.length < 5){
                      Global.showWebColoredToast('新密码必须大于或者等于6位数');
                      return;
                    }
                    Global.changePassword(_controllerSoure.text, _controllerNew.text);
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xfff6f8fb),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: const Text('提交',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                  )),
            )
          ],
        ));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerNew.clear();
    _controllerSoure.clear();
  }
}
