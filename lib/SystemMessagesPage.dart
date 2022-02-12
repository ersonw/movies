import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:movies/widgets.dart';

import 'model/SystemMessageModel.dart';

class SystemMessagesPage extends StatefulWidget {
  SystemMessagesPage({Key? key, this.title, this.iconData}) : super(key: key);
  String? title;
  IconData? iconData;

  @override
  _SystemMessagesPage createState() => _SystemMessagesPage();
}

class _SystemMessagesPage extends State<SystemMessagesPage> {
  List<SystemMessage> systemMessages = [];
   final MessagesChangeNotifier _messagesChangeNotifier = MessagesChangeNotifier();
   final SystemMessageModel _systemMessageModel = SystemMessageModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    systemMessages = _systemMessageModel.systemMessages;
    _systemMessageModel.read();
    _messagesChangeNotifier.addListener(() {
      setState(() {
        systemMessages = _systemMessageModel.systemMessages;
      });
    });
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
        child: ListView.builder(
          itemCount: systemMessages.length, itemBuilder: (BuildContext _context, int index) {
           return _buildList(index);
        }
        ));
  }

  Widget _buildList(int index) {
    SystemMessage _message = systemMessages[index];
    return _buildItem(_message.title,_message.date,_message.str.replaceAll(RegExp(r'\\n'), '\n'));
  }

  Widget _buildItem(String? title, String? date, String? str) {
    return Column(
        children: [
          Column(
            children: [
              Padding(padding: const EdgeInsets.only(top: 30,bottom: 10),child: Text(date!),),
            ],
          ),
          Card(
              color: Colors.white70,
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(title!),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10,left: 10),
                    child: Text(str!,style: const TextStyle(color: Colors.black38),),
                  ),
                ],
              )
          )
        ]
    );
  }
}
