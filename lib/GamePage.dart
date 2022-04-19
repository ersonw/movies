import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/WithdrawalGamePage.dart';
import 'package:movies/WithdrawalManagementPage.dart';
import 'package:path/path.dart';

import 'CashInGamePage.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'SlideRightRoute.dart';
import 'YYMarquee.dart';
import 'data/Game.dart';
import 'data/OnlinePay.dart';
import 'data/Trumpet.dart';
import 'data/User.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePage createState() => _GamePage();

}
class _GamePage extends State<GamePage> with SingleTickerProviderStateMixin{
  double sWith = 0;
  List<Game> _list = [];
  List<Game> _records = [];
  List<Trumpet> _trumpets = [];
  double gameBalance = 0;
  late AnimationController controller;
  bool _refresh = false;
  bool alive = true;
  User _user = userModel.user;
  bool loading = true;

  @override
  void initState() {
    _getBalance();
    _initGame();
    _initRecords();
    _trumpet();
    super.initState();
    controller = AnimationController(duration: const Duration(seconds:2), vsync:  this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        controller.reset();
      }
    });
    userModel.addListener(() {
      if(alive){
        _user = userModel.user;
      }
    });
  }
  void _trumpet()async{
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getTrumpets, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      setState(() {
        _trumpets = (jsonDecode(result)['list'] as List).map((e) => Trumpet.formJson(e)).toList();
      });
    }
  }
  void _initGame()async{
    setState(() {
      loading = true;
    });
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getGames, {"data": jsonEncode(parm)}));
    if (result != null) {
     setState(() {
       _list = (jsonDecode(result)['list'] as List).map((e) => Game.formJson(e)).toList();
     });
    }
    setState(() {
      loading = false;
    });
  }
  void _initRecords()async{
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getRecords, {"data": jsonEncode(parm)}));
    if (result != null) {
     setState(() {
       _records = (jsonDecode(result)['list'] as List).map((e) => Game.formJson(e)).toList();
     });
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
  void _entherGame(int id) async {
    Map<String, dynamic> parm = {
      'id': id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.enterGame, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null) {
        if(map['url'] != null) {
          await Global.reportOpen(Global.REPORT_PLAYER_GAME);
          Global.openH5Game(map['url']).then((value) {
            _getBalance();
            _initRecords();
          });
        }
        if(map['msg'] != null) {
          Global.showWebColoredToast(map['msg']);
        }
      }
    }
  }
  Widget _marqueeview() {
    List<Widget> widgets = [];
    for(int i=0;i< _trumpets.length; i++){
      Trumpet trumpet = _trumpets[i];
      widgets.add(Text(
        trumpet.text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFFEE8E2B),
        ),
      ),);
    }
    return Container(
      // margin: EdgeInsets.only(left: 15, right: 15),
      height: 31,
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Center(
              child: Icon(Icons.campaign,size: 20),
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: YYMarquee(
                  stepOffset: 200.0,
                  duration: const Duration(seconds: 5),
                  paddingLeft: 50.0,
                  children: widgets,
                ),
              )),
        ],
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E6),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    sWith = ((MediaQuery.of(context).size.width) / 1);
    return Scaffold(
      // appBar: AppBar(title: Text('游戏大厅'),),
      // floatingActionButton: ,
      // floatingActionButtonAnimator: FloatingActionButtonAnimation,
      // backgroundColor: Colors.white10,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              const Center(child: Text('游戏大厅',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
              // const Padding(padding: EdgeInsets.only(top: 20)),
              _trumpets.isNotEmpty ? _marqueeview():Container(),
              Expanded(
                child: ListView(
                  children: [
                    // const Padding(padding: EdgeInsets.only(top:30)),
                    // const Padding(padding: EdgeInsets.only(top: 20)),
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
                                _refresh ?  Container(
                                  child:  const Icon(Icons.refresh_outlined, size: 20,color: Colors.white),
                                  margin: const EdgeInsets.only(left: 5,top: 22,),
                                )
                                    : InkWell(
                                  child: Container(
                                    child:  const Icon(Icons.refresh_outlined, size: 20,color: Colors.white),
                                    margin: const EdgeInsets.only(left: 5,top: 22,),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      _refresh = true;
                                    });
                                    _getBalance();
                                  },
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      margin: const EdgeInsets.only(left: 5,right: 5,),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(Global.MainContext, SlideRightRoute(page: const CashInGamePage())).then((value) => setState(() {Global.getUserInfo();})).then((value) => _getBalance());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10,),
                              width: ((MediaQuery.of(context).size.width) / 4.8),
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
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/recharge.png'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ((MediaQuery.of(context).size.width) / 4.5),
                                      child: const Text('充值',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 5)),
                                  ]
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(Global.MainContext, SlideRightRoute(page: WithdrawalManagementPage(type: WithdrawalManagementPage.WITHDRAWAL_GAME))).then((value) => setState(() {Global.getUserInfo();})).then((value) => _getBalance());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10,),
                              width: ((MediaQuery.of(context).size.width) / 4.8),
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
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/tixian.png'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ((MediaQuery.of(context).size.width) / 4.5),
                                      child: const Text('提现',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 5)),
                                  ]
                              ),
                            ),
                          ),
                          InkWell(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10,),
                                width: ((MediaQuery.of(context).size.width) / 4.8),
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
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/images/game_home.png'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: ((MediaQuery.of(context).size.width) / 4.5),
                                        child: const Text('进入大厅',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
                                      ),
                                      const Padding(padding: EdgeInsets.only(top: 5)),
                                    ]
                                ),
                              ),
                              onTap: (){
                                _entherGame(0);
                              }
                          ),
                          InkWell(
                            onTap: (){
                              Global.openWebview(configModel.config.activityUrl, inline: true);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10,),
                              width: ((MediaQuery.of(context).size.width) / 4.8),
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
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/activity.png'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ((MediaQuery.of(context).size.width) / 4.5),
                                      child: const Text('活动',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 5)),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _records.isNotEmpty ? Container(
                      margin: const EdgeInsets.only(left: 5,),
                      child: const Text('最近玩过',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                    ) : Container(),
                    // const Padding(padding: EdgeInsets.only(top: 10)),
                    _buildRecords(),
                    Container(
                      margin: const EdgeInsets.only(left: 5,),
                      child: const Text('全部游戏',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                    ),
                    Center(child: Container(
                      // margin: const EdgeInsets.only(top: 30, bottom: 30),
                      child: loading ? Image.asset(ImageIcons.Loading_icon,width: 150,) : Container(),
                    ),),
                    _buildMore(),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                  ],
                ),
              ),
            ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20,bottom: 20),
                  child: InkWell(
                    onTap: () {
                      Global.toChat();
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        // color: Colors.blueAccent,
                        image: DecorationImage(
                          image: AssetImage(ImageIcons.kefu),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      // child: Container(
                      //   alignment: Alignment.center,
                      //   child: const Text('客服', textAlign: TextAlign.center)
                      // ),
                    ),
                  ),
                ),
              ]
          ),
        ],
      )

    );
  }
  _buildMore(){
   List<Widget> widgets = [];
   for (int i = 0; i < (_list.length /2) + 1; i++){
     widgets.add(_buildRow(i));
   }
   return Container(
     child: Column(children: widgets,),
     margin: const EdgeInsets.only(left: 5,right: 5,),
   );
  }
  _buildRecords(){
   List<Widget> widgets = [];
   for (int i = 0; i < (_records.length /2) + 1; i++){
     widgets.add(_buildRecordsRow(i));
   }
   return Container(
     child: Column(children: widgets,),
     margin: const EdgeInsets.only(left: 5,right: 5,),
   );
  }
  _buildRecordsRow(int index){
    List<Widget> widgets = [];
    if(index*2 < _records.length) widgets.add(_buildItem(_records[index*2]));
    if(index*2+1 < _records.length) widgets.add(_buildItem(_records[index*2+1]));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
  _buildRow(int index){
    List<Widget> widgets = [];
    if(index*2 < _list.length) widgets.add(_buildItem(_list[index*2]));
    if(index*2+1 < _list.length) widgets.add(_buildItem(_list[index*2+1]));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
  _buildImage(String image){
    if(image != null){
      if(image.startsWith('http')){
        return NetworkImage(image);
      }
      return AssetImage('assets/images/$image');
    }
    return const AssetImage('assets/images/balanceCard.png');
  }
  _buildItem(Game game){
    return Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 5)),
          Container(
            width: sWith / 2.1,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: _buildImage(game.image),
                )),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          SizedBox(
            width: sWith / 2.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: sWith / 4.4,
                  child: Text(game.name,style: const TextStyle(fontSize: 15,color: Colors.black, overflow: TextOverflow.ellipsis)),
                ),
                InkWell(
                  onTap: () => _entherGame(game.id),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          // Colors.redAccent,
                          Color(0xFFFCEAB2),
                          Color(0xfffbad3e),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                        borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10, //阴影范围
                          spreadRadius: 0.1, //阴影浓度
                          color: Colors.grey.withOpacity(0.2), //阴影颜色
                        ),
                      ],
                    ),
                    child: Container(
                      child: const Text('马上开始',style: TextStyle(fontSize: 15,color: Color(0xff903600))),
                      margin: const EdgeInsets.only(top:1,bottom:1,left: 9,right: 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
        ]
    );
  }
}