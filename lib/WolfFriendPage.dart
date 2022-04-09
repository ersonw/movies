import 'dart:convert';

import 'package:movies/UserInfoPage.dart';
import 'package:movies/data/Comment.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/WolfFriend.dart';
import 'package:movies/image_icon.dart';

import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class WolfFriendPage extends StatefulWidget {
  const WolfFriendPage({Key? key}) : super(key: key);

  @override
  _WolfFriendPage createState() => _WolfFriendPage();

}
class _WolfFriendPage extends State<WolfFriendPage>  with SingleTickerProviderStateMixin {
  late  TabController _innerTabController;
  final ScrollController _controller = ScrollController();
  final _tabKey = const ValueKey('tab');
  List<WolfFriend> _list = [];
  int type = 0;
  int page = 0;
  int total = 1;
  String loading = '加载更多!';
  // bool post = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 0);
    _innerTabController.addListener(handleTabChange);
    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        page++;
        _init();
      }
    });
    _init();
  }
  void handleTabChange() {
    type = _innerTabController.index;
    page = 0;
    _init();
    PageStorage.of(context)?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }
  _init() async{
    // if(post) return;
    if(page < total) {
      loading = '加载更多!';
      page++;
      // post = true;
    }else{
      setState(() {
        loading = '我也是有底线的哦!';
      });
      return;
    }
    String ty = '';
    switch(type){
      case 0:
        ty = 'today';
        break;
      case 1:
        ty = 'week';
        break;
      case 2:
        ty = 'all';
        break;
    }
    Map<String, dynamic> parm = {
      'page': page,
      'type': ty,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.recommendVideos, {"data": jsonEncode(parm)}));
    // print(result);
    // post = false;
    if (result == null) {
      return;
    }
    Map<String, dynamic> map = jsonDecode(result);
    total = map['total'] > 0 ? map['total'] : 1;
    List<WolfFriend> list = (map['list'] as List).map((e) => WolfFriend.formJson(e)).toList();
    setState(() {
      if(page > 1){
        _list.addAll(list);
      }else{
        _list = list;
      }
    });
  }
  _favorite(int _index, int index) async{
    WolfFriend wolfFriend = _list[index];
    Comment comment = wolfFriend.comments[_index];
    Map<String, dynamic> parm = {
      'id': comment.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.likeComment, {"data": jsonEncode(parm)}));
    // print(result);
    if (result == null) {
      return;
    }
    Map<String, dynamic> map = jsonDecode(result);
    if(map['verify'] != null && map['verify'] == true){
      if(comment.isLike){
        _list[index].comments[_index].likes--;
        Global.showWebColoredToast('取消点赞成功！');
      }else{
        _list[index].comments[_index].likes++;
        Global.showWebColoredToast('点赞成功！');
      }
      setState(() {
        _list[index].comments[_index].isLike = !comment.isLike;
      });
      // page--;
      // _init();
    }
  }
  _showComments(int index){
    List<Comment> comments = _list[index].comments;
    showCupertinoModalPopup<void>(
        context: context,
        builder: (_context)
    {
      return Container(
        height: 540,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: .5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('全部${comments.length}条评论',style: const TextStyle(color: Colors.black,fontSize: 15),),
                    InkWell(
                      onTap: (){
                        Navigator.pop(_context);
                      },
                      child: const Icon(Icons.clear,size: 30,),
                    ),
                  ],
                ),
              ),
              Expanded(child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (BuildContext __context, int _index){
                  if(index == 0){
                    return _buildCommentItem(comments,_index,index,incisive: true);
                  }else{
                    return _buildCommentItem(comments,_index,index);
                  }
                },
              )),
            ],
          ),
        ),
      );
    },
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      child: Container(
        margin: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 54, right: 54,top: 30),
              child:  TabBar(
                controller: _innerTabController,
                // isScrollable: true,
                labelStyle: const TextStyle(fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.only(right: 0),
                indicatorPadding: const EdgeInsets.only(right: 0),
                labelColor: Colors.red,
                labelPadding: const EdgeInsets.only(left: 0, right: 0),
                unselectedLabelColor: Colors.black,
                indicator: const RoundUnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 9,
                      color: Colors.red,
                    )),
                tabs: const [
                  Tab(
                    text: '今日推荐',
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
            Expanded(child: TabBarView(
                controller: _innerTabController,
                children: [
                  ListView.builder(
                    controller: _controller,
                    itemCount: _list.length+1,
                    itemBuilder: (BuildContext _context, int index) => _buildListItem(index),
                  ),
                  ListView.builder(
                    controller: _controller,
                    itemCount: _list.length+1,
                    itemBuilder: (BuildContext _context, int index) => _buildListItem(index),
                  ),
                  ListView.builder(
                    controller: _controller,
                    itemCount: _list.length+1,
                    itemBuilder: (BuildContext _context, int index) => _buildListItem(index),
                  ),
                ]
            )),
            // Expanded(child: ListView.builder(
            //   controller: _controller,
            //   itemCount: _list.length+1,
            //   itemBuilder: (BuildContext _context, int index) => _buildListItem(index),
            // ),),
          ],
        ),
      ),
    );
  }
  _buildListItem(int index){
    if(index >= _list.length){
      return _list.length > 1 ? Container(
        height: 30,
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loading,style: const TextStyle(color: Colors.grey,fontSize: 20),),
              ],
            )
          ],
        ),
      ) : Container();
    }
    WolfFriend wolfFriend = _list[index];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: .5)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('狼友推荐的第${wolfFriend.id}部大片',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                Text('共${wolfFriend.recommends}人推荐',style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(wolfFriend.image),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            child: Global.buildPlayIcon((){
              Global.playVideo(wolfFriend.vid);
            }),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10,bottom: 10),
            child: _buildSubComment(wolfFriend.comments,index),
          ),
        ],
      ),
    );
  }
  _buildCommentItem(List<Comment> comments, int _index,int index, {bool incisive = false}){
    Comment comment = comments[_index];
    return Container(
      margin: const EdgeInsets.only(top: 5,bottom: 5),
      width: (MediaQuery.of(context).size.width),
      // color: Colors.black54,
      child: Column(
        children: [
          Row(
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
                          builder: (context) => UserInfoPage(uid: comment.uid),
                        ),
                      );
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          image: _buildAvatar(comment.avatar),
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width) / 3,
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(comment.nickname,style: const TextStyle(color: Colors.black,fontSize: 15,overflow: TextOverflow.ellipsis),),
                  ),
                  comment.isFirst ? Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.asset(ImageIcons.icon_isfirst,width: 36,),
                  ) : Container(),
                  incisive ?
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.asset(ImageIcons.icon_incisive,width: 45,),
                  ) : Container(),
                ],
              ),
              InkWell(
                onTap: (){
                  _favorite(_index, index);
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(ImageIcons.icon_community_zan,width: 18,height: 18,color: comment.isLike ? Colors.red : Colors.black45,),
                      Text(Global.getNumbersToChinese(comment.likes),style: const TextStyle(fontSize: 15),),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width) / 1.3,
            child: Text(comment.context,style: const TextStyle(color: Colors.black45,fontSize: 13),),
          ),
        ],
      ),
    );
  }
  _buildSubComment(List<Comment> comments, int index){
    List<Widget> widgets = [];
    if(comments.isNotEmpty){
      widgets.add(_buildCommentItem(comments,0, index,incisive: true));
      if(comments.length > 1) widgets.add(_buildCommentItem(comments,1,index));
      if(comments.length > 2) {
        widgets.add(InkWell(
          onTap: (){
            _showComments(index);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5,bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('查看全部',style: TextStyle(color: Colors.blue,fontSize: 15),),
                Icon(Icons.keyboard_arrow_down_outlined,size: 24,color: Colors.blue,)
              ],
            ),
          ),
        ));
      }
    }
    return Column(children: widgets,);
  }
  _buildAvatar(String avatar) {
    if ((avatar == null || avatar == '') ||
        avatar.contains('http') == false) {
      return const AssetImage(ImageIcons.default_head);
    }
    return NetworkImage(avatar);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}