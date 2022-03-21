import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/OrderRecords.dart';

import 'HttpManager.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class OrderRecordsPage extends StatefulWidget {
  const OrderRecordsPage({Key? key}) : super(key: key);

  @override
  _OrderRecordsPage createState() => _OrderRecordsPage();

}
class _OrderRecordsPage extends State<OrderRecordsPage> {
  List<OrderRecords> _orderRecords = [];
  final ScrollController _controller = ScrollController();
  bool isLoading = false;
  int total = 0;
  int page = 1;
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
  _init() async {
    Map<String, dynamic> parm = {
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getOrders, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['total'] != null) {
        total = map['total'];
      }
      if (map['list'] != null) {
        setState(() {
          if(page > 1){
            _orderRecords.addAll((map['list'] as List)
                .map((i) => OrderRecords.formJson(i))
                .toList());
          }else{
            _orderRecords = (map['list'] as List)
                .map((i) => OrderRecords.formJson(i))
                .toList();
          }
          // _orderRecords.addAll(_orderRecords);
          // _orderRecords.addAll(_orderRecords);
        });
      }
    }
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child:ListView.builder(
            itemCount: _orderRecords.length,
            controller: _controller,
            itemBuilder: (BuildContext _context, int index) {
              OrderRecords records = _orderRecords[index];
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('关联订单号：${records.orderNo}',
                              style: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 17),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('交易类型：${_switchType(records.type)}',
                              style: const TextStyle(
                                  color: Colors.brown, fontSize: 17),),
                            Text('¥${records.amount / 100}', style: const TextStyle(
                                color: Colors.red, fontSize: 30),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('创建时间：${Global.getDateTime(records.ctime)}'),
                            Text('状态：${_switchStatus(records.status)}')
                          ],
                        ),
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
  _switchType(int type){
    switch(type){
      case OnlinePay.PAY_ONLINE_VIP:
        return '购买会员';
      case OnlinePay.PAY_ONLINE_DIAMOND:
        return '购买钻石';
      case OnlinePay.PAY_ONLINE_GOLD:
        return '购买金币';
      default:
        return '未知类型';
    }
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
      default:
        str = '支付失败';
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