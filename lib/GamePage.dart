import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePage createState() => _GamePage();

}
class _GamePage extends State<GamePage> {
  double sWith = 0;
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
          Center(child: Text('游戏大厅',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: ((MediaQuery.of(context).size.width) / 1),
            height: 100,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/balanceCard.png'),
                )),
            child: Column(
              children: [
                Container(
                  child: Text('钱包余额',style: TextStyle(color: Colors.white54,fontSize: 12)),
                  margin: const EdgeInsets.only(left: 20,top: 20,),
                  width: ((MediaQuery.of(context).size.width) / 1),
                ),
                Container(
                  child: Text('0',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
                  margin: const EdgeInsets.only(left: 20,top: 20,),
                  width: ((MediaQuery.of(context).size.width) / 1),
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/recharge.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ((MediaQuery.of(context).size.width) / 4.5),
                          child: Text('充值',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/tixian.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ((MediaQuery.of(context).size.width) / 4.5),
                          child: Text('提现',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/game_home.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ((MediaQuery.of(context).size.width) / 4.5),
                          child: Text('进入大厅',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/activity.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ((MediaQuery.of(context).size.width) / 4.5),
                          child: Text('活动',style: TextStyle(color: Colors.black54,fontSize: 13),textAlign: TextAlign.center,),
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
            margin: EdgeInsets.only(left: 5,),
            child: Text('更多游戏',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
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
   for (int i = 0; i < 10; i++){
     widgets.add(_buildRow());
   }
   return Container(
     child: Column(children: widgets,),
     margin: const EdgeInsets.only(left: 5,right: 5,),
   );
  }
  _buildRow(){
    List<Widget> widgets = [];
    widgets.add(_buildItem());
    widgets.add(_buildItem());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
  _buildItem(){
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
                  image: AssetImage('assets/images/2renmajiang.jpg'),
                )),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          SizedBox(
            width: sWith / 2.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('二人麻将',style: TextStyle(fontSize: 15,color: Colors.black)),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          // Colors.redAccent,
                          Color(0xFFFCEAB2),
                          Color(0xfffbad3e),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                        borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      child: Text('马上开始',style: TextStyle(fontSize: 15,color: Color(0xff903600))),
                      margin: const EdgeInsets.only(top:2,bottom:2,left: 6,right: 6),
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