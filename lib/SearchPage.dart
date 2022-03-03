import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/SearchActor.dart';
import 'package:movies/data/SearchList.dart';
import 'package:movies/data/UserList.dart';
import 'package:movies/image_icon.dart';
import 'dart:io';
import 'RoundUnderlineTabIndicator.dart';
import 'global.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  late TabController _innerTabController;
  final ScrollController _scrollController = ScrollController();
  final _tabKey = const ValueKey('tab');
  int _tabIndex = 0;

  List<SearchList> _avLists = [];
  List<SearchList> _workLists = [];
  List<SearchList> _numberLists = [];
  List<UserList> _userLists = [];
  List<SearchActor> _actorLists = [];

  @override
  void initState() {
    SearchList searchList = SearchList();
    searchList.image =
        'https://github1.oss-cn-hongkong.aliyuncs.com/8aa3d840-8a60-4e85-8bf1-418ab5518be5.png';
    searchList.number = '12321312312321321312';
    searchList.title = '[HongKongDoll]甜美游戏陪玩2 下';
    searchList.play = 1500;
    searchList.remommends = 30000;
    _avLists.add(searchList);
    SearchActor searchActor = SearchActor();
    searchActor.name = '潘甜甜';
    searchActor.work = 0;
    _actorLists.add(searchActor);
    UserList userList = UserList();
    userList.work = 1500;
    userList.fans = 10000;
    userList.nickname = '游客132131313123甜美游戏陪玩2';
    _userLists.add(userList);
    _textEditingController.text = widget.title;
    int initialIndex =
        PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 0);
    _innerTabController.addListener(handleTabChange);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _getMore();
      }
    });
    super.initState();
  }

  void handleTabChange() {
    setState(() {
      _tabIndex = _innerTabController.index;
    });
    PageStorage.of(context)
        ?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFFFAFAFA)),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 27,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _commentFocus,
                      onEditingComplete: () {
                        if (_textEditingController.text.length > 1) {
                          _commentFocus.unfocus();
                          // _textEditingController.text = '';
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(18)
                      ],
                      // controller: _controller,
                      decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xffcccccc)),
                          hintText: "搜片名、演员"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_textEditingController.text.length > 1) {
                        _commentFocus.unfocus();
                        // _textEditingController.text = '';
                      }
                    },
                    child: const Text(
                      '搜索',
                      style: TextStyle(color: Colors.redAccent, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
                controller: _innerTabController,
                labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 10, color: Colors.grey),
                labelColor: Colors.red,
                labelPadding: const EdgeInsets.only(left: 0, right: 0),
                unselectedLabelColor: Colors.black,
                indicator: const RoundUnderlineTabIndicator(
                    borderSide: BorderSide(
                  width: 9,
                  color: Colors.red,
                )),
                tabs: const [
                  Tab(text: 'AV'),
                  Tab(text: '作品'),
                  Tab(text: '番号'),
                  Tab(text: '用户'),
                  Tab(text: '女优'),
                ]),
            Expanded(
              child: TabBarView(controller: _innerTabController, children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _avLists.length,
                  itemBuilder: _buildListAv,
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _workLists.length,
                  itemBuilder: _buildListWork,
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _numberLists.length,
                  itemBuilder: _buildListNumber,
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _userLists.length,
                  itemBuilder: _buildListUser,
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _actorLists.length,
                  itemBuilder: _buildListActor,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildListUser(BuildContext context, int index){
    UserList userList = _userLists[index];
    return Container(
      margin: const EdgeInsets.only(top: 5,bottom: 5),
      width: ((MediaQuery.of(context).size.width) / 1),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                width: 54,
                height: 54,
                // margin: EdgeInsets.only(left: vw()),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50.0),
                  image: DecorationImage(
                    // image: AssetImage('assets/image/default_head.gif'),
                    image: _buildAvatar(userList.avatar),
                  ),
                ),
              ),
              SizedBox(
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
                          child: Text(userList.nickname,style: const TextStyle(color: Colors.black,fontSize: 15,overflow: TextOverflow.ellipsis),),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('粉丝：${Global.getNumbersToChinese(userList.fans)}',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                        Text('作品：${Global.getNumbersToChinese(userList.work)}',style: const TextStyle(color: Colors.grey,fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          userList.follow ? InkWell(
            onTap: () => setState(() {
                _userLists[index].follow = false;
            }),
            child: Container(
              width: 80,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.done,size: 24,color: Colors.white,),
                  Text('关注',style: TextStyle(color: Colors.white,fontSize: 15),),
                ],
              ),
            ),
          ) :
          InkWell(
            onTap: () => setState(() {
              _userLists[index].follow = true;
            }),
            child: Container(
              width: 80,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add,size: 24,color: Colors.black,),
                  Text('关注',style: TextStyle(color: Colors.black,fontSize: 15),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _buildAvatar(String avatar) {
    if ((avatar == null || avatar == '') ||
        avatar.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(avatar);
  }
  Widget _buildListActor(BuildContext context, int index){
    SearchActor actor = _actorLists[index];
    return Container(
      margin: const EdgeInsets.only(top: 5,bottom: 5),
      width: ((MediaQuery.of(context).size.width) / 1),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
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
              SizedBox(
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
            ],
          ),
          actor.collect ? InkWell(
            onTap: () => setState(() {
              _actorLists[index].collect = false;
            }),
            child: Container(
              width: 63,
              height: 30,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.grey),
              ),
              child: const Center(child: Text('已搜藏',style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.center,),),
            ),
          ) :
          InkWell(
            onTap: () => setState(() {
              _actorLists[index].collect  = true;
            }),
            child: Container(
              width: 63,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1.0, color: Colors.yellow),
              ),
              child: const Center(child: Text('搜藏',style: TextStyle(color: Colors.yellow,fontSize: 12),textAlign: TextAlign.center,),),
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
  Widget _buildListAv(BuildContext context, int index) {
    SearchList searchList = _avLists[index];
    return _buildVideoItem(searchList);
  }
  Widget _buildListWork(BuildContext context, int index) {
    SearchList searchList = _workLists[index];
    return _buildVideoItem(searchList);
  }
  Widget _buildListNumber(BuildContext context, int index) {
    SearchList searchList = _numberLists[index];
    return _buildVideoItem(searchList);
  }
  Widget _buildVideoItem(SearchList searchList){
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: ((MediaQuery.of(context).size.width) / 2.2),
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(searchList.image),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            child: Global.buildPlayIcon(() {
              Global.playVideo(searchList.id);
            }),
          ),
          SizedBox(
            width: ((MediaQuery.of(context).size.width) / 2.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchList.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(
                  '番号:${searchList.number}',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          Global.getNumbersToChinese(searchList.play),
                          style: const TextStyle(color: Colors.black, fontSize: 13),
                        ),
                        const Text(
                          '播放',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          ImageIcons.remommendIcon.assetName,
                          width: 45,
                          height: 15,
                        ),
                        Text(
                          '${Global.getNumbersToChinese(searchList.remommends)}人',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}