import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/global.dart';
import 'package:movies/message_icon.dart';
import 'package:movies/message_list_build.dart';
import 'package:movies/SystemMessagesPage.dart';
import 'package:movies/system_ttf.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);
  static const String title = '消息中心';
  @override
  _MessagesPage createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage>{
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: ListView(
          children: _builder(context),
        )
    );
  }
  List<Widget> _builder(BuildContext context){
    List<Widget> list = [];
    list.add(MessageListBuild(
      title: '系统公告',
      text: (Global.messages.systemMessage.first.str.substring(0,18)).replaceAll('\\n', ' ') + '... '+ Global.messages.systemMessage.last.date,
      icon: MessageIcon.tongzhi,
      backgroundColor: Colors.blueAccent,
      tap: (){

        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            builder: (context) => SystemMessagesPage(title: '系统公告',iconData: MessageIcon.tongzhi,),
          ),
        );
      },
    ));
    list.add(MessageListBuild(
      title: '客服回复',
      text: '暂无消息',
      icon: MessageIcon.kefu,
      backgroundColor: Colors.purple,
    ));
    list.add(MessageListBuild(
      title: '审核消息',
      text: '暂无消息',
      icon: MessageIcon.wenzhangshenhe,
      backgroundColor: Colors.amberAccent,
    ));
    list.add(MessageListBuild(
      title: '评论点赞消息',
      text: '暂无消息',
      icon: MessageIcon.xiaoxi,
      backgroundColor: Colors.amber,
    ));
    list.add(MessageListBuild(
      title: '关注消息',
      text: '暂无消息',
      icon: MessageIcon.jiahao,
      backgroundColor: Colors.deepOrange,
    ));
    return list;
  }
}

