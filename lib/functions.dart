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

ShowCopyDialog(BuildContext context, String title, String? text) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text("内容：${text}"),
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
ShowOptionDialog(BuildContext context, String title, String? text,String? url, bool force) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(text!),
          actions: [
            CupertinoDialogAction(
                child: Text(force ? "马上更新":"好的"),
                onPressed: () {
                  Navigator.of(_context).pop();
                  if(force){
                    launch(url!);
                    exit(0);
                  }
                }),
          ],
        );
      });
}

ShowAlertDialog(BuildContext context, String? title, String? text) async{
  return await showCupertinoDialog<void>(
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title!),
          content: Text(text!),
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
          content: Text(text!),
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
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title ?? '温馨提示'),
          content: Card(
            // color: Colors.white,
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                text == null ? Container():Text(text),
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
  if(image.isNotEmpty){
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
  }else{
    return Image.asset(ImageIcons.yue.keyName,width: 45,height: 45,errorBuilder: (context, url, StackTrace? error) {
      // print(error!);
      return const Text('！');
    },);
  }
}
Future<void> ShowOnlinePaySelect(BuildContext context,int type,int amount,{String? title, String? text}) async{
  // configModel.onlinePays = [];
  // if(configModel.onlinePays.length == 0){
  //   OnlinePay onlinePay = OnlinePay();
  //   onlinePay.id = 0;
  //   onlinePay.title = '余额支付';
  //   // onlinePay.iconImage = 'https://www.freeiconspng.com/uploads/wechat-icon-9.jpg';
  //   List<OnlinePay> list = [];
  //   list.add(onlinePay);
  //   onlinePay = OnlinePay();
  //   onlinePay.title = '微信支付';
  //   onlinePay.iconImage = 'https://www.freeiconspng.com/uploads/wechat-icon-9.jpg';
  //   list.add(onlinePay);
  //   onlinePay = OnlinePay();
  //   onlinePay.title = '支付宝支付';
  //   onlinePay.iconImage = 'https://cdn4.iconfinder.com/data/icons/logos-and-brands/512/13_Alipay_logo_logos-1024.png';
  //   list.add(onlinePay);
  //
  //   configModel.onlinePays = list;
  // }
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
                  margin: EdgeInsets.only(left: 60),
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


