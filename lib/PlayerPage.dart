import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/BuyDiamondPage.dart';
import 'package:movies/data/Player.dart';
import 'package:movies/functions.dart';
import 'package:movies/image_icon.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock/wakelock.dart';
import 'ActorDetailsPage.dart';
import 'HttpManager.dart';
import 'VIPBuyPage.dart';
import 'VideoFullPage.dart';
import 'data/SearchList.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class PlayerPage extends StatefulWidget {
  int id;

  PlayerPage({Key? key, required this.id}) : super(key: key);

  @override
  _PlayerPage createState() => _PlayerPage();
}

class _PlayerPage extends State<PlayerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  Player _player = Player();
  List<SearchList> _avLists = [];
  late VideoPlayerValue value;
  bool showControls = false;
  bool _canPlay = false;
  bool _showError = false;
  bool _isReport = false;
  bool alive = true;

  @override
  void initState() {
    // TODO: implement initState
    Wakelock.enable();
    _controller = VideoPlayerController.asset(ImageIcons.loading_38959.assetName);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    value = _controller.value;
    _controller.addListener(() {
      if(alive) {
        setState(() {
          value = _controller.value;
        });
      }
    });
    _initPlayer();
    _initList();
    super.initState();
  }
 void _initList() async{
   String? result = (await DioManager().requestAsync(
       NWMethod.GET, NWApi.getRandom, {}));
   if (result == null) {
     return;
   }
   setState(() {
     _avLists = (jsonDecode(result)['list'] as List).map((e) => SearchList.formJson(e)).toList();
   });
 }
  void _initPlayer() async {
    Map<String, dynamic> parm = {
      'id': widget.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getPlayer, {"data": jsonEncode(parm)}));
    // print(result);
    if (result == null) {
      return;
    }
    Map<String, dynamic> map = jsonDecode(result);
    if (map['error'] != null && map['error'] == true) {
      setState(() {
        _showError = true;
      });
      return;
    }
    if (map['verify'] == null || map['verify'] == false) {
      setState(() {
        _player = Player.formJson(map['info']);
        _canPlay = false;
      });
      return;
    }
    setState(() {
      _player = Player.formJson(map['info']);
      _canPlay = true;
      _showError = false;
    });
    _controller = VideoPlayerController.network(_player.playUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    value = _controller.value;
    _controller.addListener(() {
      if(alive){
        setState(() {
          value = _controller.value;
        });
      }
    });
  }
  _showControls() {
    if(alive){
      if (showControls) {
        setState(() {
          showControls = false;
        });
      } else {
        setState(() {
          showControls = true;
        });
        Timer(const Duration(seconds: 15), () {
          if(alive){
            setState(() {
              showControls = false;
            });
          }
        });
      }
    }
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
  _favorite() async{
    Map<String, dynamic> parm = {
      'id': widget.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.favoriteVideo, {"data": jsonEncode(parm)}));
    // print(result);
    if (result == null) {
    return;
    }
    Map<String, dynamic> map = jsonDecode(result);
    if(map['verify'] != null && map['verify'] == true){
      if(_player.favorite){
        Global.showWebColoredToast('取消收藏成功！');
      }else{
        Global.showWebColoredToast('收藏成功！');
      }
      setState(() {
        _player.favorite = !_player.favorite;
      });
    }
  }
  _report() async{
    Map<String, dynamic> parm = {
      'id': widget.id,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.reportVideo, {"data": jsonEncode(parm)}));
    // print(result);
    if (result == null) {
    return;
    }
    Map<String, dynamic> map = jsonDecode(result);
    if(map['verify'] != null && map['verify'] == true){
      Global.showWebColoredToast('举报成功！');
    }else if(map['msg'] != null){
      Global.showWebColoredToast(map['msg']);
    }
  }
  _buyVideo() async {
    if(await ShowAlertDialogBool(context, '购买付费视频', '确定花费 ${_player.diamond}钻石 购买本视频吗？')){
      Map<String, dynamic> parm = {
        'id': widget.id,
      };
      String? result = (await DioManager().requestAsync(
          NWMethod.GET, NWApi.buyVideo, {"data": jsonEncode(parm)}));
      print(result);
      if (result == null) {
        return;
      }
      Map<String, dynamic> map = jsonDecode(result);
      if(map['verify'] != null){
        if(map['verify'] == true){
          _initPlayer();
        }else if(map['msg'] != null){
          Global.showWebColoredToast(map['msg']);
        }else{
          Global.showWebColoredToast('未知错误，请刷新重试!');
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if(widget.id == 0) {
      Navigator.pop(context);
      return Container();
    }
    return CupertinoPageScaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xF5F5F5FF),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: _showError ?
      Container(
        decoration: const BoxDecoration(
            color: Colors.black54
        ),
        height: 250,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 20,top: 30,bottom: 20),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      _isReport
                          ? Container()
                          : InkWell(
                        onTap: () {
                          _report();
                        },
                        child: Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.only(
                              right: 20),
                          child: const Text(
                            '举报',
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(20)),
            const Text(
              '视频源出错，请点击右上角举报反馈',
              style:
              TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ) :
      Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: _canPlay
                ? Hero(
                    tag: 'player',
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the VideoPlayerController has finished initialization, use
                          // the data it provides to limit the aspect ratio of the video.
                          return AspectRatio(
                            // aspectRatio: _controller.value.aspectRatio,
                            aspectRatio: 16 / 9,
                            // Use the VideoPlayer widget to display the video.
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                VideoPlayer(_controller),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 20, top: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _favorite();
                                            },
                                            child:  Icon(
                                              _player.favorite ? Icons.favorite : Icons.favorite_border,
                                              color: _player.favorite ? Colors.red : Colors.grey,
                                            ),
                                            // child: Icon(Icons.favorite_outlined,color: Colors.red,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // ClosedCaption(text: _controller.value.caption.text),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 50),
                                  reverseDuration:
                                      const Duration(milliseconds: 200),
                                  child: _controller.value.isPlaying
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 60),
                                          // color: Colors.black54,
                                          child: InkWell(
                                            onTap: () {
                                              _showControls();
                                            },
                                            child: Container(),
                                          ),
                                        )
                                      : Center(
                                          child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _controller.play();
                                            });
                                          },
                                          child: Container(
                                            color: Colors.black26,
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 100.0,
                                              semanticLabel: 'Play',
                                            ),
                                          ),
                                        )),
                                ),
                                showControls
                                    ? AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 50),
                                        reverseDuration:
                                            const Duration(milliseconds: 200),
                                        child: Container(
                                          color: Colors.black26,
                                          height: 55,
                                          // color: Colors.black,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              VideoProgressIndicator(
                                                _controller,
                                                allowScrubbing: true,
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    bottom: 5,
                                                    right: 10),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _controller.value
                                                                    .isPlaying
                                                                ? _controller
                                                                    .pause()
                                                                : _controller
                                                                    .play();
                                                          });
                                                        },
                                                        child: Icon(
                                                          _controller.value
                                                                  .isPlaying
                                                              ? Icons.pause
                                                              : Icons
                                                                  .play_arrow,
                                                          color: Colors.white,
                                                          size: 36.0,
                                                          semanticLabel: 'Play',
                                                        ),
                                                      ),
                                                      value.volume > 0
                                                          ? InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  _controller
                                                                      .setVolume(
                                                                          0);
                                                                });
                                                              },
                                                              child: const Icon(
                                                                Icons.volume_up,
                                                                color: Colors
                                                                    .white,
                                                                size: 36.0,
                                                                semanticLabel:
                                                                    'Play',
                                                              ),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  _controller
                                                                      .setVolume(
                                                                          100);
                                                                });
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .volume_off,
                                                                color: Colors
                                                                    .white,
                                                                size: 36.0,
                                                                semanticLabel:
                                                                    'Play',
                                                              ),
                                                            ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        color:
                                                            Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '${Global.inSecondsTostring(value.position.inSeconds)}/${Global.inSecondsTostring(value.duration.inSeconds)}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return VideoFullPage(
                                                              _controller,
                                                              title:
                                                                  _player.title,
                                                            );
                                                          })).then((value) {
                                                            AutoOrientation
                                                                .portraitUpMode();
                                                            setState(() {
                                                              SystemChrome
                                                                  .setEnabledSystemUIMode(
                                                                      SystemUiMode
                                                                          .leanBack,
                                                                      overlays: [
                                                                    SystemUiOverlay
                                                                        .bottom
                                                                  ]);
                                                            });
                                                          });
                                                        },
                                                        child: const Icon(
                                                          Icons.fullscreen,
                                                          color: Colors.white,
                                                          size: 36.0,
                                                          semanticLabel: 'Play',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : VideoProgressIndicator(_controller,
                                        allowScrubbing: true),
                              ],
                            ),
                          );
                        } else {
                          // If the VideoPlayerController is still initializing, show a
                          // loading spinner.
                          return Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 20, top: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        _isReport
                                            ? Container()
                                            : InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  color: Colors.transparent,
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  child: const Text(
                                                    '举报',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: _player.pic.isEmpty ? null :  BoxDecoration(
                                  color: Colors.black54,
                                  // borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(_player.pic),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                height: 200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  )
                : Container(
                    decoration: _player.pic.isEmpty ? null :  BoxDecoration(
                      // borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(_player.pic),
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                    height: 250,
                    child: Container(
                      color: Colors.black87,
                      child: Center(
                        child: _player.diamond > 0 ?
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 20,top: 30,bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _isReport
                                          ? Container()
                                          : InkWell(
                                        onTap: () {
                                          _report();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.only(
                                              right: 20),
                                          child: const Text(
                                            '举报',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              '本视频需要购买才可以观看哦',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push<void>(
                                            CupertinoPageRoute(
                                              title: "钻石购买",
                                              // fullscreenDialog: true,
                                              builder: (context) =>
                                                  const BuyDiamondPage(),
                                            ),
                                          )
                                          .then((value) => setState);
                                    },
                                    child: const Text(
                                      '充值钻石',
                                      style: TextStyle(color: Colors.white,),
                                        textAlign: TextAlign.right
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                    ),
                                    onPressed: () {
                                      _buyVideo();
                                    },
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '支付${Global.getNumbersToChinese(_player.diamond)}',
                                              style: const TextStyle(color: Colors.orange),
                                              textAlign: TextAlign.right,
                                            ),
                                            Image.asset(ImageIcons.diamond.assetName,width: 12,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ) :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _isReport
                                          ? Container()
                                          : InkWell(
                                        onTap: () {
                                          _report();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.only(
                                              right: 20),
                                          child: const Text(
                                            '举报',
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              '开通Vip可以观看完整版哦',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push<void>(
                                            CupertinoPageRoute(
                                              title: "VIP购买",
                                              // fullscreenDialog: true,
                                              builder: (context) =>
                                                  const VIPBuyPage(),
                                            ),
                                          )
                                          .then((value) => setState);
                                    },
                                    child: const Text(
                                      '开通VIP',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                    ),
                                    onPressed: () {
                                      Global.showDialogVideo(_player);
                                    },
                                    child: const Text(
                                      '立即分享',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView(
                    children: [
                      Container(
                        color: Colors.white,
                        // margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width / 1.2),
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, top: 10, bottom: 10),
                                  child: Text(_player.title,
                                    style: const TextStyle(fontSize: 18,color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(Global.getNumbersToChinese(_player.play)),
                                          const Text(
                                            '播放',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: Text(
                                          '完整版时长 ${Global.inSecondsTostring(_player.duration)}',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
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
                                      Text('${Global.getNumbersToChinese(_player.recommendations)}人'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _player.actor.name == null || _player.actor.name.isEmpty ? Container() :
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  '演员信息',
                                  style:  TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context, rootNavigator: true).push<void>(
                                          CupertinoPageRoute(
                                            title: '演员详情',
                                            // fullscreenDialog: true,
                                            builder: (context) =>  ActorDetailsPage(aid: _player.actor.id),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        margin:
                                        const EdgeInsets.only(left: 10, top: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                            BorderRadius.circular(50.0),
                                            image: DecorationImage(
                                              image: _buildActorAvatar(_player.actor.avatar),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      // height: 25,
                                      child: Text(
                                        _player.actor.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 20),
                          child: Container(
                            margin: const EdgeInsets.only(left: 5,right: 5),
                            child: _buildLists(),
                          )),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  height: 72,
                  margin: const EdgeInsets.only(bottom: 60),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(33.0),
                      border: Border.all(width: 3, color: Colors.white24)),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async{
                            if(_player.downloadUrl==null || _player.downloadUrl.isEmpty){
                              if(_player.diamond > 0){
                                Global.showWebColoredToast("无法下载未购买影片！");
                              }else{
                                Global.showWebColoredToast("未开通会员无法下载影片！");
                              }
                              return;
                            }
                            Global.downloadFunction(_player.downloadUrl, _player.title);
                            if(await ShowAlertDialogBool(context, '提交下载', "已提交后台下载！是否转到下载管理？")){
                              Global.showDownloadPage();
                            }
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                ImageIcons.icon_download.assetName,
                                width: 30,
                              ),
                              const Text(
                                '下载',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Global.showDialogVideo(_player);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                ImageIcons.icon_share.assetName,
                                width: 30,
                              ),
                              const Text(
                                '分享',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Global.showDialogVideoRecommended(_player);
                  },
                  child: Container(
                    width: 63,
                    height: 63,
                    margin: const EdgeInsets.only(bottom: 83),
                    decoration: BoxDecoration(
                        // color: Colors.black54,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(ImageIcons.zanIcon.assetName))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLists() {
    List<Widget> widgets = [];
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            '精彩推荐',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
    widgets.addAll(_buildList());
    return Column(
      children: widgets,
    );
  }
  List<Widget> _buildList() {
    List<Widget> widgets = [];
    for (int i = 0; i < _avLists.length; i++) {
      widgets.add(_buildListItem(i));
    }
    return widgets;
  }
  Widget _buildListItem(int index) {
    SearchList list = _avLists[index];
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(list.image),
                    fit: BoxFit.fill,
                ),
            ),
            child: Global.buildPlayIcon(() {
              // Navigator.pop(context);
              _controller.pause();
              Global.playVideo(list.id);
            }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 100,
            width: ((MediaQuery.of(context).size.width) / 2.5),
            // color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: ((MediaQuery.of(context).size.width) / 2.5),
                        child: Text(
                          list.title.length > 30 ? '${list.title.substring(0,30)}...' : list.title,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          Global.getNumbersToChinese(list.play),
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
                          '${Global.getNumbersToChinese(list.remommends)}人',
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
    alive = false;
    _controller.removeListener(() { });
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
