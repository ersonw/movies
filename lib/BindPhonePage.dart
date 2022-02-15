import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/CountryCodePage.dart';

class BindPhonePage extends StatefulWidget {
  static const int bind = 100;
  static const int change = 101;
  int type;
  BindPhonePage(this.type,{Key? key}) : super(key: key);

  @override
  _BindPhonePage createState() => _BindPhonePage();

}
class _BindPhonePage extends State<BindPhonePage> {
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  bool next = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: Column(
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
                              builder: (context) => CountryCodePage(),
                            ),
                          );
                        },
                        child: Text("+86"),
                      ),
                      Expanded(
                          child: TextField(
                            obscureText: true,
                            controller: next ? _controllerCode : _controllerPhone,
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
                                hintText: "请输入手机号"),
                          ),
                      ),
                    ],
                  )
              ),
            ),

            SizedBox(
              child: TextButton(
                  onPressed: () {
                    // if(_controllerNew.text == ''){
                    //   Global.showWebColoredToast('新密码不能为空密码!');
                    //   return;
                    // }
                    // if(_controllerSoure.text == _controllerNew.text){
                    //   Global.showWebColoredToast('新密码与旧密码相同!');
                    //   return;
                    // }
                    // Global.changePassword(_controllerSoure.text, _controllerNew.text);
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xfff6f8fb),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: Text(next ? '提交' : '下一步',style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
                  )),
            )
          ],
        ));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerCode.clear();
    _controllerPhone.clear();
  }
}