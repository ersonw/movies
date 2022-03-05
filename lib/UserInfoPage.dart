import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RoundUnderlineTabIndicator.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key,required this.uid}) : super(key: key);
  int uid;
  @override
  _UserInfoPage createState() => _UserInfoPage();

}
class _UserInfoPage extends State<UserInfoPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  _buildAvatar(String avatar) {
    if ((avatar == null || avatar == '') ||
        avatar.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(avatar);
  }
  _buildBgImage(String avatar) {
    if ((avatar == null || avatar == '') ||
        avatar.contains('http') == false) {
      return const AssetImage('assets/image/06b6f2f7-484e-41e1-82e8-4b31d199e813.jpg');
    }
    return NetworkImage(avatar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: _buildBgImage(''),
                        fit: BoxFit.fitWidth
                    ),
                  ),
                  height: 190,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10,right: 10),
                  height: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: (){},
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    image: DecorationImage(
                                      image: _buildAvatar(''),
                                      fit: BoxFit.fill,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width) / 3,
                                child: Text('相见恨晚相见恨晚相见恨晚相见恨晚',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),),
                              ),
                            ],
                          ),
                          // Container(
                          //   decoration: const BoxDecoration(
                          //     color: Colors.white38,
                          //     borderRadius: BorderRadius.all(Radius.circular(6)),
                          //   ),
                          //   child: Container(
                          //     margin: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 6),
                          //     child: Row(
                          //       children: const [
                          //         Icon(Icons.add,size: 20,color: Colors.white,),
                          //         Text('关注',style: TextStyle(color: Colors.white,fontSize: 15),)
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 6),
                              child: Row(
                                children: const [
                                  Icon(Icons.done,size: 20,color: Colors.black,),
                                  Text('关注',style: TextStyle(color: Colors.black,fontSize: 15),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('0',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      Text('视频',style: TextStyle(color: Colors.grey,fontSize: 15),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('58',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      Text('关注',style: TextStyle(color: Colors.grey,fontSize: 15),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('0',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      Text('粉丝',style: TextStyle(color: Colors.grey,fontSize: 15),),
                    ],
                  ),
                  Row(
                    children: [
                      Text('0',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      Text('推荐数',style: TextStyle(color: Colors.grey,fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('简介:',style: TextStyle(color: Colors.black,fontSize: 15),),
                  Container(
                    width: (MediaQuery.of(context).size.width) / 1.5,
                    margin: const EdgeInsets.only(left: 10,right: 20),
                    child: Text('专注各种网红，进入主页看更多精彩专注各种网红，进入主页看更多精彩专注各种网红，进入主页看更多精彩专注各种网红，进入主页看更多精彩',style: TextStyle(color: Colors.black,fontSize: 15),),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 90,right: 90),
              child: const TabBar(
                // isScrollable: true,
                labelStyle: TextStyle(fontSize: 18),
                unselectedLabelStyle: TextStyle(fontSize: 15),
                padding: EdgeInsets.only(right: 0),
                indicatorPadding: EdgeInsets.only(right: 0),
                labelColor: Colors.red,
                labelPadding: EdgeInsets.only(left: 0, right: 0),
                unselectedLabelColor: Colors.black,
                indicator: RoundUnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 9,
                      color: Colors.red,
                    )),
                tabs: [
                  Tab(
                    text: '视频',
                  ),
                  Tab(
                    text: '帖子',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Text('1'),
                  Text('2'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}