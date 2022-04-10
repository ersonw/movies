import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnlinePayPage extends StatefulWidget {
  int type;
  int id;
  OnlinePayPage(this.type, this.id ,{Key? key}) : super(key: key);
  @override
  _OnlinePayPage createState() => _OnlinePayPage();

}
class _OnlinePayPage extends State<OnlinePayPage>{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: Container(
          width: ((MediaQuery.of(context).size.width) / 1.2),
          height: 300,
          color: Colors.white,
        ),
      ),
    );
  }
}