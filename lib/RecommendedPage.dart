import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/PlayerPage.dart';
import 'package:movies/data/Player.dart';
import 'package:movies/image_icon.dart';
import 'package:movies/utils/JhPickerTool.dart';

import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'data/Recommended.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  _RecommendedPage createState() => _RecommendedPage();
}

class _RecommendedPage extends State<RecommendedPage> {
  List<Recommended> _recommendeds = [];
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _getDate();
    super.initState();
    _init();
  }
  _getDate(){
    return '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}';
  }
  _init()async{
    Map<String, dynamic> parm = {
      'date': _getDate(),
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.Recommends, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      List<Recommended> list = (map['list'] as List).map((e) => Recommended.formJson(e)).toList();
      setState(() {
        _recommendeds = list;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTabController(
          length: 1,
          child: _buildBody(context)),
    );
  }
  _buildTitle(Recommended recommended){
    String title =  recommended.title == null || recommended.title.isEmpty ? recommended.video.title : recommended.title;
    if(title.length > 30){
      return title.substring(0,30);
    }
    return title;
  }
  Widget _buildItem(BuildContext context, int index){
    Recommended recommended = _recommendeds[index];
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1.0, color: Colors.black12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(index == 0 ? ImageIcons.top1Bg : ImageIcons.nomalBg),
                alignment: Alignment.topLeft,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    '${index == 0 ? 'TOP':'至臻'}.${index +1}',
                    style:  const TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildPlay(recommended)
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              height: 47,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageIcons.reason),
                  alignment: Alignment.topLeft,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 50),
                    width: (MediaQuery.of(context).size.width) / 1.6,
                    child: Text(_buildTitle(recommended),
                      style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),
                  )
                ],
              )
          ),
          InkWell(
            onTap: (){
              Global.playVideo(recommended.video.id);
            },
            child: Column(
                children: [
                  Container(
                    width: 350,
                    height: 200,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(recommended.video.image),
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  recommended.video.actor != null && recommended.video.actor.name != null && recommended.video.actor.name.isNotEmpty ?
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text('主演：${recommended.video.actor.name}')
                      ],
                    ),
                  ) : Container(),
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('搞笑指数',style:  TextStyle(fontSize: 15),),
                            _buildStar(recommended.funny),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('热门指数',style: TextStyle(fontSize: 15),),
                            _buildStar(recommended.hot),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('颜值指数',style: TextStyle(fontSize: 15),),
                            _buildStar(recommended.face),
                          ],
                        ),
                        Container(),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
  _buildBody(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   margin: const EdgeInsets.only(left: 54, right: 54,top: 30),
        //   child: const TabBar(
        //     // isScrollable: true,
        //     labelStyle: TextStyle(fontSize: 18),
        //     unselectedLabelStyle: TextStyle(fontSize: 15),
        //     padding: EdgeInsets.only(right: 0),
        //     indicatorPadding: EdgeInsets.only(right: 0),
        //     labelColor: Colors.red,
        //     labelPadding: EdgeInsets.only(left: 0, right: 0),
        //     unselectedLabelColor: Colors.black,
        //     indicator: RoundUnderlineTabIndicator(
        //         borderSide: BorderSide(
        //           width: 9,
        //           color: Colors.red,
        //         )),
        //     tabs: [
        //       Tab(
        //         text: '今日推荐',
        //       ),
        //       Tab(
        //         text: '制片厂',
        //       ),
        //     ],
        //   ),
        // ),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Expanded(child: TabBarView(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                const Text(
                                  '今日推荐',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: (){
                                    JhPickerTool.showDatePicker(context, dateType: DateType.YMD, value: _dateTime,maxValue: DateTime.now(), clickCallBack: (t,p) {
                                      if(_dateTime.millisecondsSinceEpoch == p) return;
                                      setState(() {
                                        _dateTime = DateTime.fromMillisecondsSinceEpoch(p);
                                      });
                                      _init();
                                    });
                                  },
                                  child: Text(_getDate(),style: const TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: const Text('资深编辑，一生心血！每日精选推荐！经典必藏！'),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: _buildItem,
                                itemCount: _recommendeds.length,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              // const Text("暂未开放"),
            ])),
      ],
    );
  }
  _buildPlay(Recommended recommended){
    int diamond = recommended.video.diamond;
    if(diamond == 0) {
      return InkWell(
          onTap: (){
            if(userModel.user.expired > DateTime.now().millisecondsSinceEpoch){
              Global.playVideo(recommended.video.id);
            }else{
              Player player = Player();
              player.id = recommended.video.id;
              player.title = recommended.video.title;
              player.pic = recommended.video.image;
              Global.showDialogVideo(player);
            }
          },
          child: Container(
            width: 100,
            height: 30,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(20)),
              border:
              Border.all(width: 1.0, color: Colors.red),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Image.asset(
                    ImageIcons.share,
                    width: 15,
                  ),
                  const Text(
                    '无限观看',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          )
      );
    }
    return InkWell(
      onTap: (){
        Global.playVideo(recommended.video.id);
      },
      child: Container(
        width: 100,
        height: 30,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1.0, color: Colors.orange),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 10),

          child: Row(
            children: [
              Image.asset(ImageIcons.diamond,width: 15,),
              Text('$diamond钻石',style: const TextStyle(color: Colors.orange),),
            ],
          ),
        ),
      ),
    );
  }
  _buildStar(double m){
    if(m > 5) m = 5;
    int ii = m.toInt();
    if(ii < m){
      ii++;
    }
    List<Widget> widget = [];
    for(int i=1;i< (ii+1);i++){
      if(i < m || i == m){
        widget.add(Image.asset(ImageIcons.star,width: 15,));
      }else {
        widget.add(Image.asset(ImageIcons.star_half,width: 15,));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget,
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
