import 'package:flutter/material.dart';
import 'package:movies/system_ttf.dart';
import 'package:badges/badges.dart';
class MessageListBuild extends StatefulWidget {
  MessageListBuild({Key? key, this.newIn, this.text, this.tap,this.date, required this.title, this.icon, this.backgroundColor,this.color}) : super(key: key);
  String? text;
  String? date;
  int? newIn;
  IconData? icon;
  final void Function()? tap;
  String title;
  Color? backgroundColor;
  Color? color;
  @override
  _MessageListBuild createState() => _MessageListBuild();

}
class _MessageListBuild extends State<MessageListBuild> {
  @override
  Widget build(BuildContext context) {
    String? text = widget.text;
    String? date = widget.date;
    IconData? icon = widget.icon;
    final void Function()? tap = widget.tap;
    String title = widget.title;
    Color? backgroundColor = widget.backgroundColor;
    Color? color = widget.color;
    int newIn = widget.newIn ?? 0;
    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        // shadowColor: Colors.white,
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(6, 12, 6, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          // Make it splash on Android. It would happen automatically if this
          // was a real card but this is just a demo. Skip the splash on iOS.
          onTap: tap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Badge(
                  child: Icon(icon ?? SystemTtf.tishi, color: color ?? Colors.blue,size: 35,),
                  badgeContent: Text('$newIn'),
                  showBadge: newIn > 0,
                  // badgeColor: backgroundColor ?? Colors.blue,
                ),
                const Padding(padding: EdgeInsets.only(left: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            text!,
                          ),
                          Text(date!),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}