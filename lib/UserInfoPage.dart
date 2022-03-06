import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/UserPost.dart';

import 'PhotpGalleryPage.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'global.dart';
import 'image_icon.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key,required this.uid}) : super(key: key);
  int uid;

  @override
  _UserInfoPage createState() => _UserInfoPage();

}
class _UserInfoPage extends State<UserInfoPage> {
  List<UserPost> _userPosts = [];
  @override
  void initState() {
    // TODO: implement initState
    List<String> images = [];
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/c030c05a-5ca4-4ad9-af02-6048ab526010.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/7abc3392-2f02-4549-8b1d-a7d024030c60.jpeg');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/d95661e1-b1d2-4363-b263-ef60b965612d.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    images.add('https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png');
    UserPost userPost = UserPost();
    userPost.images = images;
    User user = User();
    user.vip = 1;
    user.nickname = '相见恨晚';
    user.avatar = 'http://github1.oss-cn-hongkong.aliyuncs.com/a8ac8dbc-47bc-423b-b881-b30583fb1042.png';
    userPost.user = user;
    userPost.title = '美美的自拍照献给大家';
    userPost.context = '性感的身体，饥渴难耐的';
    userPost.postTime = DateTime.now().millisecondsSinceEpoch;
    userPost.comments = 10030;
    userPost.likes = 1030;
    userPost.isCollect = true;
    _userPosts.add(userPost);
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
  Widget _buildListItem(int index){
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
      child: Container(
        margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image/124f0bbd-3255-49da-ac85-09df9db02e36.jpeg'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Global.buildPlayIcon((){
                    Global.playVideo(0);
                  }),
                ),
                Container(
                  // height: 30,
                  // width: 60,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 6,right: 6,top: 3.0,bottom: 3),
                    child: Text('00:30',style: TextStyle(color: Colors.white,fontSize: 10),),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 100,
              width: ((MediaQuery.of(context).size.width) / 2.2),
              // color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('办公室内玩弄斯斯文文的加班女同事',style: TextStyle(fontSize: 15),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('1391',style: TextStyle(color: Colors.black,fontSize: 13),),
                          Text('播放',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(ImageIcons.icon_community_zan.assetName,width: 45,height: 15,),
                          Text('99990人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPostItem(int index){
    UserPost userPost = _userPosts[0];
    return InkWell(
      onTap: () {
        print('test');
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
        child: Container(
          margin: const EdgeInsets.only(left: 5,right: 5,top: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        // alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                image: _buildAvatar(userPost.user.avatar),
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 57,
                            width: 45,
                            // color: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  // color: Colors.purple,
                                  child: Image.asset(ImageIcons.king_vip.assetName,width: 36,height: 30,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width) / 3,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(userPost.user.nickname,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,overflow: TextOverflow.ellipsis),),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // width: (MediaQuery.of(context).size.width) / 3,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(Global.getTimeToString(userPost.postTime),style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12),),
                                ),
                                const Icon(Icons.location_on_outlined,color: Colors.grey,size: 15,)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      _userPosts[index].user.follow = !userPost.user.follow;
                    }),
                    child: userPost.user.follow ? Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 1.0, color: Colors.grey),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 9,right: 9,top: 3,bottom: 3),
                        child: const Text('已关注',style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
                      ),
                    ) : Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 1.0, color: Colors.red),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 9,right: 9,top: 3,bottom: 3),
                        child: const Text('关注',style: TextStyle(color: Colors.red,fontSize: 14),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: _buildImages(userPost.images),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30,right: 30,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => setState(() {
                        _userPosts[index].isCollect = !userPost.isCollect;
                      }),
                      child: userPost.isCollect ?
                      Row(
                        children: const [
                          Icon(Icons.star_outlined,color: Colors.red,size: 25,),
                          Text('收藏',style: TextStyle(fontSize: 12),),
                        ],
                      )
                          : Row(
                        children: const [
                          Icon(Icons.star_border,color: Colors.black54,size: 25,),
                          Text('收藏',style: TextStyle(fontSize: 12),),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(Icons.message_outlined,color: Colors.black54,size: 20,),
                          Text(Global.getNumbersToChinese(userPost.comments),style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        _userPosts[index].isRecommend = !userPost.isRecommend;
                      }),
                      child: userPost.isRecommend ? Row(
                        children: [
                          Image.asset(ImageIcons.icon_community_zan.assetName,width: 18,color: Colors.red,),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(Global.getNumbersToChinese(userPost.comments),style: const TextStyle(fontSize: 12),),
                          ),
                        ],
                      ) : Row(
                        children: [
                          Image.asset(ImageIcons.icon_community_zan.assetName,width: 18,),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(Global.getNumbersToChinese(userPost.comments),style: const TextStyle(fontSize: 12),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _buildImages(List<String> images){
    List<Widget> widgets = [];
    if(images.isNotEmpty){
      List<Widget> list = [];
      list.add(_buildImage(images,0));
      if(images.length > 1) list.add(_buildImage(images,1));
      if(images.length > 2) list.add(_buildImage(images,2));
      widgets.add(Row(children: list, mainAxisAlignment: MainAxisAlignment.spaceBetween,));
      list = [];
      if(images.length > 3) list.add(_buildImage(images,3));
      if(images.length > 4) list.add(_buildImage(images,4));
      if(images.length > 5) list.add(_buildImage(images,5));
      widgets.add(Row(children: list, mainAxisAlignment: MainAxisAlignment.spaceBetween,));
      list = [];
      if(images.length > 6) list.add(_buildImage(images,6));
      if(images.length > 7) list.add(_buildImage(images,7));
      if(images.length > 8) list.add(_buildImage(images,8));
      widgets.add(Row(children: list, mainAxisAlignment: MainAxisAlignment.spaceBetween,));
      if(images.length > 9) {
        widgets.add(InkWell(
          onTap: (){
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5,bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('显示更多',style: TextStyle(color: Colors.blue,fontSize: 15),),
                Icon(Icons.keyboard_arrow_down_outlined,size: 24,color: Colors.blue,)
              ],
            ),
          ),
        ));
      }
    }
    return Column(
      children: widgets,
    );
  }
  _buildImage(List<String> images, int index){
    String image = images[index];
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (c, a, s) {
                return PhotpGalleryPage(
                  index: index,
                  photoList: images,
                );
              },
            )
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        width: (MediaQuery.of(context).size.width) / 3.3,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.fill
            )
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar:  AppBar(
      //   backgroundColor: Colors.black54,
      //   shadowColor: Colors.transparent,
      //   // foregroundColor: Colors.transparent,
      // ),
      // backgroundColor: const Color(0xF5F5F5FF),
      // backgroundColor: Colors.black54,
      body: DefaultTabController(
        length: 2,
        child: Container(
          color: Colors.white,
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
                    margin: const EdgeInsets.only(top: 30,left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                        ),
                      ],
                    ),
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
                child: Container(
                  color: const Color(0xF5F5F5FF),
                  child: TabBarView(
                    children: [
                    MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(itemCount: 10 ,itemBuilder: (BuildContext _context,int index) => _buildListItem(index)),
                    ),
                    MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(itemCount: 10 ,itemBuilder: (BuildContext _context,int index) => _buildPostItem(index)),
                    ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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