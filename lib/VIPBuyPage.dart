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
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'HttpManager.dart';
import 'ImageIcons.dart';
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
      return const AssetImage(ImageIcons.default_head);
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
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white, // 底色
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10, //阴影范围
                    spreadRadius: 0.1, //阴影浓度
                    color: Colors.grey.withOpacity(0.2), //阴影颜色
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(left: 20, top: 20,bottom: 20),
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
                      child: Column(
                        children: [
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width) / 1.9),
                            child: Text(
                                _user.nickname,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.left
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                userModel.user.expired > DateTime.now().millisecondsSinceEpoch ?
                                Text(
                                  '您是黄金会员，到期时间 ${Global.getDateToString(userModel.user.expired)}',
                                  style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),
                                )
                                    : Container(),
                              ]
                          ),
                        ]
                      ), ),
                  // const Padding(padding: EdgeInsets.only(bottom:25)),
                ],
              ),
            ),
            // TabBar(
            //     controller: _innerTabController,
            //     labelColor: Colors.black,
            //     tabs: const [
            //       Tab(
            //         child: Text('在线充值'),
            //       ),
            //       Tab(
            //         child: Text('代理充值'),
            //       )
            //     ]),
            Expanded(
              child:_buildBody(),
            ),
          ],
        ));
  }
  _buildOnlineImage(String image){
    if(image == null || image == '') return  AssetImage(ImageIcons.everyDay);
    if(image.startsWith('http')){
      return NetworkImage(image);
    }
    return FileImage(File(image));
  }
  _crateOrder(int id) {
    Global.showPayDialog((int payId) async{
      Map<String, dynamic> parm = {
        'id': id,
      };
      String? result = (await DioManager().requestAsync(
          NWMethod.GET, NWApi.crateVipOrder, {"data": jsonEncode(parm)}));
      if (result != null) {
        // print(result);
        Map<String, dynamic> map = jsonDecode(result);
        if(map['crate'] == true && map['id'] != null){
          _postCrateOrder(orderId: map['id'], payId: payId);
        }else{
          Global.showWebColoredToast('存在未付订单，请先支付或取消该订单才可以继续');
        }
        Global.getUserInfo();
      }
    });

  }
  _postCrateOrder({required String orderId, required int payId}) async {
    Map<String, dynamic> parm = {
      'order_id': orderId,
      'type': OnlinePay.PAY_ONLINE_VIP,
      'pid': payId,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.postCrateOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] == 'ok'){
        if(map['url'] != null){
          await Global.reportOpen(Global.REPORT_OPEN_VIP);
          launch(map['url']);
          Global.showPayDialogTiShi();
        }else{
          Global.getUserInfo();
        }
      }else{
        Global.showWebColoredToast(map['msg']);
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
                              style: const TextStyle(color: Color(0xFF946656), fontSize: 19),
                            ),
                          ),
                          Container(
                            // color: Colors.yellow,
                            margin: const EdgeInsets.only(right: 10, top: 20),
                            child: Text('${vipBuy.amount ~/ 100}',
                              style: const TextStyle(color: Color(0xFFC7806C), fontSize: 40),
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
