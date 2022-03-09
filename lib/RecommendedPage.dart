import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/PlayerPage.dart';
import 'package:movies/image_icon.dart';

import 'RoundUnderlineTabIndicator.dart';
import 'data/Recommended.dart';
import 'global.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  _RecommendedPage createState() => _RecommendedPage();
}

class _RecommendedPage extends State<RecommendedPage> {
  List<Recommended> _recommendeds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Recommended recommended = Recommended();
    recommended.type = 0;
    recommended.title = '[hongkongdoll]玩偶姐姐森林新篇章-第二集-欺骗-失身又失心';
    recommended.actor = 'hongkongdoll';
    recommended.image = '';
    recommended.face = 5;
    recommended.funny = 4.5;
    recommended.hot = 3.5;
    _recommendeds.add(recommended);
    recommended = Recommended();
    recommended.type = 1;
    recommended.title = '[hongkongdoll]玩偶姐姐森林新篇章-第二集-欺骗-失身又失心';
    recommended.actor = 'hongkongdoll';
    recommended.image = '';
    recommended.face = 5;
    recommended.funny = 4.5;
    recommended.hot = 3.5;
    recommended.diamond = 2900;
    setState(() {
      _recommendeds.add(recommended);
    });
    print(_recommendeds);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTabController(
          length: 2,
          child: _buildBody(context)),
    );
  }
  Widget _buildItem(BuildContext context, int index){
    Recommended recommended = _recommendeds[index];
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1.0, color: Colors.black12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(index == 0 ? ImageIcons.top1Bg.assetName : ImageIcons.nomalBg.assetName),
                alignment: Alignment.topLeft,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    '${index == 0 ? 'TOP':'至臻'}.${index +1}',
                    style:  const TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildPlay(recommended)
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              height: 47,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageIcons.reason.assetName),
                  alignment: Alignment.topLeft,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 50),
                    width: (MediaQuery.of(context).size.width) / 1.6,
                    child: Text(recommended.title,
                      style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),
                  )
                ],
              )
          ),
          Container(
            width: 350,
            height: 200,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage('assets/image/06b6f2f7-484e-41e1-82e8-4b31d199e813.jpg'),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            child: Global.buildPlayIcon((){
              // print(recommended.title);
              Navigator.of(context, rootNavigator: true).push<void>(
                CupertinoPageRoute(
                  // title: '金币钱包',
                  // fullscreenDialog: true,
                  builder: (context) => PlayerPage(id: recommended.vid),
                ),
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text('主演：${recommended.actor}')
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('搞笑指数',style:  TextStyle(fontSize: 15),),
                    _buildStar(recommended.funny),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('热门指数',style: TextStyle(fontSize: 15),),
                    _buildStar(recommended.hot),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('颜值指数',style: TextStyle(fontSize: 15),),
                    _buildStar(recommended.face),
                  ],
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildBody(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   margin: const EdgeInsets.only(left: 54, right: 54,top: 30),
        //   child: const TabBar(
        //     // isScrollable: true,
        //     labelStyle: TextStyle(fontSize: 18),
        //     unselectedLabelStyle: TextStyle(fontSize: 15),
        //     padding: EdgeInsets.only(right: 0),
        //     indicatorPadding: EdgeInsets.only(right: 0),
        //     labelColor: Colors.red,
        //     labelPadding: EdgeInsets.only(left: 0, right: 0),
        //     unselectedLabelColor: Colors.black,
        //     indicator: RoundUnderlineTabIndicator(
        //         borderSide: BorderSide(
        //           width: 9,
        //           color: Colors.red,
        //         )),
        //     tabs: [
        //       Tab(
        //         text: '今日推荐',
        //       ),
        //       Tab(
        //         text: '制片厂',
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(child: TabBarView(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '今日推荐',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: const Text('资深编辑，一生心血！每日精选推荐！经典必藏！'),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: _buildItem,
                                itemCount: _recommendeds.length,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Text("Tab2"),
            ])),
      ],
    );
  }
  _buildPlay(Recommended recommended){
    int diamond = recommended.diamond;
    if(diamond == 0) {
      return InkWell(
          onTap: (){
            // Global.showDialogVideo(recommended.title, recommended.image);
          },
          child: Container(
            width: 100,
            height: 30,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(20)),
              border:
              Border.all(width: 1.0, color: Colors.red),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Image.asset(
                    ImageIcons.share.assetName,
                    width: 15,
                  ),
                  const Text(
                    '无限观看',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          )
      );
    }
    return InkWell(
      onTap: (){
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            // title: '金币钱包',
            // fullscreenDialog: true,
            builder: (context) => PlayerPage(id: recommended.vid),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 30,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1.0, color: Colors.orange),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 10),

          child: Row(
            children: [
              Image.asset(ImageIcons.diamond.assetName,width: 15,),
              Text('$diamond钻石',style: const TextStyle(color: Colors.orange),),
            ],
          ),
        ),
      ),
    );
  }
  _buildStar(double m){
    int ii = m.toInt();
    if(ii < m){
      ii++;
    }
    List<Widget> widget = [];
    for(int i=1;i< (ii+1);i++){
      if(i < m || i == m){
        widget.add(Image.asset(ImageIcons.star.assetName,width: 15,));
      }else {
        widget.add(Image.asset(ImageIcons.star_half.assetName,width: 15,));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget,
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
