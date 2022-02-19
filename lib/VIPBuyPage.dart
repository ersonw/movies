import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/OnlinePay.dart';
import 'package:movies/data/User.dart';
import 'package:movies/functions.dart';
import 'package:movies/global.dart';

import 'image_icon.dart';

class VIPBuyPage extends StatefulWidget {
  const VIPBuyPage({Key? key}) : super(key: key);

  @override
  _VIPBuyPage createState() => _VIPBuyPage();
}

class _VIPBuyPage extends State<VIPBuyPage>
    with SingleTickerProviderStateMixin {
  User _user = User();
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
    _init();
    userModel.addListener(() {
      _init();
    });
  }

  void _init() {
    setState(() {
      _user = userModel.user;
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
                  onPressed: () {},
                  child: const Text(
                    "充值明细",
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

  _buildOnline() {
    return ListView(
        children: [
          InkWell(
            onTap: () {
              ShowOnlinePaySelect(context, OnlinePay.PAY_ONLINE_VIP, 100);
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // color: Colors.grey,
                border: Border.all(width: 2.0, color: Colors.red),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: ImageIcons.zhipianrenjihua,
                  //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                  // centerSlice: Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 90, top: 10),
                        child: Text(
                          '新年特惠卡',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        // color: Colors.yellow,
                        // margin: const EdgeInsets.only(left: 90),
                          child: Text(
                            '新年特惠卡',
                            style: TextStyle(color: Colors.yellow, fontSize: 15),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: Text(
                              '¥',
                              style: TextStyle(color: Colors.brown, fontSize: 19),
                            ),
                          ),
                          Container(
                            // color: Colors.yellow,
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: Text(
                              '100',
                              style: TextStyle(color: Colors.brown, fontSize: 45),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(1),
                        child: Text(
                          '原价¥200',
                          style: TextStyle(
                              color: Colors.brown,
                              fontSize: 15,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
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
    super.dispose();
  }
}
