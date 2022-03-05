import 'package:movies/UserInfoPage.dart';
import 'package:movies/data/Comment.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/image_icon.dart';

import 'RoundUnderlineTabIndicator.dart';
import 'global.dart';

class WolfFriendPage extends StatefulWidget {
  const WolfFriendPage({Key? key}) : super(key: key);

  @override
  _WolfFriendPage createState() => _WolfFriendPage();

}
class _WolfFriendPage extends State<WolfFriendPage>{
  List<Comment> _comments = [];
  @override
  void initState() {
    // TODO: implement initState
    Comment comment = Comment();
    comment.avatar = 'http://github1.oss-cn-hongkong.aliyuncs.com/a8ac8dbc-47bc-423b-b881-b30583fb1042.png';
    comment.likes = 1024;
    comment.context = '工会主席的讲话精神是重要的是的风格不同的时候就可以吗';
    comment.nickname = '好久不见';
    _comments.add(comment);
    comment = Comment();
    comment.isFirst = true;
    comment.avatar = 'http://github1.oss-cn-hongkong.aliyuncs.com/2942af7c-5541-418e-a9e5-baed6d301158.png';
    comment.likes = 1024;
    comment.context = '好看';
    comment.nickname = 'CC';
    _comments.add(comment);
    _comments.add(comment);
    super.initState();
  }
  _showComments(List<Comment> comments){
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
                itemBuilder: (BuildContext __context, int index){
                  if(index == 0){
                    return _buildCommentItem(comments[index],incisive: true);
                  }else{
                    return _buildCommentItem(comments[index]);
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
      child: DefaultTabController(
        length: 3,
        child: Container(
          margin: const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 54, right: 54,top: 30),
                child: const TabBar(
                  // isScrollable: true,
                  labelStyle: TextStyle(fontSize: 18),
                  unselectedLabelStyle: TextStyle(fontSize: 15),
                  padding: EdgeInsets.only(right: 0),
                  indicatorPadding: EdgeInsets.only(right: 0),
                  labelColor: Colors.red,
                  labelPadding: EdgeInsets.only(left: 0, right: 0),
                  unselectedLabelColor: Colors.black,
                  indicator: RoundUnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 9,
                        color: Colors.red,
                      )),
                  tabs: [
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
                  children: [
                    Column(
                      children: [
                        Container(
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
                                    Text('狼友推荐的第79部大片',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text('共1623人推荐',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                              Container(
                                height: 240,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                child: Global.buildPlayIcon((){
                                  Global.playVideo(0);
                                }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10,bottom: 10),
                                child: _buildSubComment(_comments),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(),
                    Container(),
                  ]
              )),
            ],
          ),
        ),
      ),
    );
  }
  _buildCommentItem(Comment comment, {bool incisive = false}){
    return Container(
      margin: const EdgeInsets.only(top: 5,bottom: 5),
      width: (MediaQuery.of(context).size.width),
      // color: Colors.black54,
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
                      builder: (context) => UserInfoPage(uid: comment.uid),
                    ),
                  );
                },
                child: Container(
                  height: 36,
                  width: 36,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                child: Text(comment.nickname+comment.nickname+comment.nickname,style: const TextStyle(color: Colors.black,fontSize: 15,overflow: TextOverflow.ellipsis),),
              ),
              comment.isFirst ? Container(
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(ImageIcons.icon_isfirst.assetName,width: 36,),
              ) : Container(),
              incisive ?
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(ImageIcons.icon_incisive.assetName,width: 45,),
              ) : Container(),
            ],
          ),
          InkWell(
            onTap: (){},
            child: Row(
              children: [
                Image.asset(ImageIcons.icon_community_zan.assetName,width: 18,height: 18,),
                Text(Global.getNumbersToChinese(comment.likes),style: const TextStyle(fontSize: 15),),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildSubComment(List<Comment> comments){
    List<Widget> widgets = [];
    if(comments.isNotEmpty){
      widgets.add(_buildCommentItem(comments.first, incisive: true));
      if(comments.length > 1) widgets.add(_buildCommentItem(comments[1]));
      if(comments.length > 2) {
        widgets.add(InkWell(
          onTap: (){
            _showComments(comments);
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
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(avatar);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}