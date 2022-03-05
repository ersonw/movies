import 'package:movies/data/Comment.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    comment.avatar = 'http://github1.oss-cn-hongkong.aliyuncs.com/2942af7c-5541-418e-a9e5-baed6d301158.png';
    comment.likes = 1024;
    comment.context = '好看';
    comment.nickname = 'CC';
    _comments.add(comment);
    _comments.add(comment);
    super.initState();
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
                margin: const EdgeInsets.only(left: 90, right: 90,top: 20),
                child: const TabBar(
                  labelStyle: TextStyle(fontSize: 20),
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
                                    Text('狼友推荐的第79部大片',style: TextStyle(color: Colors.black,fontSize: 15),),
                                    Text('共1623人推荐',style: TextStyle(color: Colors.black,fontSize: 15),),
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
                                // width: (MediaQuery.of(context).size.width),
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
  _buildComments(List<Comment> comments){}
  _buildCommentItem(Comment comment){
    return Container(
      margin: const EdgeInsets.only(top: 5,bottom: 5),
      width: (MediaQuery.of(context).size.width),
      // color: Colors.black54,
      child: Row(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: _buildAvatar(comment.avatar),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
  _buildSubComment(List<Comment> comments){
    List<Widget> widgets = [];
    if(comments.isNotEmpty){
      widgets.add(_buildCommentItem(comments.first));
      if(comments.length > 1) widgets.add(_buildCommentItem(comments[1]));
      if(comments.length > 2) {
        widgets.add(InkWell(
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