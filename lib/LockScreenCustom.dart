import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movies/ProfileChangeNotifier.dart';
import 'package:movies/functions.dart';
import 'package:movies/model/ConfigModel.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

import 'global.dart';

class LockScreenCustom extends StatefulWidget {
  static const int lock = 100;
  static const int setPasswd = 101;
  static const int changePasswd = 102;
  static const int restPasswd = 103;
  int type;
  LockScreenCustom(this.type,{Key? key}) : super(key: key);

  @override
  _LockScreenCustom createState() => _LockScreenCustom();

}
class _LockScreenCustom extends State<LockScreenCustom>{
  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();
  final ConfigModel _configModel = ConfigModel();
  String storedPasscode = '';
  String title = '';
  String backText = '';
  bool _isAuthenticated = false;
  int errorIndex = 3;
  late BuildContext _context;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storedPasscode = _configModel.config.bootLockPasswd ?? '';
    _configModel.addListener(() {
      setState(() {
        storedPasscode = _configModel.config.bootLockPasswd!;
      });
    });
    switch(widget.type){
      case LockScreenCustom.lock:
        title = '请输入锁屏密码';
        backText = '退出APP';
        break;
      case LockScreenCustom.changePasswd:
        title = '请输入原密码';
        backText = '取消';
        break;
      case LockScreenCustom.restPasswd:
        break;
      case LockScreenCustom.setPasswd:
        title = '请设置6位数锁屏密码';
        backText = '取消设置';
        storedPasscode = '';
        break;
      default:
        break;
    }
    _showIt();
  }
  _showIt({Function? fn}) {
    Timer(const Duration(milliseconds: 50), (){
      _showLockScreen(
        context,
        opaque: false,
        cancelButton: Text(
          backText,
          style: const TextStyle(fontSize: 16, color: Colors.white),
          semanticsLabel: 'Cancel',
        ),
      );
      if(fn != null) fn();
    });
  }
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }


  _showLockScreen(BuildContext context, {required bool opaque, CircleUIConfig? circleUIConfig, KeyboardUIConfig? keyboardUIConfig, required Widget cancelButton, List<String>? digits,}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
                title:  Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 28),
                ),
                circleUIConfig: circleUIConfig,
                keyboardUIConfig: keyboardUIConfig,
                passwordEnteredCallback: _onPasscodeEntered,
                cancelButton: cancelButton,
                deleteButton: const Text(
                  '删除',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  semanticsLabel: 'Delete',
                ),
                shouldTriggerVerification: _verificationNotifier.stream,
                backgroundColor: Colors.black.withOpacity(0.8),
                cancelCallback: _onPasscodeCancelled,
                digits: digits,
                passwordDigits: 6,
                bottomWidget: widget.type == LockScreenCustom.lock ? _buildPasscodeRestoreButton() : null,
              ),
        ));
  }
  _changePasswd(String enteredPasscode){
    if(_isAuthenticated){
      _setPasswd(enteredPasscode);
    } else {
      bool _isValid = storedPasscode == enteredPasscode;
      _verificationNotifier.add(_isValid);
      if(_isValid){
        setState(() {
          _isAuthenticated = true;
          storedPasscode = '';
          title = '请设置6位数锁屏密码';
          _showIt();
        });
      }else{
        ShowAlertDialog(_context, '修改锁屏密码', '原密码验证错误！');
      }
    }
  }
  _setPasswd(String enteredPasscode) {

    if(storedPasscode.isEmpty){
      _verificationNotifier.add(true);
      storedPasscode = enteredPasscode;
      title = '再次确认密码';
      setState(() => {_showIt()});
    }else{
      if(storedPasscode == enteredPasscode){
        _configModel.lockPasswd = storedPasscode;
        _callBack();
      }else{
        _verificationNotifier.add(true);
        title = '请设置6位数锁屏密码';
        storedPasscode = '';
        _showIt(fn: (){
          ShowAlertDialog(_context, '设置锁屏密码', '两次锁屏密码不一致！');
        });
      }
    }
  }
  _onPasscodeEntered(String enteredPasscode)async {
    enteredPasscode = Global.generateMd5(enteredPasscode);

    switch(widget.type){
      case LockScreenCustom.lock:
        bool isValid = storedPasscode == enteredPasscode;
        _verificationNotifier.add(isValid);
        if(isValid){
          _callBack();
        }else{
          setState(() {
            --errorIndex;
          });
          if(errorIndex == 0){
            await ShowAlertDialog(context, '锁屏密码', '您没有尝试机会了，下次再见！');
            exit(0);
          }else{
            ShowAlertDialog(context, '锁屏密码', '您还有$errorIndex次机会，请谨慎操作！');
          }
        }
        break;
      case LockScreenCustom.changePasswd:
        _changePasswd(enteredPasscode);
        break;
      case LockScreenCustom.restPasswd:
        break;
      case LockScreenCustom.setPasswd:
        return _setPasswd(enteredPasscode);
      default:
        break;
    }

  }
  _callBack(){
    _verificationNotifier.close();
    int i =0;
    Navigator.of(_context).popUntil((route) {
      // print(route);
      // if(route.isCurrent) return false;
      // return true;
      if(i<2){
        i++;
        return false;
      }
      return true;
    });
  }
  _onPasscodeCancelled() {
    switch(widget.type) {
      case LockScreenCustom.lock:
        return exit(0);
      default:
        _callBack();
        break;
    }

  }
  _buildPasscodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: TextButton(
        child: const Text(
          "重置密码",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300),
        ),
        onPressed: _resetAppPassword,
        // splashColor: Colors.white.withOpacity(0.4),
        // highlightColor: Colors.white.withOpacity(0.2),
        // ),
      ),
    ),
  );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}