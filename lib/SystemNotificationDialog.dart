import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';

class SystemNotificationDialog extends Dialog {
  SystemMessage systemMessage;
  SystemNotificationDialog(this.systemMessage,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(

        ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _dialog(context),
            ],
          )),
    );
  }
  Widget _dialog(context){
    // systemMessage.str += systemMessage.str;
    // print(systemMessage.str);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: (MediaQuery.of(context).size.height) / 1.4, ),
        child: Container(
          // height: (MediaQuery.of(context).size.height) / 3,
            width: (MediaQuery.of(context).size.width) / 1,
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration:  const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Center(child: Text(systemMessage.title,style: const TextStyle(color:  Colors.black,fontSize: 20,fontWeight: FontWeight.normal)),),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  height: 1, width: (MediaQuery.of(context).size.width) / 1,
                  color: Colors.black12,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: (MediaQuery.of(context).size.height) / 1.9, ),
                    child: Text(systemMessage.str.replaceAll('\\n','\n'),style: const TextStyle(color: Colors.black,fontSize: 17)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          // Colors.redAccent,
                          Color(0xFFFC8A7D),
                          Color(0xffff0010),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(width: 1.0, color: Colors.black12),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top:10,bottom: 10, left:30,right: 30),
                      child: const Text(
                        '我已了解',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            )
        ),
      )
    );
  }
}