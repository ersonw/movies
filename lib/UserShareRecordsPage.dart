import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HttpManager.dart';
import 'UserInfoPage.dart';
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
  List<UserList> _list = [];
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
      List<UserList> list = (map['list'] as List).map((e) => UserList.formJson(e)).toList();
      setState(() {
        if(_page > 1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
  }
  _follow(int index) async{
    UserList user = _list[index];
    Map<String, dynamic> parm = {
      'id': user.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.followUser, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String,dynamic> map = jsonDecode(result);
      if(map['verify'] != null && map['verify'] == true){
        if(user.follow){
          Global.showWebColoredToast('取消关注成功！');
        }else{
          Global.showWebColoredToast('关注成功！');
        }
        setState(() {
          _list[index].follow = !user.follow;
        });
      }else if(map['msg'] != null){
        Global.showWebColoredToast(map['msg']);
      }
    }
  }
  _buildAvatar(String avatar) {
    if ((avatar == null || avatar == '') ||
        avatar.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(avatar);
  }
  Widget _buildListUser(int index){
    UserList userList = _list[index];
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
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context, rootNavigator: true).push<void>(
                      CupertinoPageRoute(
                        // title: "推广分享",
                        // fullscreenDialog: true,
                        builder: (context) => UserInfoPage(uid: userList.id),
                      ),
                    ).then((value) => _init());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 54,
                    height: 54,
                    // margin: EdgeInsets.only(left: vw()),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                        // image: AssetImage('assets/image/default_head.gif'),
                        image: _buildAvatar(userList.avatar),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context, rootNavigator: true).push<void>(
                      CupertinoPageRoute(
                        // title: "推广分享",
                        // fullscreenDialog: true,
                        builder: (context) => UserInfoPage(uid: userList.id),
                      ),
                    ).then((value) => _init());
                  },
                  child: SizedBox(
                    width: ((MediaQuery.of(context).size.width) / 2.5),
                    // height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: ((MediaQuery.of(context).size.width) / 2.5),
                              child: Text(userList.nickname,style: const TextStyle(color: Colors.black,fontSize: 15,overflow: TextOverflow.ellipsis),),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('粉丝：${Global.getNumbersToChinese(userList.fans)}',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                            Text('作品：${Global.getNumbersToChinese(userList.work)}',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            userList.follow ? InkWell(
              onTap: () => setState(() {
                _follow(index);
              }),
              child: Container(
                width: 80,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.done,size: 24,color: Colors.white,),
                    Text('关注',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ],
                ),
              ),
            ) :
            InkWell(
              onTap: () => setState(() {
                _follow(index);
              }),
              child: Container(
                width: 80,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add,size: 24,color: Colors.white,),
                    Text('关注',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ],
                ),
              ),
            ),
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