import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CashInGameRecordPage.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'SlideRightRoute.dart';
import 'data/CashIn.dart';
import 'data/OnlinePay.dart';
import 'data/User.dart';
import 'functions.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class CashInGamePage extends StatefulWidget {
  const CashInGamePage({Key? key}) : super(key: key);

  @override
  _CashInGamePage createState() => _CashInGamePage();
}

class _CashInGamePage extends State<CashInGamePage> {
  double gameBalance = 0;
  bool alive = true;
  User _user = userModel.user;
  List<CashIn> _list = [];
  @override
  void initState() {
    _getBalance();
    _init();
    super.initState();
    userModel.addListener(() {
      if(alive){
        setState(() {
          _user = userModel.user;
        });
      }
    });
  }
  _init() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getCashIns, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if (map != null && map["list"] != null){
        setState(() {
          _list = (map['list'] as List).map((e) => CashIn.formJson(e)).toList();
        });
      }
    }
  }
  void _getBalance() async {
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getGameBalance, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null && map['gameBalance'] != null){
        setState(() {
          gameBalance =  map['gameBalance'];
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left:20,right: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: ((MediaQuery.of(context).size.width) / 2.5),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,),
                              ]
                            ),
                          ),
                        ),
                        const Center(child: Text('充值',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                      ]
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: ((MediaQuery.of(context).size.width) / 1),
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15.0),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/balanceCard.png'),
                        )),
                    child: Column(
                      children: [
                        Container(
                          child: const Text('钱包余额',style: TextStyle(color: Colors.white54,fontSize: 12)),
                          margin: const EdgeInsets.only(left: 20,top: 20,),
                          width: ((MediaQuery.of(context).size.width) / 1),
                        ),
                        Row(
                            children: [
                              Container(
                                child: Text('￥${((gameBalance * 100) / 100).toStringAsFixed(2)}',style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
                                margin: const EdgeInsets.only(left: 20,top: 20,),
                                // width: ((MediaQuery.of(context).size.width) / 1.5),
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(left: 10, right: 10),
                  //   width: ((MediaQuery.of(context).size.width) / 1),
                  //   // height: 120,
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey,
                  //       borderRadius: BorderRadius.circular(20.0),
                  //       image: const DecorationImage(
                  //         fit: BoxFit.fill,
                  //         image: AssetImage('assets/images/balanceCard.png'),
                  //       )),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Container(
                  //             child: const Text('游戏余额',style: TextStyle(color: Colors.white70,fontSize: 15)),
                  //             margin: const EdgeInsets.only(left: 20,top: 20,),
                  //             // width: ((MediaQuery.of(context).size.width) / 1),
                  //           ),
                  //           Row(
                  //               children: [
                  //                 Container(
                  //                   child: Text('￥${((gameBalance * 100) / 100).toStringAsFixed(2)}',style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                  //                   margin: const EdgeInsets.only(left: 5,top: 20,),
                  //                   // width: ((MediaQuery.of(context).size.width) / 1.5),
                  //                 ),
                  //               ]
                  //           ),
                  //         ],
                  //       ),
                  //       // Row(
                  //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       //   children: [
                  //       //     Row(
                  //       //       children: [
                  //       //         Container(
                  //       //           child: const Text('钻石余额',style: TextStyle(color: Colors.white70,fontSize: 15)),
                  //       //           margin: const EdgeInsets.only(left: 20,top: 10,),
                  //       //           // width: ((MediaQuery.of(context).size.width) / 1),
                  //       //         ),
                  //       //         Row(
                  //       //             children: [
                  //       //               Container(
                  //       //                 child: Text('${_user.diamond}',style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                  //       //                 margin: const EdgeInsets.only(left: 5,top: 10,),
                  //       //                 // width: ((MediaQuery.of(context).size.width) / 1.5),
                  //       //               ),
                  //       //             ]
                  //       //         ),
                  //       //       ],
                  //       //     ),
                  //       //     InkWell(
                  //       //       onTap: (){
                  //       //         _turnDiamond(context);
                  //       //       },
                  //       //       child: Container(
                  //       //         height:30,
                  //       //         width: 80,
                  //       //         margin: const EdgeInsets.only(right: 20, top: 10),
                  //       //         decoration: const BoxDecoration(
                  //       //           image: DecorationImage(
                  //       //             image: AssetImage(ImageIcons.turn1),
                  //       //             fit: BoxFit.fill,
                  //       //           ),
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   ]
                  //       // ),
                  //       // Row(
                  //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       //   children: [
                  //       //     Row(
                  //       //       children: [
                  //       //         Container(
                  //       //           child: const Text('金币余额',style: TextStyle(color: Colors.white70,fontSize: 15)),
                  //       //           margin: const EdgeInsets.only(left: 20,top: 10,),
                  //       //           // width: ((MediaQuery.of(context).size.width) / 1),
                  //       //         ),
                  //       //         Row(
                  //       //             children: [
                  //       //               Container(
                  //       //                 child: Text('${_user.gold}',style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                  //       //                 margin: const EdgeInsets.only(left: 5,top: 10,),
                  //       //                 // width: ((MediaQuery.of(context).size.width) / 1.5),
                  //       //               ),
                  //       //             ]
                  //       //         ),
                  //       //       ],
                  //       //     ),
                  //       //     InkWell(
                  //       //       onTap: (){
                  //       //         _turnGold(context);
                  //       //       },
                  //       //       child: Container(
                  //       //         height:30,
                  //       //         width: 80,
                  //       //         margin: const EdgeInsets.only(right: 20, top: 10),
                  //       //         decoration: const BoxDecoration(
                  //       //           image: DecorationImage(
                  //       //             image: AssetImage(ImageIcons.turn1),
                  //       //             fit: BoxFit.fill,
                  //       //           ),
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   ]
                  //       // ),
                  //       const Padding(padding: EdgeInsets.only(bottom:20)),
                  //     ],
                  //   ),
                  // ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('游戏余额充值',style: TextStyle(color: Colors.black,fontSize: 18)),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, SlideRightRoute(page: const CashInGameRecordPage()));
                          },
                          child: const Text('充值记录>',style: TextStyle(color:  Colors.black54)),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  _buildList(),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('常见问题',style: TextStyle(color: Colors.black,fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(
                    width: ((MediaQuery.of(context).size.width) / 1),
                    margin: const EdgeInsets.only(left:20,right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left:10,right:10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(right:10),
                                      child: Image.asset(ImageIcons.redPoint,width: 10,),
                                    ),
                                    SizedBox(
                                      width: ((MediaQuery.of(context).size.width) / 1.4),
                                      child: Text('如多次支付失败,请尝试请尝试其他支付方式再试'),
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(right:10),
                                      child: Image.asset(ImageIcons.redPoint,width: 10,),
                                    ),
                                    SizedBox(
                                      width: ((MediaQuery.of(context).size.width) / 1.4),
                                      child: Text('支付成功后一般10分钟内到账,若超过30分钟请联系客服'),
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: const EdgeInsets.only(right:10),
                                      child: Image.asset(ImageIcons.redPoint,width: 10,),
                                    ),
                                    SizedBox(
                                      width: ((MediaQuery.of(context).size.width) / 1.4),
                                      child: Text('部分安卓手机支付时报毒,请选择忽略即可'),
                                    ),
                                  ]
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ]
            ),
          ]
      ),
    );
  }
  _buildList(){
    List<Widget> widgets = [];
    for (int i = 0; i < (_list.length / 3) + 1; i++) {
      widgets.add(_buildListRow(i));
    }
    return Column(
      children: widgets,
    );
  }
  _buildListRow(int i){
    List<Widget> widgets = [];
    if((i*3) < _list.length) widgets.add(_buildListItem((i*3)));
    if((i*3+1) < _list.length) widgets.add(_buildListItem((i*3)+1));
    if((i*3+2) < _list.length) widgets.add(_buildListItem((i*3)+2));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }
  _buildListItem(int index){
    CashIn cashIn = _list[index];
    return InkWell(
      onTap: () {
        _crateOrder(cashIn.id);
      },
      child: Container(
        margin: const EdgeInsets.only(left:10,bottom: 10),
        // width: ((MediaQuery.of(context).size.width) / 3.9),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFFFEE9C4),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left:10,right: 10,top: 10),
                width: ((MediaQuery.of(context).size.width) / 4),
                height: 45,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white54,
                ),
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text('${cashIn.amount ~/ 100}', style: const TextStyle(color: Color(0xFFF09D08),fontSize: 18,fontWeight: FontWeight.bold)),
                        const Text('元', style: TextStyle(color: Colors.red,fontSize: 12)),
                      ]
                  ),
                ),
              ),
              cashIn.vip > 0 ? Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                child: Text('赠 ${cashIn.vip}天会员',style: const TextStyle(color: Colors.red,fontSize: 12)),
              ) :
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                child: const Text('无赠送',style:  TextStyle(color: Colors.red,fontSize: 12)),
              ),
              // const Padding(padding: EdgeInsets.only(bottom: 10)),
            ]
        ),
      ),
    );
  }
  _crateOrder(int id) {
    Global.showPayDialog((int payId) async{
      Map<String, dynamic> parm = {
        'id': id,
      };
      String? result = (await DioManager().requestAsync(
          NWMethod.GET, NWApi.crateGameOrder, {"data": jsonEncode(parm)}));
      if (result != null) {
        // print(result);
        Map<String, dynamic> map = jsonDecode(result);
        if(map['crate'] == true && map['id'] != null){
          _postCrateOrder(orderId: map['id'], payId: payId);
        }else if(map['msg'] != null){
          Global.showWebColoredToast(map['msg']);
        }
        Global.getUserInfo();
      }
    });

  }
  _postCrateOrder({required String orderId, required int payId}) async {
    Map<String, dynamic> parm = {
      'order_id': orderId,
      'type': OnlinePay.PAY_ONLINE_GAMES,
      'pid': payId,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.postCrateOrder, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] == 'ok'){
        if(map['url'] != null){
          await Global.reportOpen(Global.REPORT_CASH_IN_GAME);
          launch(map['url']);
        }else{
          Global.getUserInfo();
        }
      }else{
        Global.showWebColoredToast(map['msg']);
      }
    }
  }
  static Future<int> _showDialog(BuildContext context, String title) async{
    TextEditingController textEditingController = TextEditingController();
    int a = 0;
    await showDialog<bool>(
      context: context,
      builder: (_context) {
        return Center(
          child: Container(
            height: 240,
            margin: const EdgeInsets.only(left: 20,right: 20),
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text(title,style: const TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold))),
                Container(
                  margin: const EdgeInsets.only(left: 60,right: 60,top: 20,bottom:20),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    // border: Border.all(color: Colors.grey, width: .5),
                  ),
                  child: Expanded(
                    child: TextField(
                    controller: textEditingController,
                    // style: TextStyle(color: Colors.white38),
                    onEditingComplete: () {
                      Navigator.pop(_context);
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: '请输入划转金额',
                        hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                        // : TextStyle(color: Colors.black26,fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                    ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16))),
                    ),
                    onPressed: () {
                      if(textEditingController.text.isNotEmpty && int.tryParse(textEditingController.text) != null){
                        a = int.parse(textEditingController.text);
                      }
                      Navigator.pop(_context);
                    },
                    child: const Text(
                      '确认',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]
            ),
          ),
        );
      }
    );
    // textEditingController.dispose();
    return a;
  }
  _turnDiamond(BuildContext context) async{
    int b = await _showDialog(context, "钻石余额划转到游戏余额");
    if(b > 0){
      if(b > _user.diamond){
        Global.showWebColoredToast('划转金额不得大于拥有金额，请刷新重试!');
      }else{
          if(await ShowAlertDialogBool(context, '余额划转', '确定划转 ${b}钻石到游戏账号吗？')){
            Map<String, dynamic> parm = {
              'num': b,
            };
            String? result = (await DioManager().requestAsync(
                NWMethod.GET, NWApi.turnDiamondToGame, {"data": jsonEncode(parm)}));
            // print(result);
            if (result == null) {
              return;
            }
            Map<String, dynamic> map = jsonDecode(result);
            if(map == null) return;
            if(map['verify'] != null && map['verify'] == true){
              _getBalance();
              Global.showWebColoredToast('划转成功!');
              await Global.getUserInfo();
            }
            if(map['msg'] != null){
              Global.showWebColoredToast(map['msg']);
            }
          }
      }
    }
  }
  _turnGold(BuildContext context) async{
    int b = await _showDialog(context, "金币余额划转到游戏余额");
    if(b > 0){
      if(b > _user.gold){
        Global.showWebColoredToast('划转金额不得大于拥有金额，请刷新重试!');
      }else{
          if(await ShowAlertDialogBool(context, '余额划转', '确定划转 ${b}金币到游戏账号吗？')){
            Map<String, dynamic> parm = {
              'num': b,
            };
            String? result = (await DioManager().requestAsync(
                NWMethod.GET, NWApi.turnGoldToGame, {"data": jsonEncode(parm)}));
            // print(result);
            if (result == null) {
              return;
            }
            Map<String, dynamic> map = jsonDecode(result);
            if(map == null) return;
            if(map['verify'] != null && map['verify'] == true){
              _getBalance();
              Global.showWebColoredToast('划转成功!');
              await Global.getUserInfo();
            }
            if(map['msg'] != null){
              Global.showWebColoredToast(map['msg']);
            }
          }
      }
    }
  }
  @override
  void dispose() {
    alive = false;
    super.dispose();
  }
}
