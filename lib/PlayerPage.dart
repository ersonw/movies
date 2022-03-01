import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/Player.dart';
import 'package:movies/image_icon.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock/wakelock.dart';
import 'VIPBuyPage.dart';
import 'VideoFullPage.dart';
import 'global.dart';
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
  late VideoPlayerValue value;
  bool showControls = false;
  bool _canPlay = false;
  bool _isReport = true;

  @override
  void initState() {
    // TODO: implement initState
    Wakelock.enable();
    _controller = VideoPlayerController.network('https://v.qwe202.com/ae4477cab344bd2ba606c362aa4b4419/index.m3u8');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    value = _controller.value;
    _controller.addListener((){
      setState(() {
        value = _controller.value;
      });
    });
    super.initState();
  }
  _showControls(){
    if(showControls){
      setState(() {
        showControls = false;
      });
    }else{
      setState(() {
        showControls = true;
      });
      Timer(const Duration(seconds: 15), (){
        setState(() {
          showControls = false;
        });
      });
    }
  }
  _inSecondsTostring(int seconds){
    if(seconds < 60){
      return '00:${seconds}';
    }else{
      int i = seconds ~/ 60;
      double d = seconds / 60;
      if(d < 60){
        return '$i:${((d-i)*60).toStringAsFixed(0)}';
      }else{
        int ih = i ~/ 60;
        double id = i / 60;
        return '$ih:${((id-ih)*60).toStringAsFixed(0)}:${((d-i)*60).toStringAsFixed(0)}';
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xF5F5F5FF),
      navigationBar:  CupertinoNavigationBar(
        backgroundColor: Colors.black,
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _isReport ? Container() : InkWell(
              onTap: () {
              },
              child: Container(
                color: Colors.transparent,
                margin: const EdgeInsets.only(right: 20),
                child: const Text('举报',style: TextStyle(color: Colors.black),),
              ),
            ),
            InkWell(
              child: Image.asset(ImageIcons.like.assetName,color: Colors.white,width: 36,),
            ),
          ],
        ),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child:  Column(
        children: [
          Container(
            // margin: const EdgeInsets.only(top: 70),
            child: _canPlay ? Hero(tag: 'player',
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    // aspectRatio: _controller.value.aspectRatio,
                    aspectRatio: 16/9,
                    // Use the VideoPlayer widget to display the video.
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller),
                        // ClosedCaption(text: _controller.value.caption.text),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 50),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: _controller.value.isPlaying ?
                          InkWell(
                              onTap: () {
                                _showControls();
                              },
                              child: Container()
                          ) :  Center(
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
                              )
                          ),

                        ),
                        showControls ?
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 50),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: Container(
                            color: Colors.black26,
                            height: 55,
                            // color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                VideoProgressIndicator(_controller, allowScrubbing: true,padding: const EdgeInsets.only(left: 10,bottom: 5,right: 10),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                            });
                                          },
                                          child: Icon(
                                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 36.0,
                                            semanticLabel: 'Play',
                                          ),
                                        ),
                                        value.volume > 0 ? InkWell(
                                          onTap: (){
                                            setState(() {
                                              _controller.setVolume(0) ;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.volume_up,
                                            color: Colors.white,
                                            size: 36.0,
                                            semanticLabel: 'Play',
                                          ),
                                        ) : InkWell(
                                          onTap: (){
                                            setState(() {
                                              _controller.setVolume(100);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.volume_off,
                                            color: Colors.white,
                                            size: 36.0,
                                            semanticLabel: 'Play',
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Text('${_inSecondsTostring(value.position.inSeconds)}/${_inSecondsTostring(value.duration.inSeconds)}',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [

                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) {
                                              return VideoFullPage(_controller,title: '[hongkongdoll]玩偶姐姐森林新篇章-第二集-欺骗-失身又失心',);
                                            })).then((value) {
                                              AutoOrientation.portraitUpMode();
                                              setState(() {
                                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.bottom]);
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

                        ) : VideoProgressIndicator(_controller, allowScrubbing: true),
                      ],
                    ),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      // borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/image/06b6f2f7-484e-41e1-82e8-4b31d199e813.jpg'),
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                    height: 200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),) : Container(
              decoration: BoxDecoration(
                // borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/06b6f2f7-484e-41e1-82e8-4b31d199e813.jpg'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              height: 250,
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('开通Vip或可以观看完整版哦',style: TextStyle(color: Colors.white,fontSize: 20),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              ),
                              onPressed: (){
                                Navigator.of(context, rootNavigator: true).push<void>(
                                  CupertinoPageRoute(
                                    title: "VIP购买",
                                    // fullscreenDialog: true,
                                    builder: (context) => const VIPBuyPage(),
                                  ),
                                ).then((value) => setState);
                              },
                              child: const Text('开通VIP',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                              ),
                              onPressed: () {
                                Global.showDialogVideo('[hongkongdoll]玩偶姐姐森林新篇章-第二集-欺骗-失身又失心', '');
                              },
                              child: const Text('立即分享',style: TextStyle(color: Colors.white),),
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
                        Container(
                          margin: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                          child: Text('[hongkongdoll]玩偶姐姐森林新篇章-第二集-欺骗-失身又失心',style: TextStyle(fontSize: 18),),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text('9.3W'),
                                      const Text('播放',style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Text('完整版时长 ${_inSecondsTostring(value.duration.inSeconds)}',style: const TextStyle(color: Colors.grey),),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                                  Text('0人'),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Text('演员信息',style: TextStyle(fontSize: 20),)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: EdgeInsets.only(left: 10,top: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                        image: AssetImage(ImageIcons.actorIcon.assetName),
                                      )),
                                ),
                                SizedBox(
                                  width: 90,
                                  // height: 25,
                                  child: Text('HongKongDoll',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 5,right: 5,bottom: 20),
                      child: _buildLists()
                  ),
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
                    border: Border.all(width: 3,color: Colors.white24)
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 10,right: 20,left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          print('test');
                        },
                        child: Column(
                          children: [
                            Image.asset(ImageIcons.icon_download.assetName,width: 30,),
                            const Text('下载',style: TextStyle(color: Colors.red),),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          print('test');
                        },
                        child: Column(
                          children: [
                            Image.asset(ImageIcons.icon_share.assetName,width: 30,),
                            const Text('分享',style: TextStyle(color: Colors.red),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  print('test');
                },
                child: Container(
                  width: 63,
                  height: 63,
                  margin: const EdgeInsets.only(bottom: 83),
                  decoration: BoxDecoration(
                    // color: Colors.black54,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(ImageIcons.zanIcon.assetName)
                      )
                  ),
                ),
              ),
            ],
          ),),
        ],
      ),
    );
  }
  Widget _buildLists(){
    List<Widget> widgets = [];
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text('精彩推荐',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
        ],
      ),
    ));
    widgets.addAll(_buildList());
    return Column(
      children: widgets,
    );
  }
  List<Widget> _buildList(){
    List<Widget> widgets = [];
    for(int i=0; i < 20; i++){
      widgets.add(_buildListItem(i));
    }
    return widgets;
  }
  Widget _buildListItem(int index){
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
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
                        Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                        Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
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
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }
}