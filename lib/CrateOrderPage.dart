import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/OrderRecordsPage.dart';
import 'package:movies/data/CrateOrder.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/functions.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class CrateOrderPage extends StatefulWidget {
  CrateOrderPage({Key? key, required this.type, required this.order_id})
      : super(key: key);
  int type;
  String order_id;

  @override
  _CrateOrderPage createState() => _CrateOrderPage();
}

class _CrateOrderPage extends State<CrateOrderPage> {
  OnlinePay _onlinePay = OnlinePay();
  CrateOrder _crateOrder = CrateOrder();
  int balance = 0;
  // late BuildContext context;
  @override
  void initState() {
    _onlinePay = configModel.onlinePays.first;
    _initOrder();
    super.initState();
  }
  _initBalance() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getBalance, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['balance'] != null){
        setState(() {
          balance = map['balance'];
        });
      }
    }
  }
  String _getAmount(){
    double dAmount = balance / 100;
    // int iLast = amount ~/ 100;
    // double dLast = dAmount - iLast;
    // if(dAmount < 1000){
      return dAmount.toStringAsFixed(2);
    // }else{
    //   dAmount = dAmount / 1000;
    //   if(dAmount < 1000){
    //     return '${dAmount.toStringAsFixed(3).replaceAll('.', ',')}${dLast.toStringAsFixed(2).substring(1)}';
    //   }else{
    //     double b = dAmount / 1000;
    //
    //   }
    // }
  }
  _initOrder({BuildContext? context}) async {
    Map<String, dynamic> parm = {
      'type': widget.type,
      'order_id': widget.order_id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] == 'error'){
        Global.showWebColoredToast(map['msg']);
        Navigator.pop(context!);
      }else{
        setState(() {
          _crateOrder = CrateOrder.formJson(jsonDecode(result));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // context = context;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push<void>(
                      CupertinoPageRoute(
                        title: '交易记录',
                        builder: (context) => const OrderRecordsPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "交易记录",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ]),
        ),
        child: Container(
          // width: ((MediaQuery.of(context).size.width) / 1.5),
          margin: const EdgeInsets.only(top: 40,left: 5,right: 5),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                ),
                // margin: const EdgeInsets.only(top: 40,left: 5,right: 5),
                child: Row(
                  children: [
                    const Text(
                      '交易名称：',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                    Text(
                      _crateOrder.title,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              _crateOrder.describes != null
                  ? Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1)),
                ),
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    const Text(
                      '交易说明：',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    ),
                    SizedBox(
                      width: ((MediaQuery.of(context).size.width) / 2),
                      child: Text(
                        _crateOrder.describes!,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black),
                      ),
                    ),

                  ],
                ),
              )
                  : Container(),
              Container(
                decoration: const BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                ),
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    const Text(
                      '交易金额：',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                    Text(
                      '${_crateOrder.currency ?? '￥'}${_crateOrder.amount / 100}',
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                ),
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    const Text(
                      '支付方式：',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                    TextButton(
                        onPressed: () {
                          _showOnlinePaySelect(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              // margin: const EdgeInsets.only(left: 60),
                              // color: Colors.transparent,
                              child: _widgetIconImage(_onlinePay.iconImage),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(_onlinePay.title,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // _onlinePay.title.contains('余额') ? Text('(￥${Global.getNumbersToChinese(balance)})',
                                  _onlinePay.type == 0 ? Text('(￥${_getAmount()})',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ) : Container(),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: const Text('温馨提示：轻点图标可以切换支付方式哦!',style: TextStyle(color: Colors.black45,fontSize:12)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: (MediaQuery.of(context).size.width) - 100,
                child: TextButton(
                  onPressed: () {
                    if(_onlinePay.type == 0){
                      if(balance < _crateOrder.amount){
                        Global.showWebColoredToast('余额不足!');
                        return;
                      }
                    }
                    _postCrateOrder(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                  ),
                  child: const Text(
                    '提交订单',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  _showOnlinePaySelect(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_context) {
        return CupertinoActionSheet(
          title: const Text(
            '选择支付方式',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      e.title,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              isDestructiveAction: true,
              onPressed: () async {
                if(e.type == 0){
                  _initBalance();
                }
                setState(() {
                  _onlinePay = e;
                });
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

  _widgetIconImage(String image) {
    if (image == null || image.isEmpty) {
      return Image.asset(
        ImageIcons.yue,
        width: 45,
        height: 45,
        errorBuilder: (context, url, StackTrace? error) {
          // print(error!);
          return const Text('！');
        },
      );
    } else {
      if (image.startsWith('http')) {
        return Image.network(
          image,
          width: 45,
          height: 45,
          errorBuilder: (context, url, StackTrace? error) {
            // print(error!);
            return const Text('！');
          },
        );
      }
      return Image.file(
        File(image),
        width: 45,
        height: 45,
        errorBuilder: (context, url, StackTrace? error) {
          // print(error!);
          return const Text('！');
        },
      );
    }
  }

  _postCrateOrder(BuildContext context) async {
    Map<String, dynamic> parm = {
      'order_id': widget.order_id,
      'type': widget.type,
      'pid': _onlinePay.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.postCrateOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] == 'ok'){
        if(map['url'] != null){
          Navigator.pop(context);
          launch(map['url']);
        }else{
          Navigator.pop(context);
          // Global.getUserInfo().then((value) => setState(() =>{}));
          // Navigator.of(context, rootNavigator: true).push<void>(
          //   CupertinoPageRoute(
          //     // title: '确认订单',
          //     builder: (context) => const OrderRecordsPage(),
          //   ),
          // ).then((value) => Navigator.pop(context));
        }
      }else{
        Global.showWebColoredToast(map['msg']);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
