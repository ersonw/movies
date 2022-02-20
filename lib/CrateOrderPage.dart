import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/CrateOrder.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/functions.dart';
import 'dart:io';
import 'HttpManager.dart';
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

  @override
  void initState() {
    _onlinePay = configModel.onlinePays.first;
    _initOrder();
    super.initState();
  }

  _initOrder() async {
    Map<String, dynamic> parm = {
      'type': widget.type,
      'order_id': widget.order_id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      setState(() {
        _crateOrder = CrateOrder.formJson(jsonDecode(result));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "交易记录",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ]),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1)),
              ),
              margin: const EdgeInsets.all(40),
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
                    margin: const EdgeInsets.only(left: 40, right: 40, top: 10),
                    child: Row(
                      children: [
                        const Text(
                          '交易说明：',
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                        ),
                        Text(
                          _crateOrder.describes!,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
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
              margin: const EdgeInsets.all(40),
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
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 10, bottom: 10),
              child: Row(
                children: [
                  const Text(
                    '支付方式：',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  TextButton(
                      onPressed: () {
                        _ShowOnlinePaySelect();
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
                            child: Text(
                              _onlinePay.title,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            _onlinePay.title.contains('余额')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Text('余额:${userModel.user.diamond}'),
                      ),
                    ],
                  )
                : Container(),
            Container(
              margin: const EdgeInsets.all(40),
              width: (MediaQuery.of(context).size.width) - 100,
              child: TextButton(
                onPressed: () {},
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
        ));
  }

  _ShowOnlinePaySelect() async {
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
        ImageIcons.yue.keyName,
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

  _getOrder(int type, int cid, int id, int amount) async {
    Map<String, dynamic> parm = {
      'id': id,
      'cid': cid,
      'type': type,
      'amount': amount,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['verify'] == true) {
        Global.showWebColoredToast('修改成功!');
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
