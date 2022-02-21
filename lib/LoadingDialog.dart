import 'package:flutter/material.dart';
import 'package:movies/global.dart';

class LoadingDialog extends Dialog {

  LoadingDialog(this.canceledOnTouchOutside) : super();
  ///点击背景是否能够退出
  final bool canceledOnTouchOutside;
  // late BuildContext _context;
  @override
  StatelessElement createElement() {
    // TODO: implement createElement
    // loadingChangeNotifier.addListener(() {
    //   if(!loadingChangeNotifier.isLoading){
    //     Navigator.pop(_context);
    //   }
    // });
    return super.createElement();
  }
  @override
  Widget build(BuildContext context) {
    // _context = context;
    bool isDis = false;
    loadingChangeNotifier.addListener(() {
      if(!isDis && !loadingChangeNotifier.isLoading){
        Navigator.maybePop(context);
        isDis = true;
      }
    });
    return Center(
      child:  Material(
        ///背景透明
          color: Colors.transparent,
          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: (){
                  if(canceledOnTouchOutside){
                    Navigator.pop(context);
                  }
                },
              ),
              _dialog()
            ],
          )
      ),
    );
  }

  Widget _dialog(){
    return  Center(
      ///弹框大小
      child:  SizedBox(
        width: 120.0,
        height: 120.0,
        child:  Container(
          ///弹框背景和圆角
          decoration: const ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
               CircularProgressIndicator(),
               Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
                child:  Text(
                  "加载中",
                  style:  TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
