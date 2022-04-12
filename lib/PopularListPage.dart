import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/ClassData.dart';
import 'package:movies/image_icon.dart';

import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'global.dart';
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
    _initList();
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
  _buildNumber(int index){
    switch(index){
      case 0:
        return Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageIcons.icon_rank_1),
            )
          ),
        );
      case 1:
        return Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageIcons.icon_rank_2),
            )
          ),
        );
      case 2:
        return Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageIcons.icon_rank_3),
            )
          ),
        );
      default:
        return SizedBox(
          height: 30,
          width: 30,
          child: Text('${index+1}',style: const TextStyle(fontSize: 30),),
        );
    }
  }
  _buildList(int index){
    ClassData data = _list[index];
    return InkWell(
      onTap: () {
        Global.playVideo(data.id);
      },
      child: Row(
        children: [
          _buildNumber(index),
          Container(
            width: 150,
            height: 100,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: NetworkImage(data.image),
                fit: BoxFit.fill,
              ),
            ),
            // child: Global.buildPlayIcon(() {
            //   Global.playVideo(data.id);
            // }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5),
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
                        height: 80,
                        child: Text(
                          data.title,
                          style: const TextStyle(fontSize: 15,overflow: TextOverflow.clip),
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
                          ImageIcons.icon_recommend,
                          // width: 45,
                          height: 20,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 5)),
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
  @override
  void dispose() {
    // TODO: implement dispose
    _innerTabController.dispose();
    super.dispose();
  }
}