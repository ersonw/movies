import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
Future<String?> ShowInputDialogAsync(BuildContext context, {String? title, String? text, String? hintText})async {
  String? input = null;
  await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title ?? '温馨提示'),
          content: Card(
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                text == null ? Container():Text(text),
                TextField(
                  onSubmitted: (e) {
                    input = e;
                  },
                  decoration: InputDecoration(
                      hintText: hintText ?? '请输入内容',
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('确定'),
            ),
          ],
        );
      });
  return input;
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


