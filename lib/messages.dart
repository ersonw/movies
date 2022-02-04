import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies/message_icon.dart';
import 'package:movies/message_list_build.dart';
import 'package:movies/system_ttf.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _Messages createState() => _Messages();
}

class _Messages extends State<Messages>{
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('消息中心')
            ],
          ),
        ),
        child: ListView(
          children: _builder(context),
        )
    );
  }
  List<Widget> _builder(BuildContext context){
    List<Widget> list = [];
    list.add(MessageListBuild(
      title: '系统消息',
      text: '暂无消息',
      icon: MessageIcon.tongzhi,
      backgroundColor: Colors.blueAccent,
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