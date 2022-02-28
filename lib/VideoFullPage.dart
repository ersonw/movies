import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFullPage extends StatefulWidget {
  final VideoPlayerController controller;
  String? title;
  VideoFullPage(this.controller,{this.title});

  @override
  _VideoFullState createState() => _VideoFullState();
}

class _VideoFullState extends State<VideoFullPage> {
  bool isLand = true;
  late VideoPlayerController _controller;
  late VideoPlayerValue value;
  bool showControls = false;
  bool _isAlive = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _controller = widget.controller;
    value = _controller.value;
    _controller.addListener(() {
      if (_isAlive) {
        setState(() {
          value = _controller.value;
        });
      }
    });
    AutoOrientation.landscapeLeftMode();
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

  _inSecondsTostring(int seconds) {
    if (seconds < 60) {
      return '00:${seconds}';
    } else {
      int i = seconds ~/ 60;
      double d = seconds / 60;
      if (d < 60) {
        return '$i:${((d - i) * 60).toStringAsFixed(0)}';
      } else {
        int ih = i ~/ 60;
        double id = i / 60;
        return '$ih:${((id - ih) * 60).toStringAsFixed(0)}:${((d - i) * 60).toStringAsFixed(0)}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Center(
              child: Hero(
                tag: "player",
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                      // ClosedCaption(text: _controller.value.caption.text),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 50),
                        reverseDuration: const Duration(milliseconds: 200),
                        child: _controller.value.isPlaying
                            ? Container(
                          // color: Colors.black54,
                          margin: const EdgeInsets.all(40),
                          child: InkWell(
                              onTap: () {
                                _showControls();
                              },
                              child: Container()),
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
                        duration: const Duration(milliseconds: 50),
                        reverseDuration:
                        const Duration(milliseconds: 200),
                        child: Container(
                          width: ((MediaQuery.of(context).size.width) / 1.0),
                          color: Colors.black26,
                          // color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.title!,style: const TextStyle(color: Colors.white,fontSize: 15),)
                            ],
                          ),
                        ),
                      ) : Container(),
                      showControls
                          ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 50),
                        reverseDuration:
                        const Duration(milliseconds: 200),
                        child: Container(
                          color: Colors.black26,
                          height: 60,
                          // color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.only(
                                    left: 10, top: 15, right: 10),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _controller.value.isPlaying
                                                ? _controller.pause()
                                                : _controller.play();
                                          });
                                        },
                                        child: Icon(
                                          _controller.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
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
                                                .setVolume(0);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.volume_up,
                                          color: Colors.white,
                                          size: 36.0,
                                          semanticLabel: 'Play',
                                        ),
                                      )
                                          : InkWell(
                                        onTap: () {
                                          setState(() {
                                            _controller
                                                .setVolume(100);
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
                                        margin: const EdgeInsets.only(
                                            left: 10),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${_inSecondsTostring(value.position.inSeconds)}/${_inSecondsTostring(value.duration.inSeconds)}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isLand) {
                                                isLand = !isLand;
                                                AutoOrientation
                                                    .portraitUpMode();
                                              } else {
                                                isLand = !isLand;
                                                AutoOrientation
                                                    .landscapeLeftMode();
                                              }
                                            });
                                          },
                                          child: const Icon(
                                            Icons.screen_rotation_outlined,
                                            color: Colors.white,
                                            size: 27.0,
                                            semanticLabel: 'Play',
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _isAlive = false;
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(
                                          Icons.fit_screen,
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
                          allowScrubbing: true,padding: const EdgeInsets.only(top: 20),),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, right: 20),
              child: IconButton(
                icon: const BackButtonIcon(),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(isLand
      //       ? Icons.screen_lock_landscape
      //       : Icons.screen_lock_portrait),
      //   onPressed: () {
      //     setState(() {
      //       if (isLand) {
      //         isLand = !isLand;
      //         AutoOrientation.portraitUpMode();
      //       } else {
      //         isLand = !isLand;
      //         AutoOrientation.landscapeLeftMode();
      //       }
      //     });
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    _isAlive = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,
        overlays: [SystemUiOverlay.bottom]);
    super.dispose();
    if (isLand == true) {
      AutoOrientation.portraitUpMode();
    }
  }
}
