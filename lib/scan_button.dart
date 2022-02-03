import 'package:flutter/cupertino.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
  Widget _build(BuildContext context) {
    return CupertinoButton(
      color: CupertinoColors.destructiveRed,
      child: const Text('Log out'),
      onPressed: () {
        // You should do something with the result of the action sheet prompt
        // in a real app but this is just a demo.
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: const Text('扫一扫'),
              message: Text('请选择'),
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('相机'),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoActionSheetAction(
                  child: const Text('相册'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('取消'),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            );
          },
        );
      },
    );
  }
}