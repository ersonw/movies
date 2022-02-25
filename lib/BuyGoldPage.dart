import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/DiamondRecordsPage.dart';
import 'package:movies/GoldRecordsPage.dart';
import 'package:movies/data/BuyDiamond.dart';
import 'package:movies/data/BuyGold.dart';
import 'package:movies/global.dart';

import 'BuyDiamondRecordsPage.dart';
import 'BuyGoldRecordsPage.dart';
import 'CrateOrderPage.dart';
import 'HttpManager.dart';
import 'data/OnlinePay.dart';
import 'functions.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class BuyGoldPage extends StatefulWidget {
  const BuyGoldPage({Key? key}) : super(key: key);

  @override
  _BuyGoldPage createState() => _BuyGoldPage();
}

class _BuyGoldPage extends State<BuyGoldPage>
    with SingleTickerProviderStateMixin {
  late TabController _innerTabController;
  final _tabKey = const ValueKey('tab');
  int _tabIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
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
                            '金币余额',
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
                            '${userModel.user.gold}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 36),
                          ),
                        ),
                        Image.asset(
                          ImageIcons.GoldCoins.assetName,
                          width: 30,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push<void>(
                                CupertinoPageRoute(
                                  // title: '确认订单',
                                  builder: (context) => const BuyGoldRecordsPage(),
                                ),
                              );
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
                                '充值记录',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push<void>(
                                CupertinoPageRoute(
                                  // title: '确认订单',
                                  builder: (context) => const GoldRecordsPage(),
                                ),
                              );
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
                                '收支明细',
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
                child: _buildBody(),
              ),
            ],
          ),
        ));
  }
  _crateOrder(int id) async{
    Map<String, dynamic> parm = {
      'id': id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.crateGoldOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['crate'] == true){
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            // title: '确认订单',
            builder: (context) => CrateOrderPage(
              type: OnlinePay.PAY_ONLINE_GOLD,
              order_id: map['id'],
            ),
          ),
        ).then((value) {
          Navigator.of(context, rootNavigator: true).push<void>(
            CupertinoPageRoute(
              title: '购买记录',
              builder: (context) => const BuyGoldRecordsPage(),
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
                type: OnlinePay.PAY_ONLINE_DIAMOND,
                order_id: map['id'],
              ),
            ),
          ).then((value) {
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: '购买记录',
                builder: (context) => const BuyGoldRecordsPage(),
              ),
            );
          });
        }else{
          Navigator.of(context, rootNavigator: true).push<void>(
            CupertinoPageRoute(
              title: '购买记录',
              builder: (context) => const BuyGoldRecordsPage(),
            ),
          );
        }
      }
    }
  }
  _buildItemDiamond(BuyGold buyGold){
    return InkWell(
      onTap: () {
        _crateOrder(buyGold.id);
      },
      child: Container(
        height: 150,
        width: ((MediaQuery.of(context).size.width) / 2.3),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1.0, color: Colors.black12),
          image: DecorationImage(image: AssetImage(ImageIcons.GoldCoins.assetName)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${buyGold.gold}金币',style: const TextStyle(color: Colors.deepOrange,fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('￥',style: TextStyle(color: Colors.black,fontSize: 15),),
                Text('${buyGold.amount ~/ 100}',style: const TextStyle(color: Colors.black,fontSize: 30),),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _buildOnline() {
    return ListView.builder(
      itemCount: ((configModel.buyGolds.length) ~/ 2) +1,
      itemBuilder: (BuildContext _context, int index) {
        List<Widget> widget = [];
        if(index*2 < configModel.buyGolds.length){
          BuyGold buyGold = configModel.buyGolds[index*2];
          widget.add(_buildItemDiamond(buyGold));
        }
        if((index*2 +1) < configModel.buyGolds.length){
          BuyGold buyGold = configModel.buyGolds[(index*2 +1)];
          widget.add(_buildItemDiamond(buyGold));
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
    // TODO: implement dispose
    super.dispose();
  }
}
