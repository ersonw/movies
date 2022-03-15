import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/ClassData.dart';

import 'HttpManager.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class PopularListPage extends StatefulWidget{
  const PopularListPage({Key? key}) : super(key: key);

  @override
  _PopularListPage createState() => _PopularListPage();
}
class _PopularListPage extends State<PopularListPage>  with SingleTickerProviderStateMixin {
  late  TabController _innerTabController;
  final _tabKey = const ValueKey('tab');
  int type = 0;
  List<ClassData> _list = [];
  void handleTabChange() {
    type = _innerTabController.index;
    _initList();
    PageStorage.of(context)?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }
  @override
  void initState() {
    // TODO: implement initState
    int initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 0);
    _innerTabController.addListener(handleTabChange);
    super.initState();
  }
  _initList()async{
    Map<String, dynamic> parm = {
      'type': type,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.PopularList, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
    List<ClassData> list = (jsonDecode(result)['list'] as List).map((e) => ClassData.formJson(e)).toList();
    setState(() {
      _list = list;
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 90, right: 90),
            child:  TabBar(
              controller: _innerTabController,
              labelStyle: const TextStyle(fontSize: 20),
              labelColor: Colors.red,
              labelPadding: const EdgeInsets.only(left: 0, right: 0),
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: const TextStyle(fontSize: 15),
              indicator: const RoundUnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 9,
                    color: Colors.red,
                  )),
              tabs: const [
                Tab(
                  text: '日榜',
                ),
                Tab(
                  text: '周榜',
                ),
                Tab(
                  text: '总榜',
                ),
              ],
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: _innerTabController,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (BuildContext _context,int index) => _buildList(index),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (BuildContext _context,int index) => _buildList(index),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (BuildContext _context,int index) => _buildList(index),
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
  _buildNumber(int index){}
  _buildList(int index){
    return Container();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _innerTabController.dispose();
    super.dispose();
  }
}