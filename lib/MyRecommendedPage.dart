import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/ClassData.dart';

import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'data/Recommend.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class MyRecommendedPage extends StatefulWidget {
  const MyRecommendedPage({Key? key}) : super(key: key);

  @override
  _MyRecommendedPage createState() => _MyRecommendedPage();
}
class _MyRecommendedPage extends State<MyRecommendedPage> {
  final ScrollController _controller = ScrollController();
  int _page = 1;
  int total = 1;
  List<Recommend> _list = [];
  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        _page++;
        _init();
      }
    });
  }
  _init()async{
    if(_page > total){
      _page--;
      return;
    }
    Map<String, dynamic> parm = {
      'page': _page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.RecommendRecords, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['total'] != null) total = map['total'];
      List<Recommend> list = (map['list'] as List).map((e) => Recommend.formJson(e)).toList();
      setState(() {
        if(_page > 1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
  }
  Widget _buildVideoItem(int index){
    Recommend recommend = _list[index];
    ClassData data = recommend.data;
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ((MediaQuery.of(context).size.width) / 2.2),
                  // width: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(data.image),
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                  ),
                  child: Global.buildPlayIcon(() {
                    Global.playVideo(data.id);
                  }),
                ),
                SizedBox(
                  width: ((MediaQuery.of(context).size.width) / 2.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width) / 2.2),
                            child: Text(
                              data.title.length > 30 ? '${data.title.substring(0,30)}...' : data.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
                                ImageIcons.remommendIcon,
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
          ),
          Container(
            // color: Colors.black12,
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('推荐理由：',style: TextStyle(color: Colors.red,fontSize: 12),),
                SizedBox(
                  width: ((MediaQuery.of(context).size.width) / 1.3),
                  child: Text(recommend.reason.length > 40 ? '${recommend.reason.substring(0,40)}...': recommend.reason,style: const TextStyle(color: Colors.black,fontSize: 15),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: Colors.black12,
      child: ListView.builder(
        controller: _controller,
        itemCount: _list.length,
        itemBuilder: (BuildContext _context, int index) => _buildVideoItem(index),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}