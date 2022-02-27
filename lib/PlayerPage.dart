import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _controller = VideoPlayerController.network('https://v.qwe202.com/ae4477cab344bd2ba606c362aa4b4419/index.m3u8');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.addListener(() {});
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 68),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
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
                          Container(
                            // color: Colors.black54,
                            margin: const EdgeInsets.all(40),
                            child: InkWell(
                                onTap: (){
                                  setState(() {
                                    _controller.pause();
                                  });
                                },
                                child: Container()
                            ),
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
                        // AnimatedSwitcher(
                        //   duration: const Duration(milliseconds: 50),
                        //   reverseDuration: const Duration(milliseconds: 200),
                        //   child: _controller.value.isPlaying ? Container() :  Center(
                        //       child: InkWell(
                        //         onTap: () {
                        //           setState(() {
                        //             _controller.play();
                        //           });
                        //         },
                        //         child: Container(
                        //           color: Colors.black26,
                        //           child: const Icon(
                        //             Icons.play_arrow,
                        //             color: Colors.white,
                        //             size: 100.0,
                        //             semanticLabel: 'Play',
                        //           ),
                        //         ),
                        //       )
                        //   ),
                        //
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       _controller.value.isPlaying ? _controller.pause() : _controller.play();
                        //       // _controller.pause();
                        //     });
                        //   },
                        // ),
                        VideoProgressIndicator(_controller, allowScrubbing: true),
                      ],
                    ),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
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
    super.dispose();
  }
}