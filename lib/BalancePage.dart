import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/TransferPage.dart';
import 'package:movies/data/BalanceRecord.dart';

import 'HttpManager.dart';
import 'WithdrawalManagementPage.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  _BalancePage createState() => _BalancePage();
}

class _BalancePage extends State<BalancePage> {
  final ScrollController _controller = ScrollController();
  int balance = 0;
  List<BalanceRecord> _list = [];
  int page = 0;
  int total = 0;
  @override
  void initState(){
    _balance();
    _initList();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        page++;
        _initList();
      }
    });
    super.initState();
  }
  _initList() async {
    if (page > total) {
      page--;
      return;
    }
    Map<String, dynamic> parm = {
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getBalanceRecords, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['list'] != null) {
        List<BalanceRecord> list = (map['list'] as List)
            .map((e) => BalanceRecord.formJson(e))
            .toList();
        setState(() {
          if (page > 1) {
            _list.addAll(list);
          } else {
            _list = list;
          }
        });
      }
    }
  }
  _balance() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getBalance, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if (map['balance'] != null) {
        setState(() {
          balance = map['balance'];
        });
      }
    }
  }
  _switchStatus(int status) {
    String str = '未知状态';
    switch (status) {
      case 0:
        str = '操作中';
        break;
      case 1:
        str = '已成功';
        break;
      case -1:
        str = '已取消';
        break;
      default:
        break;
    }
    return str;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: Colors.black12,
      child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: 80,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Colors.black12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        child: const Text(
                          '现金余额',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          '￥${(balance /100).toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 36),
                        ),
                      ),
                      // Image.asset(
                      //   ImageIcons.diamond.assetName,
                      //   width: 30,
                      // ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push<void>(
                              CupertinoPageRoute(
                                title: '余额提现',
                                builder: (context) =>  WithdrawalManagementPage(
                                  type: WithdrawalManagementPage.WITHDRAWAL_BALANCE,
                                ),
                              ),
                            ).then((value) {
                              page = 1;
                              total = 1;
                              _initList();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          child: Container(
                            width: 140,
                            alignment: Alignment.center,
                            child: const Text(
                              '提现',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     Global.showWebColoredToast('暂未开放直接充值余额!');
                        //   },
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //     MaterialStateProperty.all(Colors.orange),
                        //     shape: MaterialStateProperty.all(
                        //         RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(5))),
                        //   ),
                        //   child: Container(
                        //     width: 140,
                        //     alignment: Alignment.center,
                        //     child: const Text(
                        //       '充值',
                        //       style: TextStyle(
                        //           color: Colors.black, fontSize: 18),
                        //     ),
                        //   ),
                        // ),
                        TextButton(
                          onPressed: () {
                            Global.showWebColoredToast('暂未开放余额转账!');
                            // Navigator.of(context, rootNavigator: true).push<void>(
                            //   CupertinoPageRoute(
                            //     title: '余额提现',
                            //     builder: (context) =>  const TransferPage(),
                            //   ),
                            // ).then((value) {
                            //   page = 1;
                            //   total = 1;
                            //   _initList();
                            // });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          child: Container(
                            width: 140,
                            alignment: Alignment.center,
                            child: const Text(
                              '转账',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: ListView.builder(
                itemCount: _list.length,
                controller: _controller,
                itemBuilder: (BuildContext _context, int index) {
                  BalanceRecord records = _list[index];
                  return Container(
                    // height: 150,
                      margin: const EdgeInsets.all(20),
                      // color: Colors.grey,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        // border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('备注：${records.reason}',
                                      style: const TextStyle(
                                          color: Colors.brown, fontSize: 17),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('￥${records.amount > 0 ? '+' : ''}${(records.amount / 100).toStringAsFixed(2)}', style: const TextStyle(
                                        color: Colors.red, fontSize: 30),),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('操作时间：${Global.getTimeToString(records.addTime)}'),
                                Text('状态：${_switchStatus(records.status)}')
                              ],
                            ),
                          ],
                        ),
                      )
                  );
                }
            )),
          ]
      ),
    );
  }
}
