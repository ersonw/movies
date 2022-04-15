import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/global.dart';
import 'package:movies/image_icon.dart';
import 'dart:io';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

ShowCopyDialog(BuildContext context, String title, String? text) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text("内容：${text}",textAlign: TextAlign.left,),
          actions: [
            CupertinoDialogAction(
                child: Text("复制"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                  Navigator.of(_context).pop();
                }),
            CupertinoDialogAction(
                child: Text("关闭"),
                onPressed: () {
                  Navigator.of(_context).pop();
                })
          ],
        );
      });
}
_buildUpdate(BuildContext context, String url, {bool force = false}){
  if(!force){
    return <Widget>[
      CupertinoDialogAction(
          child: const Text("马上更新"),
          onPressed: ()async {
            Navigator.of(context).pop();
            if(await canLaunch(url)) launch(url);
          }) ,
      CupertinoDialogAction(
          child: const Text("我知道了"),
          onPressed: ()async {
            Navigator.of(context).pop();
          }),
    ];
  }
  return <Widget>[
    CupertinoDialogAction(
        child: const Text("马上更新"),
        onPressed: ()async {
          Navigator.of(context).pop();
          if(await canLaunch(url)) launch(url);
        }) ,
  ];
}
ShowOptionDialog(BuildContext context, String title, String? text,String? url, bool force) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(text!,textAlign: TextAlign.left,),
          actions: _buildUpdate(_context,url!,force: force),
        );
      });
}

ShowAlertDialog(BuildContext context, String? title, String? text) async{
  return await showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title!),
          content: Text(text!,textAlign: TextAlign.left,),
          actions: [
            CupertinoDialogAction(
                child: Text("好的"),
                onPressed: () {
                  Navigator.of(_context).pop();
                })
          ],
        );
      });
}
Future<bool> ShowAlertDialogBool(BuildContext context, String? title, String? text) async{
  bool _sure = false;
  await showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title!),
          content: Text(text!,textAlign: TextAlign.left,),
          actions: [
            CupertinoDialogAction(
                child: const Text("取消"),
                onPressed: () {
                  Navigator.of(_context).pop();
                }),
            CupertinoDialogAction(
                child: const Text("确定"),
                onPressed: () {
                  _sure = true;
                  Navigator.of(_context).pop();
                }),

          ],
        );
      });
  return _sure;
}
Future<bool> ShowPictureFullSceen(BuildContext context, String? title, String? text) async{
  bool _sure = false;
  await showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title!),
          content: Text(text!),
          actions: [
            CupertinoDialogAction(
                child: const Text("取消"),
                onPressed: () {
                  Navigator.of(_context).pop();
                }),
            CupertinoDialogAction(
                child: const Text("继续"),
                onPressed: () {
                  _sure = true;
                  Navigator.of(_context).pop();
                }),

          ],
        );
      });
  return _sure;
}

Future<String> ShowInputDialogAsync(BuildContext context, {String? title, String? text, String? hintText})async {
  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = text ?? '';
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          // title: Text(title ?? '温馨提示'),
          content: Card(
            // color: Colors.white,
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                // text == null ? Container():Text(text),
                TextField(
                  controller: textEditingController,
                  // style: TextStyle(color: Colors.white38),
                  decoration: InputDecoration(
                      hintText: hintText ?? '请输入内容',
                      filled: true,
                      fillColor: Colors.transparent),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        );
      });
  String t = textEditingController.text;
  textEditingController.clear();
  return t;
}
class BottomMenu {
  BottomMenu();
  String title = '';
  Function? fn;
}
Future<void> ShowBottomMenu(BuildContext context,List<BottomMenu> lists, {String? title, String? text}) async{

  showCupertinoModalPopup<void>(
    context: context,
    builder: (_context) {
      return CupertinoActionSheet(
        title: title ==null ? null : Text(title),
        message: text ==null ? null : Text(text),
        actions: lists.map((e) {
          return CupertinoActionSheetAction(
            child: Text(
              e.title, style: TextStyle(color: Colors.black),),
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(_context);
              e.fn!();
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('取消'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(_context),
        ),
      );
    },
  );
}
_widgetIconImage(String image){
  if(image == null || image.isEmpty){
    return Image.asset(ImageIcons.yue,width: 45,height: 45,errorBuilder: (context, url, StackTrace? error) {
      // print(error!);
      return const Text('！');
    },);

  }else{
    if(image.startsWith('http')){
      return Image.network(image,width: 45,height: 45,errorBuilder: (context, url, StackTrace? error) {
        // print(error!);
        return const Text('！');
      },);
    }
    return Image.file(File(image),width: 45,height: 45,errorBuilder: (context, url, StackTrace? error) {
      // print(error!);
      return const Text('！');
    },);
  }
}
_getOrder(int type, int cid, int id, int amount) async{
  Map<String, dynamic> parm = {
    'id': id,
    'cid': cid,
    'type': type,
    'amount': amount,
  };
  String? result = (await DioManager().requestAsync(
      NWMethod.GET,
      NWApi.getOrder,
      {"data": jsonEncode(parm)}
  ));
  if(result != null){
    print(result);
    Map<String, dynamic> map = jsonDecode(result);
    if(map['verify'] == true){
      Global.showWebColoredToast('修改成功!');
    }
  }
}
Future<void> ShowOnlinePaySelect(BuildContext context,int type,int id,int amount,{String? title, String? text}) async{

   showCupertinoModalPopup<void>(
    context: context,
    builder: (_context) {
      return CupertinoActionSheet(
        title: Text(title ?? '选择支付方式',style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
        message: text ==null ? null : Text(text),
        actions: configModel.onlinePays.map((e) {
          return CupertinoActionSheetAction(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 60),
                  // color: Colors.transparent,
                  child: _widgetIconImage(e.iconImage),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10,top: 10),
                  child: Text(e.title, style: const TextStyle(color: Colors.black),),
                )
              ],
            ),
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(_context);
              _getOrder(type,id,e.id,amount);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('取消'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(_context),
        ),
      );
    },
  );
}


