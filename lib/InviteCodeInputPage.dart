import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/global.dart';

import 'HttpManager.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class InviteCodeInputPage extends StatefulWidget {
  const InviteCodeInputPage({Key? key}) : super(key: key);

  @override
  _InviteCodeInputPage createState() => _InviteCodeInputPage();
}

class _InviteCodeInputPage extends State<InviteCodeInputPage> {
  final TextEditingController _controllerCode = TextEditingController();

  _checkInviteCode() async {
    if (_controllerCode.text.isEmpty) {
      return;
    }
    if (_controllerCode.text.length < 4) {
      Global.showWebColoredToast('礼包码格式不正确!');
      return;
    }
    Map<String, dynamic> parm = {'code': _controllerCode.text};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.checkInviteCode, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if (map['verify'] == true) {
        Global.showWebColoredToast('领取成功!');
        Global.getUserInfo().then((value) => _callBack());
      }
    } else {
      _controllerCode.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            // height: 70,
            child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
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
                        autofocus: true,
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
                            hintText: "请输入或者复制礼包码"),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      ),
                      onPressed: ()async {
                        ClipboardData data = (await Clipboard.getData(Clipboard.kTextPlain)) ?? const ClipboardData();
                        _controllerCode.text = data.text ?? '';
                        Global.showWebColoredToast('粘贴成功！');
                      },
                      child: const Text("粘贴",style: TextStyle(color: Colors.black),),
                    ),
                  ],
                )),
          ),
          SizedBox(
            child: TextButton(
                onPressed: () {
                  _checkInviteCode();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                      // color: Color(0xfff6f8fb),
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  alignment: Alignment.center,
                  child: const Text(
                    '领取礼包',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                )),
          )
        ],
      ),
    );
  }

  void _callBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerCode.clear();
  }
}
