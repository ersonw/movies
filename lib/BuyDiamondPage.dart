import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/DiamondRecordsPage.dart';
import 'package:movies/WithdrawalManagementPage.dart';
import 'package:movies/data/BuyDiamond.dart';
import 'package:movies/global.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BuyDiamondRecordsPage.dart';
import 'CrateOrderPage.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'OnlinePayPage.dart';
import 'SlideRightRoute.dart';
import 'data/OnlinePay.dart';
import 'functions.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class BuyDiamondPage extends StatefulWidget {
  const BuyDiamondPage({Key? key}) : super(key: key);

  @override
  _BuyDiamondPage createState() => _BuyDiamondPage();
}

class _BuyDiamondPage extends State<BuyDiamondPage>
    with SingleTickerProviderStateMixin {
  late TabController _innerTabController;
  final _tabKey = const ValueKey('tab');
  int _tabIndex = 0;
  bool alive = true;
  int diamond = 0;

  void handleTabChange() {
    setState(() {
      _tabIndex = _innerTabController.index;
    });
    PageStorage.of(context)
        ?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }

  @override
  void initState() {
    diamond = userModel.user.diamond;
    userModel.addListener(() {
      if(alive){
        diamond = userModel.user.diamond;
      }
    });
    Global.getUserInfo();
    super.initState();
    int initialIndex =
        PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 0);
    _innerTabController.addListener(handleTabChange);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context, rootNavigator: true).push<void>(
                //       CupertinoPageRoute(
                //         // title: '确认订单',
                //         builder: (context) => const BuyDiamondRecordsPage(),
                //       ),
                //     );
                //   },
                //   child: const Text(
                //     "充值记录",
                //     style: TextStyle(color: Colors.black, fontSize: 18),
                //   ),
                // ),
                Text('我的钻石',style: TextStyle(color: Colors.black, fontSize: 21,fontWeight: FontWeight.bold),),
              ]),
        ),
        // navigationBar: const CupertinoNavigationBar(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            // image: DecorationImage(
            //   fit: BoxFit.fill,
            //   image: ImageIcons.vipBuy,
            // ),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 80,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 40),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          child: const Text(
                            '钻石余额',
                            style: TextStyle(
                                color: Colors.black,
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
                            '${diamond}',
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
                    const Padding(padding: EdgeInsets.only(top: 20)),
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
              Container(
                margin: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.of(context, rootNavigator: true).push<void>(
                        //   CupertinoPageRoute(
                        //     title: '钻石提现',
                        //     builder: (context) =>  WithdrawalManagementPage(
                        //       type: WithdrawalManagementPage.WITHDRAWAL_DIAMOND,
                        //     ),
                        //   ),
                        // );
                        Navigator.push(Global.MainContext, SlideRightRoute(page: const BuyDiamondRecordsPage())).then((value) => setState(() {Global.getUserInfo();}));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              // Colors.redAccent,
                              Color(0xFFFC8A7D),
                              Color(0xffff0010),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          border: Border.all(width: 1.0, color: Colors.black12),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top:10,bottom: 10, left:30,right: 30),
                          child: Row(
                            children: [
                              Image.asset(ImageIcons.iconCardList, width: 20),
                              const Text(
                                '充值记录',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push<void>(
                          CupertinoPageRoute(
                            // title: '确认订单',
                            builder: (context) => const DiamondRecordsPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              // Colors.redAccent,
                              Color(0xFFFC8A7D),
                              Color(0xffff0010),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          border: Border.all(width: 1.0, color: Colors.black12),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top:10,bottom: 10, left:30,right: 30),
                          child: Row(
                            children: [
                              Image.asset(ImageIcons.iconCoins, width: 20),
                              const Text(
                                '收支明细',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ));
  }
  _crateOrder(int id) {
    Global.showPayDialog((int payId) async{
      Map<String, dynamic> parm = {
        'id': id,
      };
      String? result = (await DioManager().requestAsync(
          NWMethod.GET, NWApi.crateDiamondOrder, {"data": jsonEncode(parm)}));
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
      'type': OnlinePay.PAY_ONLINE_DIAMOND,
      'pid': payId,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.postCrateOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] == 'ok'){
        if(map['url'] != null){
          await Global.reportOpen(Global.REPORT_CREATE_ORDER);
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
  _buildItemDiamond(BuyDiamond buyDiamond){
    return InkWell(
      onTap: () {
        _crateOrder(buyDiamond.id);
      },
      child: Container(
        height: 120,
        width: ((MediaQuery.of(context).size.width) / 3.6),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(ImageIcons.bgBuyDinmond)
          ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${buyDiamond.diamond}钻石',style: const TextStyle(color: Color(
                0xffe17825),fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('￥',style: TextStyle(color: Colors.black,fontSize: 21),),
                Text('${(buyDiamond.amount ~/ 100)}',style: const TextStyle(color: Colors.black,fontSize: 21),),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _buildOnline() {
    return ListView.builder(
      itemCount: ((configModel.buyDiamonds.length) ~/ 3) +1,
      itemBuilder: (BuildContext _context, int index) {
        List<Widget> widget = [];
        if(index*3 < configModel.buyDiamonds.length){
          BuyDiamond buyDiamond = configModel.buyDiamonds[index*3];
          widget.add(_buildItemDiamond(buyDiamond));
        }
        if((index*3 +1) < configModel.buyDiamonds.length){
          BuyDiamond buyDiamond = configModel.buyDiamonds[(index*3 +1)];
          widget.add(_buildItemDiamond(buyDiamond));
        }
        if((index*3 +2) < configModel.buyDiamonds.length){
          BuyDiamond buyDiamond = configModel.buyDiamonds[(index*3 +2)];
          widget.add(_buildItemDiamond(buyDiamond));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget,
        );
      },
    );
  }

  _buildBody() {
    if(_tabIndex == 0){
      return _buildOnline();
    }
    return Container();
  }

  @override
  void dispose() {
    alive = false;
    super.dispose();
  }
}
