import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/ActorDetailsPage.dart';
import 'package:movies/data/ClassData.dart';

import 'HttpManager.dart';
import 'data/ClassTag.dart';
import 'data/SearchActor.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class ActorPage extends StatefulWidget {
  const ActorPage({Key? key}) : super(key: key);

  @override
  _ActorPage createState() => _ActorPage();

}
class _ActorPage extends State<ActorPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _first = [];
  int _firstIndex = 0;
  List<ClassTag> _second = [];
  int _secondId = 0;

  List<SearchActor> _list = [];
  int page = 1;
  int total = 2;
  @override
  void initState() {
    // TODO: implement initState
    _first.add('全部');
    _first.add('人气');
    _first.add('片源数量');
    _initTags();
    _initLists();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        _initLists();
      }
    });
  }
  _initTags() async{
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.measurementTags, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      _second = [];
      ClassTag classTag = ClassTag();
      classTag.title = '全部';
      _second.add(classTag);
      List<ClassTag> second = (jsonDecode(result)['list'] as List).map((e) => ClassTag.formJson(e)).toList();
      setState(() {
        _second.addAll(second);
      });
    }
  }
  _initLists() async{
    if(page >= total) {
      page--;
      return;
    }
    Map<String, dynamic> parm = {
      'type': _firstIndex,
      'tag': _secondId,
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.ActorLists, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      List<SearchActor> list = (jsonDecode(result)['list'] as List).map((e) => SearchActor.formJson(e)).toList();
      setState(() {
        if(page>1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
    // page++;
  }
  Widget _buildFirst() {
    List<Widget> widgets = [];
    for (int i = 0; i < _first.length; i++) {
      widgets.add(InkWell(
        onTap: () => setState(() {
          _firstIndex = i;
          page = 1;
          total = 2;
          _initLists();
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _firstIndex == i ? Colors.yellow : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            // color: Colors.black,
            margin:
            const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              _first[i],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }
  Widget _buildSecond() {
    List<Widget> widgets = [];
    for (int i = 0; i < _second.length; i++) {
      ClassTag tag = _second[i];
      widgets.add(InkWell(
        onTap: () => setState(() {
          _secondId = tag.id;
          page = 1;
          total = 2;
          _initLists();
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _secondId == tag.id ? Colors.yellow : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            margin:
            const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              tag.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }
  Widget _buildList(int index){
    List<Widget> widgets = [];
    if((index * 4) < _list.length){
      widgets.add(_buildListItem(_list[(index * 4)]));
    }
    if((index * 4)+1 < _list.length){
      widgets.add(_buildListItem(_list[(index * 4)+1]));
    }
    if((index * 4)+2 < _list.length){
      widgets.add(_buildListItem(_list[(index * 4)+2]));
    }
    if((index * 4)+3 < _list.length){
      widgets.add(_buildListItem(_list[(index * 4)+3]));
    }
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: widgets,
      ),
    );
  }
  Widget _buildListItem(SearchActor data){

    return InkWell(
      onTap: (){
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            title: '演员详情',
            // fullscreenDialog: true,
            builder: (context) =>  ActorDetailsPage(aid: data.id),
          ),
        );
      },
      child: Container(
        width: ((MediaQuery.of(context).size.width) / 4.5),
        margin: const EdgeInsets.only(left: 5,top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 63,
              height: 63,
              // margin: EdgeInsets.only(left: vw()),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50.0),
                  image: DecorationImage(
                    // image: AssetImage('assets/image/default_head.gif'),
                    image: NetworkImage(data.avatar),
                  )),
            ),
            SizedBox(
              width: ((MediaQuery.of(context).size.width) / 4.2),
              child: Text(data.name,style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
  _listViewbuilder(){
    List<Widget> widgets = [];
    for(int i=0;i< (_list.length/4)+1;i++){
      widgets.add(_buildList(i));
    }
    return Column(
      children: widgets,
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      // child: Expanded(
      //   child: ListView(
        child: Column(
          // controller: _scrollController,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15,left: 10,top: 10),
                  child: _buildFirst(),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15,left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: _buildSecond(),flex: 1,)
                ],
              ),
            ),
            // _listViewbuilder(),
            Expanded(
              flex: 9,
              child: ListView.builder(
              itemBuilder: (BuildContext _context,int index) => _buildList(index),
              itemCount: (_list.length ~/ 4)+1,
            ),
            ),
          ],
        ),
      // ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}