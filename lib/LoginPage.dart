import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ImageIcons.dart';
import 'global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();

}
class _LoginPage extends State<LoginPage>{
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  bool eyes = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top:10,bottom: 20),
                    child: const Text('登录', style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    height: 45,
                    // width: ((MediaQuery.of(context).size.width) / 1.2),
                    margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                    decoration: const BoxDecoration(
                      border:
                      Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                    ),
                    child: Expanded(
                      flex: 2,
                      child: TextField(
                        controller: usernameEditingController,
                        // style: TextStyle(color: Colors.white38),
                        onEditingComplete: () {
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: '请输入账号',
                          hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
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
                            flex: 2,
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
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    usernameEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }
}