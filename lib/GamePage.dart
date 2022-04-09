import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'HttpManager.dart';
import 'data/Game.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePage createState() => _GamePage();

}
class _GamePage extends State<GamePage> {
  double sWith = 0;
  List<Game> _list = [];
  double gameBalance = 0;
  @override
  void initState() {
    _getBalance();
    _initGame();
    super.initState();
  }
  void _initGame()async{
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getGames, {"data": jsonEncode(parm)}));
    if (result != null) {
     setState(() {
       _list = (jsonDecode(result)['list'] as List).map((e) => Game.formJson(e)).toList();
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
          Global.openH5Game(map['url']).then((value) => _getBalance());
        }
        if(map['msg'] != null) {
          Global.showWebColoredToast(map['msg']);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    sWith = ((MediaQuery.of(context).size.width) / 1);
    return Scaffold(
      // appBar: AppBar(title: Text('游戏大厅'),),
      // floatingActionButton: ,
      // floatingActionButtonAnimator: FloatingActionButtonAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: ListView(
        children: [
          // const Padding(padding: EdgeInsets.only(top:30)),
          Center(child: Text('游戏大厅',style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
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
                    InkWell(
                      child: Container(
                        child:  Icon(Icons.refresh_outlined, size: 20,color: Colors.white),
                        margin: const EdgeInsets.only(left: 5,top: 22,),
                      ),
                      onTap: (){
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
                Container(
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
                Container(
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
                Container(
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
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            margin: const EdgeInsets.only(left: 5,),
            child: const Text('更多游戏',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
          ),
          // const Padding(padding: EdgeInsets.only(top: 10)),
          _buildMore(),
          const Padding(padding: EdgeInsets.only(top: 30)),
        ],
      ),
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