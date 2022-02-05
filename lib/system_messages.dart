import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/widgets.dart';

class SystemMessages extends StatefulWidget {
  SystemMessages({Key? key,this.title,this.iconData}) : super(key: key);
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
          children: [Text(title == null ? '': title)],
        ),
      ),
      child: _build(context),
    );
  }
  Widget _build(BuildContext context){
    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(children: _buildList(),)
    );
  }
  List<Widget> _buildList(){
    List<Widget> lists = [];
    lists.add(_buildItem());
    return lists;
  }
  Widget _buildItem(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('2021-12-02')
      ],
    );
  }
}