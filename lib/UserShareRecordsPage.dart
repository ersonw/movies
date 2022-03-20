import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HttpManager.dart';
import 'UserInfoPage.dart';
import 'data/ShareRecord.dart';
import 'data/UserList.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class UserShareRecordsPage extends StatefulWidget {
  const UserShareRecordsPage({Key? key}) : super(key: key);

  @override
  _UserShareRecordsPage createState() => _UserShareRecordsPage();

}
class _UserShareRecordsPage extends State<UserShareRecordsPage>{
  final ScrollController _controller = ScrollController();
  int _page = 1;
  int total = 1;
  List<ShareRecord> _list = [];
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
        NWMethod.GET, NWApi.shareRecords, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['total'] != null) total = map['total'];
      List<ShareRecord> list = (map['list'] as List).map((e) => ShareRecord.formJson(e)).toList();
      setState(() {
        if(_page > 1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
  }
  Widget _buildListUser(int index){
    ShareRecord record = _list[index];
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 5),
      child: Container(
        margin: const EdgeInsets.all(5),
        width: ((MediaQuery.of(context).size.width) / 1),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).push<void>(
                        CupertinoPageRoute(
                          // title: "推广分享",
                          // fullscreenDialog: true,
                          builder: (context) => UserInfoPage(uid: record.uid),
                        ),
                      ).then((value) => _init());
                    },
                    child: SizedBox(
                      width: ((MediaQuery.of(context).size.width) / 3.4),
                      child: Text(record.nickname,style: const TextStyle(color: Colors.amber,fontSize: 15,overflow: TextOverflow.ellipsis),),
                    ),
                ),
                SizedBox(
                  width: ((MediaQuery.of(context).size.width) / 2),
                  child: Text(record.reason,style: const TextStyle(color: Colors.black,fontSize: 15),),
                ),
              ],
            ),
            record.status == 1 ? Container(
              width: 63,
              height: 30,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: const Center(child: Text('审核通过',style: TextStyle(color: Colors.green,fontSize: 12),textAlign: TextAlign.center,),),
            ) : (record.status == 0 ?
            Container(
              width: 63,
              height: 30,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.grey),
              ),
              child: const Center(child: Text('审核中',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.center,),),
            ) :
            Container(
              width: 63,
              height: 30,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.red),
              ),
              child: const Center(child: Text('审核失败',style: TextStyle(color: Colors.red,fontSize: 12),textAlign: TextAlign.center,),),
            )),
          ],
        ),
      ),

    );
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: Colors.black12,
      child: ListView.builder(
        controller: _controller,
        itemCount: _list.length,
        itemBuilder: (BuildContext _context, int index) => _buildListUser(index),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}