import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/ClassData.dart';

import 'HttpManager.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class VideoRecordsPage extends StatefulWidget {
  const VideoRecordsPage({Key? key}) : super(key: key);

  @override
  _VideoRecordsPage createState() => _VideoRecordsPage();
}
class _VideoRecordsPage extends State<VideoRecordsPage> {
  final ScrollController _controller = ScrollController();
  int _page = 1;
  int total = 1;
  List<ClassData> _list = [];
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
        NWMethod.GET, NWApi.VideoRecords, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['total'] != null) total = map['total'];
      List<ClassData> list = (map['list'] as List).map((e) => ClassData.formJson(e)).toList();
      setState(() {
        if(_page > 1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: ListView.builder(
        controller: _controller,
        itemCount: _list.length,
        itemBuilder: (BuildContext _context, int index) => _buildClassSingleItem(index),
      ),
    );
  }
  _buildClassSingleItem(int index) {
    ClassData classData = _list[index];
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          Container(
            width: ((MediaQuery.of(context).size.width) / 1),
            height: 210,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(classData.image),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            child: Global.buildPlayIcon(() {
              Global.playVideo(classData.id);
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: ((MediaQuery.of(context).size.width) / 1.1),
                child: Text(
                  classData.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                width: ((MediaQuery.of(context).size.width) / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '主演:${classData.actor.name.isNotEmpty ? classData.actor.name : '无'}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '${Global.getNumbersToChinese(classData.play)}次播放',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                width: ((MediaQuery.of(context).size.width) / 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      ImageIcons.remommendIcon.assetName,
                      width: 45,
                      height: 15,
                    ),
                    Text(
                      '${Global.getNumbersToChinese(classData.remommends)}人',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
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