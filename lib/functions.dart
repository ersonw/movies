import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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


Future<String?> GetUUID() async{
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build =  await deviceInfoPlugin.androidInfo;
      return build.androidId;
      //UUID for Android
    } else if (Platform.isIOS) {
      var build =  await deviceInfoPlugin.iosInfo;
      return build.identifierForVendor;
    }
  } on PlatformException {
    print('Failed to get platform version');
    return null;
  }

}


