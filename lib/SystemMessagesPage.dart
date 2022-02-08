import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:movies/widgets.dart';

class SystemMessagesPage extends StatefulWidget {
  SystemMessagesPage({Key? key, this.title, this.iconData}) : super(key: key);
  String? title;
  IconData? iconData;

  @override
  _SystemMessagesPage createState() => _SystemMessagesPage();
}

class _SystemMessagesPage extends State<SystemMessagesPage> {
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
    List<SystemMessage> messages = Global.messages.systemMessage;
    for(int i=0;i< messages.length; i++){
      lists.addAll(_buildItem(messages[i].title,messages[i].date,messages[i].str.replaceAll(RegExp(r'\\n'), '\n')));
    }
    // lists.addAll(_buildItem());
    return lists;
  }

  List<Widget> _buildItem(String? title, String? date, String? str) {
    return <Widget> [
      Column(
        children: [
        Padding(padding: EdgeInsets.only(top: 30,bottom: 10),child: Text(date!),),
      ],),
      Card(
        color: Colors.white70,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(title!),
            ),
            Container(
              padding: EdgeInsets.only(top: 10,left: 10),
              child: Text(str!,style: TextStyle(color: Colors.black38),),
            ),
          ],
        )
      )
    ];
  }
}
