import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  _RecommendedPage createState() => _RecommendedPage();

}
class _RecommendedPage extends State<RecommendedPage>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        trailing: TabBar(
          labelColor: Colors.black,
          tabs: [
            Tab(text: "每日推荐",),
            Tab(text: "制片人",),
          ],
        ),
      ),
      child: _buildBody(context),
    ));
  }
  _buildBody(BuildContext context){
    return TabBarView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Column(
              children: [
                Expanded(child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('今日推荐',style: TextStyle(color: Colors.black,fontSize: 27,fontWeight: FontWeight.bold),)

                      ],
                    ),
                    Row(
                      children: [Container(margin: const EdgeInsets.only(top: 20),child: const Text('资深编辑，一生心血！每日精选推荐！经典必藏！'),)],
                    )
                  ],
                ))
              ],
            ),
          ),
          Text("Tab2"),
        ]
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}