import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/ClassData.dart';
import 'package:movies/data/SearchActor.dart';
import 'dart:io';
import 'ActorDetailsPage.dart';
import 'HttpManager.dart';
import 'PhotpGalleryPage.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'data/UserPost.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class CollectsPage extends StatefulWidget {
  const CollectsPage({Key? key}) : super(key: key);

  @override
  _CollectsPage createState() => _CollectsPage();
}
class _CollectsPage extends State<CollectsPage>  with SingleTickerProviderStateMixin {
  late  TabController _innerTabController;
  final ScrollController _controller = ScrollController();
  final _tabKey = const ValueKey('tab');
  int type = 0;
  int page = 1;
  int total = 1;
  List<ClassData> _videos = [];
  List<SearchActor> _actors = [];
  List<UserPost> _posts = [];
  void handleTabChange() {
    type = _innerTabController.index;
    page = 1;
    total = 1;
    _init();
    PageStorage.of(context)?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }
  @override
  void initState() {
    _init();
    super.initState();
    int initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 0);
    _innerTabController.addListener(handleTabChange);
    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        page++;
        _init();
      }
    });
  }
  _init()async{
    if(page > total){
      page--;
      return;
    }
    Map<String, dynamic> parm = {
      'type': type,
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.collectList, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['total'] != null) total = map['total'];

      switch(type){
        case 0:
          List<ClassData>  list = (map['list'] as List).map((e) => ClassData.formJson(e)).toList();
          setState(() {
            if(page>1){
              _videos.addAll(list);
            }else{
              _videos = list;
            }
          });
          break;
        case 1:
          List<SearchActor>  list = (map['list'] as List).map((e) => SearchActor.formJson(e)).toList();
          setState(() {
            if(page>1){
              _actors.addAll(list);
            }else{
              _actors = list;
            }
          });
          break;
        case 2:
          List<UserPost>  list = (map['list'] as List).map((e) => UserPost.formJson(e)).toList();
          setState(() {
            if(page>1){
              _posts.addAll(list);
            }else{
              _posts = list;
            }
          });
          break;
        default:
          break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: const CupertinoNavigationBar(),
      child: Container(
        margin: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back,size: 30,),
                ),
                Flexible(child: Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child:  TabBar(
                    controller: _innerTabController,
                    // isScrollable: true,
                    labelStyle: const TextStyle(fontSize: 18),
                    unselectedLabelStyle: const TextStyle(fontSize: 15),
                    padding: const EdgeInsets.only(right: 0),
                    indicatorPadding: const EdgeInsets.only(right: 0),
                    labelColor: Colors.red,
                    labelPadding: const EdgeInsets.only(left: 0, right: 0),
                    unselectedLabelColor: Colors.black,
                    indicator: const RoundUnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 9,
                          color: Colors.red,
                        )),
                    tabs: const [
                      Tab(
                        text: '视频',
                      ),
                      Tab(
                        text: '女优',
                      ),
                      Tab(
                        text: '话题',
                      ),
                    ],
                  ),
                )),
              ],
            ),
            Expanded(child: TabBarView(
                controller: _innerTabController,
                children: [
                  ListView.builder(
                    controller: _controller,
                    itemCount: (_videos.length ~/ 2 )+1,
                    itemBuilder: (BuildContext _context, int index) => _buildClassDoubleItem(index),
                  ),
                  ListView.builder(
                    controller: _controller,
                    itemCount: _actors.length,
                    itemBuilder: (BuildContext _context, int index) => _buildListActor(index),
                  ),
                  ListView.builder(
                    controller: _controller,
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext _context, int index) => _buildPostItem(index),
                  ),
                ]
            )),
            // Expanded(child: ListView.builder(
            //   controller: _controller,
            //   itemCount: _list.length+1,
            //   itemBuilder: (BuildContext _context, int index) => _buildListItem(index),
            // ),),
          ],
        ),
      ),
    );
  }
  _buildClassDoubleItem(int index) {
    List<Widget> widgets = [];
    if((index*2) < _videos.length) widgets.add(_buildClassItem(_videos[index*2]));
    if((index*2)+1 < _videos.length) widgets.add(_buildClassItem(_videos[(index*2)+1]));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
  _buildClassItem(ClassData classData) {
    return Column(
      children: [
        Container(
          width: ((MediaQuery.of(context).size.width) / 2.2),
          height: 111,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(classData.image),
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          child: Global.buildPlayIcon(() {
            Global.playVideo(classData.id);
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: ((MediaQuery.of(context).size.width) / 2.2),
              margin: const EdgeInsets.only(top: 5, bottom: 15),
              child: Text(
                classData.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 15),
              ),
            )
          ],
        ),
      ],
    );
  }
  _collect(int index) async{
    SearchActor actor = _actors[index];
    Map<String, dynamic> parm = {
      'aid': actor.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.collectActor, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      Map<String,dynamic> map = jsonDecode(result);
      if(map['verify'] != null && map['verify'] == true){
        if(actor.collect){
          Global.showWebColoredToast('取消收藏成功！');
        }else{
          Global.showWebColoredToast('收藏成功！');
        }
        setState(() {
          _actors[index].collect = !actor.collect;
        });
      }else if(map['msg'] != null){
        Global.showWebColoredToast(map['msg']);
      }
    }
  }
  Widget _buildListActor(int index){
    SearchActor actor = _actors[index];
    return Container(
      margin: const EdgeInsets.only(top: 5,bottom: 5),
      width: ((MediaQuery.of(context).size.width) / 1),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      // title: "推广分享",
                      // fullscreenDialog: true,
                      builder: (context) => ActorDetailsPage(aid: actor.id),
                    ),
                  ).then((value) => _init());
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 54,
                  height: 54,
                  // margin: EdgeInsets.only(left: vw()),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                      // image: AssetImage('assets/image/default_head.gif'),
                      image: _buildActorAvatar(actor.avatar),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      // title: "推广分享",
                      // fullscreenDialog: true,
                      builder: (context) => ActorDetailsPage(aid: actor.id),
                    ),
                  ).then((value) => _init());
                },
                child: SizedBox(
                  width: ((MediaQuery.of(context).size.width) / 2.5),
                  // height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width) / 2.5),
                            child: Text(actor.name,style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('作品：${Global.getNumbersToChinese(actor.work)}部',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actor.collect ? InkWell(
            onTap: () {
              _collect(index);
            },
            child: Container(
              width: 63,
              height: 30,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.grey),
              ),
              child: const Center(child: Text('收藏',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.center,),),
            ),
          ) :
          InkWell(
            onTap: () {
              _collect(index);
            },
            child: Container(
              width: 63,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.yellow),
              ),
              child: const Center(child: Text('收藏',style: TextStyle(color: Colors.yellow,fontSize: 12),textAlign: TextAlign.center,),),
            ),
          ),
        ],
      ),
    );
  }
  _buildActorAvatar(String avatar) {
    if (avatar == null || avatar == '') {
      return AssetImage(ImageIcons.actorIcon.assetName);
    }
    if (avatar.startsWith('http')) {
      return NetworkImage(avatar);
    }
    return FileImage(File(avatar));
  }
  _buildAvatar(String avatar) {
    if ((avatar == null || avatar == '') ||
        avatar.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(avatar);
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
  Widget _buildPostItem(int index){
    UserPost userPost = _posts[index];
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
                      // _userPosts[index].user.follow = !userPost.user.follow;
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
                        // _userPosts[index].isCollect = !userPost.isCollect;
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
                        // _userPosts[index].isRecommend = !userPost.isRecommend;
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
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}