import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/ClassData.dart';

import 'HttpManager.dart';
import 'data/ClassTag.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({Key? key}) : super(key: key);

  @override
  _FeaturedPage createState() => _FeaturedPage();

}
class _FeaturedPage extends State<FeaturedPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _first = [];
  int _firstIndex = 0;
  List<ClassTag> _second = [];
  int _secondId = 0;

  List<ClassData> _list = [];
  int page = 1;
  int total = 2;
  @override
  void initState() {
    // TODO: implement initState
    _first.add('最新');
    _first.add('最热');
    _initTags();
    _initLists();
    super.initState();
  }
  _initTags() async{
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.featuredTags, {"data": jsonEncode(parm)}));
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
    if(page >= total) return;
    Map<String, dynamic> parm = {
      'type': _firstIndex,
      'tag': _secondId,
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.featuredLists, {"data": jsonEncode(parm)}));
    print(result);
    if (result != null) {
      List<ClassData> list = (jsonDecode(result)['list'] as List).map((e) => ClassData.formJson(e)).toList();
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
    ClassData data = _list[index];
    return Container();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15,left: 10),
                child: _buildSecond(),
              ),
            ],
          ),

          Container(
          child: Expanded(child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index) => _buildList(index),
          ),
          ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}