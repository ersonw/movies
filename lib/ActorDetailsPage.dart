import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HttpManager.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'data/ClassData.dart';
import 'data/SearchActor.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class ActorDetailsPage extends StatefulWidget {
   ActorDetailsPage({Key? key,required this.aid}) : super(key: key);
  int aid;
  @override
  _ActorDetailsPage createState() => _ActorDetailsPage();
}
class _ActorDetailsPage extends State<ActorDetailsPage> with SingleTickerProviderStateMixin{
  late  TabController _innerTabController;
  final ScrollController _scrollController = ScrollController();
  final _tabKey = const ValueKey('tab');
  bool alive = true;
  int page=1;
  int total = 2;
  int type = 0;
  int count =0;
  SearchActor _actor = SearchActor();
  List<ClassData> _list = [];
  void handleTabChange() {
    type = _innerTabController.index;
    page = 1;
    total = 2;
    _initList();
    PageStorage.of(context)?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }
  @override
  void initState() {
    // TODO: implement initState
    _initActor();
    _initList();
    int initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 1);
    _innerTabController.addListener(handleTabChange);
    _scrollController.addListener(() {
      if(alive){
        page++;
        _initList();
      }
    });
    super.initState();
  }
  _initActor() async{
    Map<String, dynamic> parm = {
      'aid': widget.aid,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.Actor, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      setState(() {
        _actor = SearchActor.formJson(jsonDecode(result));
      });
    }
  }
  _initList() async{
    if(page >= total) {
      page--;
      return;
    }
    Map<String, dynamic> parm = {
      'type': type,
      'page': page,
      'aid' : widget.aid,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.ActorVideos, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String,dynamic> map = jsonDecode(result);
      List<ClassData> list = (map['list'] as List).map((e) => ClassData.formJson(e)).toList();
      setState(() {
        total = map['total'];
        count = map['count'];
        if(page>1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
    // page++;
  }
  @override
  Widget build(BuildContext context) {
    if(widget.aid == 0) {
      Navigator.pop(context);
      return Container();
    }
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
      backgroundColor: Colors.black12,
      child: ListView(
        children: [
          Container(
            // margin: const EdgeInsets.all(10),
            width: ((MediaQuery.of(context).size.width) / 1),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30,bottom: 30,left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 63,
                            height: 63,
                            // margin: EdgeInsets.only(left: vw()),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50.0),
                                image: _actor.avatar != null && _actor.avatar.isNotEmpty ? DecorationImage(
                                  // image: AssetImage('assets/image/default_head.gif'),
                                  image: NetworkImage(_actor.avatar),
                                ):null),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Container(
                                  // color: Colors.grey,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: (MediaQuery.of(context).size.width) / 2.5,
                                  child: Text(_actor.name,style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),textAlign: TextAlign.left,),
                                ),
                                Container(
                                  // color: Colors.grey,
                                  width: (MediaQuery.of(context).size.width) / 2.5,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text('三围： ${_actor.measurements}',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      _actor.collect ? InkWell(
                        onTap: () => setState(() {
                          _collect();
                        }),
                        child: Container(
                          width: 63,
                          height: 30,
                          decoration:  BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            border: Border.all(width: 1.0, color: Colors.grey),
                          ),
                          child: const Center(child: Text('收藏',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.center,),),
                        ),
                      ) :
                      InkWell(
                        onTap: () => setState(() {
                          _collect();
                        }),
                        child: Container(
                          width: 63,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            border: Border.all(width: 1.0, color: Colors.yellow),
                          ),
                          child: const Center(child: Text('收藏',style: TextStyle(color: Colors.yellow,fontSize: 12),textAlign: TextAlign.center,),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('相关视频（${Global.getNumbersToChinese(count)}部）',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () =>setState(() {
                                type = 0;
                                _initList();
                            }),
                            child: Text('播放最多',style: TextStyle(color: type==0? Colors.red : Colors.black,fontSize: 15),),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          InkWell(
                            onTap: () =>setState(() {
                              type = 1;
                              _initList();
                            }),
                            child: Text('最近更新',style: TextStyle(color: type==1? Colors.red : Colors.black,fontSize: 15),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _build(),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: _list.length,
                //     itemBuilder: (BuildContext _context, int index) => _buildList(index),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _build(){
    List<Widget> widgets = [];
    for(int i=0;i<_list.length;i++){
      widgets.add(_buildList(i));
    }
    return Column(
      children: widgets,
    );
  }
  _buildList(int index){
    ClassData data = _list[index];
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data.image),
                fit: BoxFit.fill,
              ),
            ),
            child: Global.buildPlayIcon(() {
              Global.playVideo(data.id);
            }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 100,
            width: ((MediaQuery.of(context).size.width) / 2.5),
            // color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: ((MediaQuery.of(context).size.width) / 2.5),
                        child: Text(
                          data.title,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          Global.getNumbersToChinese(data.play),
                          style: const TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        const Text(
                          '播放',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          ImageIcons.remommendIcon.assetName,
                          width: 45,
                          height: 15,
                        ),
                        Text(
                          '${Global.getNumbersToChinese(data.remommends)}人',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _collect() async{
    Map<String, dynamic> parm = {
      'aid': widget.aid,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.collectActor, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String,dynamic> map = jsonDecode(result);
      if(map['verify'] != null && map['verify'] == true){
        if(_actor.collect){
          Global.showWebColoredToast('取消收藏成功！');
        }else{
          Global.showWebColoredToast('收藏成功！');
        }
        setState(() {
          _actor.collect = !_actor.collect;
        });
      }else if(map['msg'] != null){
        Global.showWebColoredToast(map['msg']);
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    alive = false;
    _innerTabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}