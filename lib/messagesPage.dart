import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/KeFuMessagePage.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/global.dart';
import 'package:movies/message_icon.dart';
import 'package:movies/message_list_build.dart';
import 'package:movies/SystemMessagesPage.dart';
import 'package:movies/system_ttf.dart';

import 'data/Messages.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);
  static const String title = '消息中心';
  @override
  _MessagesPage createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage>{
  late Messages _messages;
  @override
  void initState() {
    super.initState();
    _messages = messagesChangeNotifier.messages;
    messagesChangeNotifier.addListener(() {
      setState(() {
        // print('刷新了');
        _messages = messagesChangeNotifier.messages;
      });
    });
  }
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
    var sysmsg = _messages.systemMessage.first.str.replaceAll('\\n', ' ');
    if(sysmsg.length > 18){
      sysmsg = sysmsg.substring(0,18) + '... ';
    }
    int newIn = 0;
    for(int i=0;i< _messages.systemMessage.length;i++){
      if(_messages.systemMessage[i].isRead == false){
        newIn++;
      }
    }
    list.add(MessageListBuild(
      title: '系统公告',
      text:  sysmsg,
      newIn: newIn,
      date: _messages.systemMessage.last.date,
      icon: MessageIcon.tongzhi,
      backgroundColor: Colors.blueAccent,
      tap: (){

        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            builder: (context) => SystemMessagesPage(title: '系统公告',iconData: MessageIcon.tongzhi,),
          ),
        ).then((val) =>setState);
      },
    ));
    String kefumsg = _messages.kefuMessage.isNotEmpty && _messages.kefuMessage.last.text != null ? _messages.kefuMessage.last.text! : (_messages.kefuMessage.isNotEmpty && _messages.kefuMessage.last.image != null ? '[图片]' : '暂无消息');
    kefumsg = kefumsg.replaceAll('\\n', ' ');
    // if(kefumsg.length > 18){
    //   kefumsg = kefumsg.substring(0,18) + '... ' ;
    // }
    newIn = 0;
    for(int i=0;i< _messages.kefuMessage.length;i++){
      if(_messages.kefuMessage[i].isRead == false){
        newIn++;
      }
    }
    list.add(MessageListBuild(
      title: '客服回复',
      text: kefumsg,
      newIn: newIn,
      date: _messages.kefuMessage.isNotEmpty ? Global.getDateTime(_messages.kefuMessage.last.date) : '',
      icon: MessageIcon.kefu,
      backgroundColor: Colors.purple,
      tap: (){

        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            builder: (context) => const KeFuMessagePage(),
          ),
        ).then((val) =>setState);
      },
    ));
    // list.add(MessageListBuild(
    //   title: '审核消息',
    //   text: '暂无消息',
    //   date: '',
    //   icon: MessageIcon.wenzhangshenhe,
    //   backgroundColor: Colors.amberAccent,
    // ));
    // list.add(MessageListBuild(
    //   title: '评论点赞消息',
    //   text: '暂无消息',
    //   date: '',
    //   icon: MessageIcon.xiaoxi,
    //   backgroundColor: Colors.amber,
    // ));
    // list.add(MessageListBuild(
    //   title: '关注消息',
    //   text: '暂无消息',
    //   date: '',
    //   icon: MessageIcon.jiahao,
    //   backgroundColor: Colors.deepOrange,
    // ));
    return list;
  }
}

