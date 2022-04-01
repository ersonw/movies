import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/CrateOrderPage.dart';
import 'package:movies/VIPBuyRecordsPage.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/User.dart';
import 'package:movies/data/VIPBuy.dart';
import 'package:movies/functions.dart';
import 'package:movies/global.dart';
import 'dart:io';
import 'HttpManager.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class VIPBuyPage extends StatefulWidget {
  const VIPBuyPage({Key? key}) : super(key: key);

  @override
  _VIPBuyPage createState() => _VIPBuyPage();
}

class _VIPBuyPage extends State<VIPBuyPage>
    with SingleTickerProviderStateMixin {
  User _user = User();
  List<VIPBuy> _vipBuys = [];
  late TabController _innerTabController;
  final _tabKey = const ValueKey('tab');
  int _tabIndex = 0;
  bool alive = true;

  void handleTabChange() {
    setState(() {
      _tabIndex = _innerTabController.index;
    });
    // print('Inner tab, previous: ${_innerTabController.previousIndex}, current: ${_innerTabController.index}');
    PageStorage.of(context)
        ?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int initialIndex =
        PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 0);
    _innerTabController.addListener(handleTabChange);
    _init();
    userModel.addListener(() {
      if(alive) _init();
    });
    configModel.addListener(() {
      if(alive){_init();}
    });
  }

  void _init() {
    setState(() {
      _user = userModel.user;
      _vipBuys = configModel.vipBuys;
    });
  }

  _buildAvatar() {
    if ((_user.avatar == null || _user.avatar == '') ||
        _user.avatar?.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(_user.avatar!);
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
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push<void>(
                      CupertinoPageRoute(
                        // title: '确认订单',
                        builder: (context) => const VIPBuyRecordsPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "购买记录",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ]),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(left: 40, top: 40),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                        // image: AssetImage('assets/image/default_head.gif'),
                        image: _buildAvatar(),
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      _user.nickname,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ],
            ),
            TabBar(
                controller: _innerTabController,
                labelColor: Colors.black,
                tabs: const [
                  Tab(
                    child: Text('在线充值'),
                  ),
                  Tab(
                    child: Text('代理充值'),
                  )
                ]),
                  Expanded(
                  child:_buildBody(),
                  ),
          ],
        ));
  }
  _buildOnlineImage(String image){
    if(image == null || image == '') return  ImageIcons.zhipianrenjihua;
    if(image.startsWith('http')){
      return NetworkImage(image);
    }
    return FileImage(File(image));
  }
  _crateOrder(int id) async{
    Map<String, dynamic> parm = {
      'id': id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.crateVipOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['crate'] == true){
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            // title: '确认订单',
            builder: (context) => CrateOrderPage(
              type: OnlinePay.PAY_ONLINE_VIP,
              order_id: map['id'],
            ),
          ),
        ).then((value) {
          Navigator.of(context, rootNavigator: true).push<void>(
            CupertinoPageRoute(
              title: '购买记录',
              builder: (context) => const VIPBuyRecordsPage(),
            ),
          );
        });
      }else{
        bool sure = await ShowAlertDialogBool(context, '订单提醒', '您已存在未付订单，请先支付或取消该订单才可以继续，确定前往订单吗?');
        if(sure){
          Navigator.of(context, rootNavigator: true).push<void>(
            CupertinoPageRoute(
              // title: '确认订单',
              builder: (context) => CrateOrderPage(
                type: OnlinePay.PAY_ONLINE_VIP,
                order_id: map['id'],
              ),
            ),
          ).then((value) {
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: '购买记录',
                builder: (context) => const VIPBuyRecordsPage(),
              ),
            );
          });
        }else{
          Navigator.of(context, rootNavigator: true).push<void>(
            CupertinoPageRoute(
              title: '购买记录',
              builder: (context) => const VIPBuyRecordsPage(),
            ),
          );
        }
      }
    }
  }

  _buildOnline() {
    return ListView.builder(
      itemCount: _vipBuys.length,
        itemBuilder:  (BuildContext ctxt, int index) {
        VIPBuy vipBuy = _vipBuys[index];
          return InkWell(
            onTap: () {
              // ShowOnlinePaySelect(ctxt, OnlinePay.PAY_ONLINE_VIP,vipBuy.id, vipBuy.amount);
              _crateOrder(vipBuy.id);
            },
            child: Container(
              height: 120,
              margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
              decoration: BoxDecoration(
                // color: Colors.grey,
                border: Border.all(width: 2.0, color: Colors.transparent),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: _buildOnlineImage(vipBuy.image),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   vipBuy.isText ? Column(
                    children: [
                      Text(vipBuy.title,
                        style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        vipBuy.describes,
                        style: const TextStyle(color: Colors.yellow, fontSize: 15),
                      ),
                    ],
                  ) : Container(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Text(vipBuy.currency,
                              style: const TextStyle(color: Colors.brown, fontSize: 19),
                            ),
                          ),
                          Container(
                            // color: Colors.yellow,
                            margin: const EdgeInsets.only(right: 10, top: 20),
                            child: Text('${vipBuy.amount ~/ 100}',
                              style: const TextStyle(color: Colors.brown, fontSize: 45),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(1),
                        child: vipBuy.original > 0 ? Text('原价${vipBuy.currency}${vipBuy.original ~/ 100}',
                          style: const TextStyle(
                              color: Colors.brown,
                              fontSize: 15,
                              decoration: TextDecoration.lineThrough),
                        ) : Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  _buildAgent(){
    return ListView();
  }
  _buildBody() {
    if(_tabIndex == 0){
      return _buildOnline();
    }else{
      return _buildAgent();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    alive = false;
    super.dispose();
  }
}
