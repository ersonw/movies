import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/DiamondRecord.dart';
import 'package:movies/data/GoldRecord.dart';
import 'package:movies/data/VIPBuyRecords.dart';

import 'CrateOrderPage.dart';
import 'HttpManager.dart';
import 'data/BuyDiamondRecord.dart';
import 'data/OnlinePay.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class GoldRecordsPage extends StatefulWidget {
  const GoldRecordsPage({Key? key}) : super(key: key);

  @override
  _GoldRecordsPage createState() => _GoldRecordsPage();
}

class _GoldRecordsPage extends State<GoldRecordsPage> {
  final ScrollController _controller = ScrollController();
  List<GoldRecord> _list = [];
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
        NWMethod.GET, NWApi.getGoldRecords, {"data": jsonEncode(parm)}));
    if (result != null) {
      print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['total'] != null) {
        total = map['total'];
      }
      if (map['list'] != null) {
        if(page > 1) {
          List<GoldRecord> list = (map['list'] as List)
              .map((i) => GoldRecord.formJson(i))
              .toList();
          setState(() {
            _list.addAll(list);
          });
        }else{
          setState(() {
            _list = (map['list'] as List)
                .map((i) => GoldRecord.formJson(i))
                .toList();
          });
        }
      }
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
              GoldRecord records = _list[index];
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
                          children: [
                            const Text('备注:'),
                            Text(records.reason),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('数量:',
                              style: TextStyle(
                                  color: Colors.brown, fontSize: 17),),
                            Text('${'${records.gold}'.startsWith('-') ? '': '+'}${records.gold}', style: const TextStyle(
                                color: Colors.red, fontSize: 30),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('时间：${Global.getTimeToString(records.add_time)}'),
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
