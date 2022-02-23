import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/VIPBuyRecords.dart';

import 'CrateOrderPage.dart';
import 'HttpManager.dart';
import 'data/BuyDiamondRecord.dart';
import 'data/OnlinePay.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class BuyDiamondRecordsPage extends StatefulWidget {
  const BuyDiamondRecordsPage({Key? key}) : super(key: key);

  @override
  _BuyDiamondRecordsPage createState() => _BuyDiamondRecordsPage();
}

class _BuyDiamondRecordsPage extends State<BuyDiamondRecordsPage> {
  final ScrollController _controller = ScrollController();
  List<BuyDiamondRecord> _list = [];
  int total = 0;
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        _getMore();
      }
    });
  }

  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      Global.loading(isLoading);
      ++page;
      _init();
      await Future.delayed(const Duration(seconds: 3), () async{
        // print('加载更多');
        isLoading = false;
        Global.loading(isLoading);
      });
    }
  }
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 3), () {
      page = 1;
      _init();
    });
  }
  _init() async {
    Map<String, dynamic> parm = {
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getDiamondOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['total'] != null) {
        total = map['total'];
      }
      if (map['list'] != null) {
        if(page > 1) {
          _list.addAll((map['list'] as List)
              .map((i) => BuyDiamondRecord.formJson(i))
              .toList());
        }else{
          setState(() {
            _list = (map['list'] as List)
                .map((i) => BuyDiamondRecord.formJson(i))
                .toList();
          });
        }
      }
    }
  }
  _cancelOrder(int id) async{
    Map<String, dynamic> parm = {
      'id': id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.cancelDiamondOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      Global.showWebColoredToast('取消成功！');
      setState(() {
        _init();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: _list.length,
            controller: _controller,
            itemBuilder: (BuildContext _context, int index) {
              BuyDiamondRecord records = _list[index];
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('订单号：${records.orderId}'),
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: records.orderId));
                                Global.showWebColoredToast('复制成功！');
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.copy),
                                  Text('复制')
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('类型：购买钻石',
                              style: TextStyle(
                                  color: Colors.brown, fontSize: 17),),
                            Text('￥${records.amount / 100}', style: const TextStyle(
                                color: Colors.red, fontSize: 30),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('创建时间：${Global.getDateTime(records.ctime ~/ 1000)}'),
                            Text('状态：${_switchStatus(records.status)}')
                          ],
                        ),
                        records.status == 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).push<void>(
                                      CupertinoPageRoute(
                                        // title: '确认订单',
                                        builder: (context) => CrateOrderPage(
                                          type: OnlinePay.PAY_ONLINE_DIAMOND,
                                          order_id: records.orderId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('继续支付',style: TextStyle(color: Colors.white),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.black54),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                    ),
                                    onPressed: () => _cancelOrder(records.id),
                                    child: const Text('取消订单',style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ) : Container(),
                      ],
                    ),
                  )
              );
            }
        ),
      ),
      // child: Column(),
    );
  }

  _switchStatus(int status) {
    String str = '未知状态';
    switch (status) {
      case 0:
        str = '未支付';
        break;
      case 1:
        str = '已支付';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
