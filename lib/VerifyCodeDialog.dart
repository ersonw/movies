import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verification_code_custom/verification_code_custom.dart';
import 'ImageIcons.dart';

class VerifyCodeDialog extends StatefulWidget {
  String phone;
  bool covered;
  clickCallbackCode? callback;
  bool verify;

  VerifyCodeDialog(this.phone, {Key? key, this.callback, this.covered = false,this.verify = false})
      : super(key: key);

  @override
  _VerifyCodeDialog createState() => _VerifyCodeDialog();
}

class _VerifyCodeDialog extends State<VerifyCodeDialog> {
  TextEditingController controller = TextEditingController();
  int validTime = 120;
  Timer _timer = Timer(const Duration(milliseconds: 10), () => {});
  bool disable = true;
  bool alive = true;
  String countDownText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  _init() async {
    if(widget.verify == false && widget.callback != null && await widget.callback!('')){
      _countDown();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(

          ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            // alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              _dialog(context),
            ],
          )),
    );
  }

  void _countDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if(alive) {
        setState(() {
          if (validTime < 1) {
            countDownText = '';
            validTime = 120;
            disable = false;
            _timer.cancel();
          } else {
            --validTime;
            countDownText = '${validTime}S';
          }
        });
      }
    });
  }

  Widget _dialog(context) {
    if (widget.covered) {
      widget.phone =
          '${widget.phone.substring(0, 6)}****${widget.phone.substring(10)}';
    }
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        height: 260,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ]),
            Container(
              alignment: Alignment.center,
              width: ((MediaQuery.of(context).size.width) / 1),
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(children: [
                const Text(
                  '短信验证码已发送至手机:',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                Text(
                  widget.phone,
                  style: const TextStyle(fontSize: 25, color: Colors.blue),
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: VerificationCodeCustom(
                controller: controller,
                itemCount: 6,
                textChanged: (list) async{
                  String result = list.join('');
                  // for (String str in list) {
                  //   result += str;
                  // }
                  result = result.replaceAll(' ', '');
                  if (result.length == 6 && int.tryParse(result) != null) {
                    if (disable == true && widget.callback != null && await widget.callback!(result)) {
                      Navigator.pop(context);
                    }else{
                      Navigator.pop(context);
                      // controller.text = '1';
                      if(widget.callback != null){
                        widget.callback!('1');
                      }
                    }
                  }
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async{
                        if (disable == true &&
                            widget.callback != null &&
                            await widget.callback!('')) {
                          _countDown();
                        }
                      },
                      child: Text('重新发送',
                          style: TextStyle(
                              color: disable ? Colors.grey : Colors.red,
                              fontSize: 18)),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(countDownText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    alive = false;
    super.dispose();
  }
}
