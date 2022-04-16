import 'dart:async';
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
  int type = 1;
  int page = 1;
  int total = 1;
  bool loading = true;
  bool alive = true;
  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
    int initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : type);
    _innerTabController.addListener(handleTabChange);
    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        setState(() {
          page++;
        });
        _init();
      }
    });
  }
  void handleTabChange() {
    type = _innerTabController.index;
    setState(() {
      page = 1;
      total = 1;
      _list = [];
    });
    _init();
    PageStorage.of(context)?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }
  _init() async{
    if(page > total) {
      setState(() {
        page--;
      });
      return;
    }
    setState(() {
      loading = true;
    });
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
    if (result == null) {
      return;
    }
    if(alive){
      setState(() {
        loading = false;
      });
    }
    Map<String, dynamic> map = jsonDecode(result);
    total = map['total'] > 0 ? map['total'] : 1;
    List<WolfFriend> list = (map['list'] as List).map((e) => WolfFriend.formJson(e)).toList();
    if(alive){
      setState(() {
        if(page > 1){
          _list.addAll(list);
        }else{
          _list = list;
        }
      });
    }
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
  Future<void> _onRefresh() async {
    setState(() {
      loading = true;
    });
    page = 1;
    _init();
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
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    controller: _controller,
                    children: _buildList(),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    controller: _controller,
                    children: _buildList(),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    controller: _controller,
                    children: _buildList(),
                  ),
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
  List<Widget> _buildList(){
    List<Widget> widgets = [];
    widgets.add(
        Center(child: Container(
          // margin: const EdgeInsets.only(top: 30, bottom: 30),
          child: loading ? Image.asset(ImageIcons.Loading_icon,width: 150,) : Container(),
        ),)
    );
    for(int i=0; i<_list.length; i++){
      widgets.add(_buildListItem(i));
    }
    widgets.add(Center(
      child: page < total ? Image.asset(ImageIcons.Loading_icon,width: 150,) : Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        child: Text(
          _list.length > 2 ? '已经到底了！' : (_list.isEmpty ? '暂时还没有' : ''),
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    ));
    return widgets;
  }
  _buildListItem(int index){
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
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('狼友推荐的第 ',style:  TextStyle(color: Colors.black,fontSize: 13,),),
                      Text('${wolfFriend.id*1}',style: const TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
                      const Text(' 部大片',style:  TextStyle(color: Colors.black,fontSize: 13,),),
                    ]
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('共 ',style:  TextStyle(color: Colors.black,fontSize: 13),),
                    Text('${wolfFriend.recommends * 1}',style: const TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
                    const Text(' 人推荐',style:  TextStyle(color: Colors.black,fontSize: 13,),),
                  ]
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          InkWell(
            onTap: (){
              Global.playVideo(wolfFriend.vid);
            },
            child: Container(
              height: 210,
              margin: const EdgeInsets.only(right: 20,left: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(wolfFriend.image),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              // child: Global.buildPlayIcon((){
              //   Global.playVideo(wolfFriend.vid);
              // }),
            ),
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
    alive = false;
    super.dispose();
  }
}