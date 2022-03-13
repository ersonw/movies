import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/FeaturedPage.dart';
import 'package:movies/SearchPage.dart';
import 'package:movies/data/ClassData.dart';
import 'package:movies/data/SearchList.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HttpManager.dart';
import 'RoundUnderlineTabIndicator.dart';
import 'data/Featured.dart';
import 'data/SwiperData.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class IndexHomePage extends StatefulWidget {
  const IndexHomePage({Key? key}) : super(key: key);

  @override
  _IndexHomePage createState() => _IndexHomePage();
}

class _IndexHomePage extends State<IndexHomePage>  with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late  TabController _innerTabController;
  final _tabKey = const ValueKey('tab');
  final FocusNode _commentFocus = FocusNode();
  List<SwiperData> _swipers = [];
  List<String> _searchTags = [];
  List<String> _Records = [];
  List<Featured> _featureds = [];
  bool _showClassTop = false;
  final List<String> _first = [];
  final List<String> _second = [];
  final List<String> _last = [];
  int _firstIndex = 0;
  int _lastIndex = 0;
  int _secondIndex = 0;
  int _classPage = 1;
  int _classTotal = 20;
  bool _layout = true;
  List<ClassData> _classDatas = [];
  void handleTabChange() {
    switch(_innerTabController.index){
      case 0:
        _initSearchTags();
        break;
      case 1:
        _initFeatured();
        break;
      case 2:
        break;
    }
    PageStorage.of(context)?.writeState(context, _innerTabController.index, identifier: _tabKey);
  }
  @override
  void initState() {


    ClassData classData = ClassData();
    classData.remommends = 10300;
    classData.play = 1030;
    classData.actor = '三上悠亚';
    classData.title =
        '「明日花綺羅！請假裝被施了催眠樹！」邊演出連1mm都動不了的演技邊一心忍受超快感的性愛[中文字幕]SNIS-907 ';
    classData.image =
        'https://github1.oss-cn-hongkong.aliyuncs.com/7abc3392-2f02-4549-8b1d-a7d024030c60.jpeg';
    _classDatas.add(classData);
    _first.add('全部');
    _first.add('最新');
    _first.add('最热');
    _second.add('全部');
    _second.add('制片厂');
    _second.add('三级');
    _second.add('日本');
    _second.add('国产');
    _second.add('韩国');
    _second.add('欧美');
    _last.add('全部');
    _last.add('強奸');
    _last.add('潘甜甜');
    _last.add('探花');
    _last.add('黑人');
    _last.add('媽媽');
    _last.add('偷拍');
    _last.add('按摩');
    _last.add('絲襪');
    _last.add('玩偶姐姐');
    _last.add('亂倫');
    _last.add('巨乳');
    _last.add('强奸');
    _last.add('換妻');
    _last.add('人妻');
    _last.add('蘿莉');
    _last.add('丝袜');
    _last.add('空姐');
    _last.add('人妖');
    _last.add('學生');
    _last.add('五星級酒店女服務員');
    _initCarousel();
    _initSearchTags();
    _initFeatured();
    _Records = configModel.searchRecords;
    int initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _innerTabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: initialIndex != null ? initialIndex : 1);
    _innerTabController.addListener(handleTabChange);
    super.initState();
    configModel.addListener(() {
      setState(() {
        _Records = configModel.searchRecords;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _classPage++;
        // _getMore();
      } else if (_scrollController.position.pixels > 100) {
        if (!_showClassTop) {
          setState(() {
            _showClassTop = true;
          });
        }
      } else if (_scrollController.position.pixels < 100) {
        if (_showClassTop) {
          setState(() {
            _showClassTop = false;
          });
        }
      }
    });
  }
  _initFeatured()async{
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.featureds, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
      setState(() {
        _featureds = (jsonDecode(result)['list'] as List).map((e) => Featured.formJson(e)).toList();
      });
    }
  }
  _initCarousel()async{
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.carousels, {"data": jsonEncode(parm)}));
    // print(result);
    if (result != null) {
    setState(() {
    _swipers = (jsonDecode(result)['list'] as List).map((e) => SwiperData.formJson(e)).toList();
    });
    }
  }
  _initSearchTags() async{
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.gethotTags, {"data": jsonEncode(parm)}));
    if (result != null) {
      setState(() {
        _searchTags = (jsonDecode(result)['list'] as List).map((e) => e.toString()).toList();
      });
    }
  }
  Widget _buildFirst() {
    List<Widget> widgets = [];
    for (int i = 0; i < _first.length; i++) {
      widgets.add(InkWell(
        onTap: () => setState(() {
          _firstIndex = i;
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _firstIndex == i ? Colors.yellow : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            // color: Colors.black,
            margin:
                const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              _first[i],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  _showTotals() {
    int totalIndex = 0;
    // _fixedExtentScrollController.jumpTo(_classPage * 44);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_context) {
        return Container(
          color: Colors.white,
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 60,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(_context);
                        },
                      ),
                      TextButton(
                        child: const Text(
                          '确定',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          if(_classPage-totalIndex > 0){
                            setState(() {
                              _classPage = _classPage-totalIndex;
                            });
                          }else{
                            int i = _classTotal +(_classPage-totalIndex);
                            setState(() {
                              _classPage = i;
                            });
                          }
                          Navigator.pop(_context);
                        },
                      ),
                    ]),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.1), width: 1)),
                ),
              ),
              Expanded(
                  child: Container(
                color: Colors.white,
                height: 200,
                child: CupertinoPicker(
                  children: _buildTotalItem(),
                  looping: true,
                  selectionOverlay: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black12),
                    ),
                  ),
                  onSelectedItemChanged: (index) {
                    totalIndex = index;
                  },
                  itemExtent: 44,
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  _buildTotalItem() {
    List<Widget> widgets = [];
    for(int i=_classPage;i > 0;i--){
      widgets.add(Center(
        child: Text(
          '$i',
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          maxLines: 1,
        ),
      ));
    }
    for(int i=_classTotal;i>_classPage;i--){
      widgets.add(Center(
        child: Text(
          '$i',
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          maxLines: 1,
        ),
      ));
    }
    return widgets;
  }

  Widget _buildSecond() {
    List<Widget> widgets = [];
    for (int i = 0; i < _second.length; i++) {
      widgets.add(InkWell(
        onTap: () => setState(() {
          _secondIndex = i;
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _secondIndex == i ? Colors.yellow : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            margin:
                const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              _second[i],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  Widget _buildLast() {
    List<Widget> widgets = [];
    for (int i = 0; i < _last.length; i++) {
      widgets.add(InkWell(
        onTap: () => setState(() {
          _lastIndex = i;
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _lastIndex == i ? Colors.yellow : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            margin:
                const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              _last[i],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  _buildClassList() {
    if (_layout) {
      return _buildClassListWithLayout();
    }
    return _buildClassListWithoutLayout();
  }

  _buildClassSingleItem(int index) {
    // ClassData classData = _classDatas[index];
    return Column(
      children: [
        Container(
          width: ((MediaQuery.of(context).size.width) / 1),
          height: 210,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(_classDatas[0].image),
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          child: Global.buildPlayIcon(() {}),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: ((MediaQuery.of(context).size.width) / 1.1),
              child: Text(
                _classDatas[0].title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              width: ((MediaQuery.of(context).size.width) / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '主演${_classDatas[0].actor}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '${Global.getNumbersToChinese(_classDatas[0].play)}次播放',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              width: ((MediaQuery.of(context).size.width) / 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    ImageIcons.remommendIcon.assetName,
                    width: 45,
                    height: 15,
                  ),
                  Text(
                    '${Global.getNumbersToChinese(_classDatas[0].remommends)}人',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildClassItem(int index) {
    List<Widget> widgets = [];
    widgets.add(_buildClassDoubleItem(_classDatas[0]));
    widgets.add(_buildClassDoubleItem(_classDatas[0]));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }

  _buildClassDoubleItem(ClassData classData) {
    return Column(
      children: [
        Container(
          width: ((MediaQuery.of(context).size.width) / 2.2),
          height: 111,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(_classDatas[0].image),
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          child: Global.buildPlayIcon(() {}),
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

  _buildClassListWithLayout() {
    List<Widget> widgets = [];
    for (int i = 0; i < (20 / 2) + 1; i++) {
      widgets.add(_buildClassItem(i));
    }
    widgets.add(Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        child: const Text(
          '我也是有底线的哦！',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    ));

    return Column(
      children: widgets,
    );
  }

  _buildClassListWithoutLayout() {
    List<Widget> widgets = [];
    for (int i = 0; i < 20; i++) {
      widgets.add(_buildClassSingleItem(i));
    }
    widgets.add(Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        child: const Text(
          '我也是有底线的哦！',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    ));
    return Column(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 90, right: 90,top: 20),
              child:  TabBar(
                controller: _innerTabController,
                labelStyle: const TextStyle(fontSize: 20),
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
                    text: '搜索',
                  ),
                  Tab(
                    text: '精选',
                  ),
                  Tab(
                    text: '分类',
                  ),
                ],
              ),
            ),
            Expanded(child: TabBarView(
              controller: _innerTabController,
                children: [
                  _buildSearch(),
                  _buildList(),
                  _buildClassification(),
                ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassification() {
    return Column(
      children: [
        _showClassTop
            ? Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        width: ((MediaQuery.of(context).size.width) / 6),
                        margin: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 15, right: 15),
                        child: Text(
                          _first[_firstIndex],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        width: ((MediaQuery.of(context).size.width) / 6),
                        margin: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 15, right: 15),
                        child: Text(
                          _second[_secondIndex],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        width: ((MediaQuery.of(context).size.width) / 6),
                        margin: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 15, right: 15),
                        child: Text(
                          _last[_lastIndex],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        Expanded(
            child: ListView(
          controller: _scrollController,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: _buildFirst(),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: _buildSecond(),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: _buildLast(),
            ),
            SizedBox(
              width: ((MediaQuery.of(context).size.width) / 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '选择页数',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            _showTotals();
                          },
                          child: Text(
                            '当前第$_classPage页',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      _layout = !_layout;
                    }),
                    child: Row(
                      children: const [
                        Text(
                          '切换布局',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Icon(
                          Icons.layers_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              // color: Colors.black,
              child: _buildClassList(),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildHotTags() {
    List<Widget> lists = [];
    lists.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: const Text(
            '热门标签',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
    for (int i = 0; i < ((_searchTags.length / 4) + 1); i++) {
      lists.add(_buildHotTag(i));
    }
    return Column(
      children: lists,
    );
  }

  _callSearchPage(String words) {
    Navigator.of(context, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        title: '搜索',
        // fullscreenDialog: true,
        builder: (context) => SearchPage(title: words),
      ),
    ).then((value) => _initSearchTags());
  }

  _addRecord(String words) {
    for (int i = 0; i < _Records.length; i++) {
      if (_Records[i] == words) {
        _Records.removeAt(i);
        return _addRecord(words);
      }
    }
    _Records.add(words);
    configModel.searchRecords = _Records;
    _callSearchPage(words);
  }

  Widget _buildHotTag(int i) {
    List<Widget> lists = [];
    if (i * 4 < _searchTags.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_searchTags[i * 4]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _searchTags[i * 4],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    if (i * 4 + 1 < _searchTags.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_searchTags[i * 4 + 1]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _searchTags[i * 4 + 1],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    if (i * 4 + 2 < _searchTags.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_searchTags[i * 4 + 2]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _searchTags[i * 4 + 2],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    if (i * 4 + 3 < _searchTags.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_searchTags[i * 4 + 3]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _searchTags[i * 4 + 3],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: lists,
    );
  }

  Widget _buildRecords() {
    List<Widget> lists = [];
    lists.add(Container(
      // color: Colors.black54,
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '搜索历史',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: (){
              configModel.searchRecords = [];
            },
            child: const Icon(Icons.delete_forever,color: Colors.red,size: 24,),
          ),
        ],
      ),
    ));
    for (int i = 0; i < ((_Records.length / 4) + 1); i++) {
      lists.add(_buildRecord(i));
    }
    if (lists.length > 2) {
      return Column(
        children: lists,
      );
    } else {
      return Container();
    }
  }

  Widget _buildRecord(int i) {
    List<Widget> lists = [];
    List<String> _records = _Records.reversed.toList();
    if (i * 4 < _Records.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_records[i * 4]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _records[i * 4],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    if (i * 4 + 1 < _Records.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_records[i * 4 + 1]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _records[i * 4 + 1],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    if (i * 4 + 2 < _Records.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_records[i * 4 + 2]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _records[i * 4 + 2],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    if (i * 4 + 3 < _Records.length) {
      lists.add(InkWell(
        onTap: () => setState(() {
          _addRecord(_records[i * 4 + 3]);
        }),
        child: Container(
            width: ((MediaQuery.of(context).size.width) / 5),
            height: 30,
            margin: const EdgeInsets.only(top: 5, left: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6D6D6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  child: Text(
                    _records[i * 4 + 3],
                    style: const TextStyle(
                        fontSize: 15, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: lists,
    );
  }

  Widget _buildSearch() {
    return Column(
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
                    if (_textEditingController.text.isNotEmpty) {
                      _commentFocus.unfocus();
                      setState(() {
                        _addRecord(_textEditingController.text);
                      });
                      _textEditingController.text = '';
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
                  if (_textEditingController.text.isNotEmpty) {
                    _commentFocus.unfocus();
                    setState(() {
                      _addRecord(_textEditingController.text);
                    });
                    _textEditingController.text = '';
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
        Expanded(
            child: ListView(
          children: [
            _buildRecords(),
            _buildHotTags(),
          ],
        )),
        // Flexible(child: _buildRecords()),
        // Flexible(child: _buildHotTags()),
      ],
    );
  }
  _handlerSwiper(SwiperData data){
    switch(data.type){
      case SwiperData.OPEN_WEB_OUTSIDE:
        launch(data.url);
        break;
      case SwiperData.OPEN_WEB_INSIDE:
        Global.openWebview(data.url, inline: true);
        break;
      case SwiperData.OPEN_VIDEO:
        break;
      case SwiperData.OPEN_INLINE:
        break;
    }
  }
  Widget _buildSwiper(BuildContext context, int index) {
    SwiperData _swiper = _swipers[index];
    return InkWell(
      onTap: () {
        _handlerSwiper(_swiper);
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: NetworkImage(_swiper.image),
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  _buildList() {
    List<Widget> widgets = [];
    if(_swipers.isNotEmpty) {
      widgets.add(SizedBox(
      // color: Colors.black,
      height: 200,
      child: Swiper(
        itemCount: _swipers.length,
        itemBuilder: _buildSwiper,
        pagination: const SwiperPagination(),
        control: const SwiperControl(color: Colors.white),
      ),
    ));
    }
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push<void>(
                CupertinoPageRoute(
                  title: '精品专区',
                  // fullscreenDialog: true,
                  builder: (context) => const FeaturedPage(),
                ),
              );
            },
            child: Container(
              height: 63,
              width: ((MediaQuery.of(context).size.width) / 5),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 30,
                  ),
                  Text(
                    '精品专区',
                    style: TextStyle(color: Colors.brown, fontSize: 10),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 63,
              width: ((MediaQuery.of(context).size.width) / 5),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.local_movies_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  Text(
                    '制片厂',
                    style: TextStyle(color: Colors.brown, fontSize: 10),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 63,
              width: ((MediaQuery.of(context).size.width) / 5),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.assistant_rounded,
                    color: Colors.purple,
                    size: 30,
                  ),
                  Text(
                    '女优列表',
                    style: TextStyle(color: Colors.brown, fontSize: 10),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 63,
              width: ((MediaQuery.of(context).size.width) / 5),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '👑',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '热门榜单',
                    style: TextStyle(color: Colors.brown, fontSize: 10),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
    for(int i=0;i< _featureds.length;i++){
      widgets.add(_buildFeaturedList(_featureds[i]));
    }
    return ListView(
      controller: _controller,
      children: widgets,
    );
  }

  Widget _buildFeaturedList(Featured featured) {
    List<Widget> widgets = [];
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          featured.title,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        )
      ],
    ));
    for (int i = 0; i < (featured.videos.length / 2)+1; i++) {
      List<Widget> rows = [];
      if(i*2 < featured.videos.length){
        rows.add(_buildFeaturedItem(featured.videos[i*2]));
      }
      if((i*2)+1 < featured.videos.length){
        rows.add(_buildFeaturedItem(featured.videos[(i*2)+1]));
      }
      if(rows.isNotEmpty) {
        widgets.add(Row(
        mainAxisAlignment: rows.length > 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: rows,
      ));
      }
    }
    return Column(
      children: widgets,
    );
  }

  Widget _buildFeaturedItem(Video video) {
    return Container(
      width: ((MediaQuery.of(context).size.width) / 2.2),
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {
          Global.playVideo(video.id);
        },
        child: Column(
          children: [
            Container(
              height: 120,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(video.image),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              // child: Global.buildPlayIcon(() {}),
            ),
            Container(
              width: ((MediaQuery.of(context).size.width) / 2.2),
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                video.title,
                style: const TextStyle(
                    fontSize: 15, overflow: TextOverflow.ellipsis),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${Global.getNumbersToChinese(video.play)} 次播放',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        ImageIcons.remommendIcon.assetName,
                        width: 45,
                        height: 15,
                      ),
                      Text(
                        '${Global.getNumbersToChinese(video.recommendations)}人',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
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

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _textEditingController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
