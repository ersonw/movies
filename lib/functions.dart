import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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

ShowAlertDialog(BuildContext context, String? title, String? text) {
  return showCupertinoDialog<void>(
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





