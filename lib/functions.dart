import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Functions {
  double vw(double widthPer) {
    return widthPer * 1;
  }
}
 ShowCopyDialog(BuildContext context, String title, String? text) {
  return showCupertinoDialog<void> (
      context: context,
      builder: (_context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text("内容：${text}"),
          actions: [
            CupertinoDialogAction(
                child: Text("复制"),
                onPressed: ()
                {
                  Clipboard.setData(ClipboardData(text: text));
                  Navigator.of(_context).pop();
                }
            ),
            CupertinoDialogAction(
                child: Text("关闭"),
                onPressed: (){
                  Navigator.of(_context).pop();
                }
            )
          ],
        );
      }
  );
}