import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/widgets.dart';

class SystemMessages extends StatefulWidget {
  SystemMessages({Key? key, this.title, this.iconData}) : super(key: key);
  String? title;
  IconData? iconData;

  @override
  _SystemMessages createState() => _SystemMessages();
}

class _SystemMessages extends State<SystemMessages> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? title = widget.title;
    IconData? iconData = widget.iconData;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(title == null ? '' : title)],
        ),
      ),
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          children: _buildList(),
        ));
  }

  List<Widget> _buildList() {
    List<Widget> lists = [];
    lists.addAll(_buildItem());
    return lists;
  }

  List<Widget> _buildItem() {
    return <Widget> [
      Column(
        children: [
        Padding(padding: EdgeInsets.only(top: 30,bottom: 10),child: Text('2021-12-02'),),
      ],),
      Card(
        color: Colors.white70,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text('系统公告'),
            ),
            Container(
              padding: EdgeInsets.only(top: 10,left: 10),
              child: Text('打响新年第一炮\n\n1、【虎年闹新春】活动上线了！\n分享好友，就有机会获得官方安排的【空降嫩模】，还有iPhone13等大奖等你免费领取，速速参与\n2、金币视频免费看VIP限时出售，快快抢购吧\n\n商务合作请POTATO/TELEGRAM搜索：@moyi6\n投稿认证请Telegram搜索：@shangwu91\n',style: TextStyle(color: Colors.black38),),
            ),
          ],
        )
      )
    ];
  }
}
