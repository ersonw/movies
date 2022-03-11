import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movies/functions.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:movies/DownloadFile.dart';
import 'package:video_player/video_player.dart';
import 'VideoFullPage.dart';
import 'data/Download.dart';
import 'global.dart';
class DownloadsManager extends StatefulWidget {
   const DownloadsManager({Key? key}) : super(key: key);

  @override
  _DownloadsManager createState() => _DownloadsManager();
}
class _DownloadsManager extends State<DownloadsManager>{
  double currentProgress =0.0;
  List<Download> downloads = [];
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool alive = true;

  @override
  void initState() {
    // TODO: implement initState
    downloads = configModel.downloads;
    // Download download = Download();
    // download.title = '打算几点啦山地马拉松满打满算离开地面萨大妈来的撒';
    // download.progress = 0.7;
    // download.error = true;
    // downloads.add(download);
    super.initState();
    configModel.addListener(() {
      if(alive){
        setState(() {
          downloads = configModel.downloads;
        });
      }
    });
    // downApkFunction();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // DownloadFile.cancelDownload(widget.url);
    alive = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
        child: ListView.builder(
          itemCount: downloads.length,
            itemBuilder: (BuildContext _context, int index) => _buildListItem(index),
        ),
    );
  }
  _buildListItem(index){
    Download download = downloads[index];

    return Slidable(
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 60,
        decoration:  BoxDecoration(
          // color: Colors.red,
          // border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          border: Border.all(color: Colors.grey,width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: ((MediaQuery.of(context).size.width) / 1.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ((MediaQuery.of(context).size.width) / 1.5),
                          child: Text(download.title,style: const TextStyle(fontSize: 15 ,color: Colors.black,overflow: TextOverflow.ellipsis),),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('状态: ${download.error ? '错误': download.finish ? '已完成': '未完成'}',
                          style: const TextStyle(fontSize: 12,color: Colors.grey,),
                        ),
                        const Text('提示:左滑更多选项哦!',
                          style: TextStyle(fontSize: 12,color: Colors.grey,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              download.error ?
              InkWell(
                onTap: () => _reDownload(download),
                child: const Icon(Icons.replay_sharp,size: 30,color: Colors.black45,),
              ) : (download.finish ?
              InkWell(
                onTap: () => _playVideo(download),
                child: const Icon(Icons.play_circle_outline,size: 30,color: Colors.deepOrangeAccent,),
              ) :
              InkWell(
                onTap: () => _cancelDownload(download),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _circularProgressIndicator(download.progress),
                    Text('${(download.progress * 100).toStringAsFixed(0)}%',style: const TextStyle(fontSize: 12),),
                  ],
                ),
              )),
              // Icon(Icons.delete_forever,color: Colors.red,size: 30,),
              // const Padding(padding: EdgeInsets.only(right: 5)),
            ],
          ),
        ),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: (){},),
        children: [
          SlidableAction(
            onPressed: (BuildContext _context) => _deleteDownload(download),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever_outlined,
            label: '删除',
          ),
          SlidableAction(
            onPressed: (BuildContext _context){},
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            icon: Icons.exit_to_app_outlined,
            label: '导出',
          ),
        ],
      ),
    );
  }
  _reDownload(Download download) async{
    if(await ShowAlertDialogBool(context, '下载提示', '正在尝试重试下载任务，是否继续？')){
      Global.handlerDownload(download);
    }
  }
  _playVideo(Download download){
    if(download.path.isNotEmpty && download.finish){
      _controller = VideoPlayerController.file(File(download.path));
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
    }else{
      _controller = VideoPlayerController.network(download.url);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder:
            (context) {
          return VideoFullPage(
            _controller,
            title:
            download.title,
          );
        }));
  }
  _cancelDownload(Download download) async{
    if(await ShowAlertDialogBool(context, '下载提示', '正在尝试取消下载任务，是否继续？')){
      DownloadFile.cancelDownload(download.url);
      configModel.removeDownload(download.url);
      Global.showWebColoredToast('取消下载任务完成！');
    }
  }
  _deleteDownload(Download download) async{
    if(await ShowAlertDialogBool(context, '删除提示', '正在尝试删除下载任务，是否继续？')){
    DownloadFile.cancelDownload(download.url);
    configModel.removeDownload(download.url);
    File file = File(download.path);
    if(file.existsSync()){
      file.deleteSync();
    }
    Global.showWebColoredToast('取消下载任务完成！');
    }
  }
  LinearProgressIndicator _linearProgressIndicator(double _count){
    return LinearProgressIndicator(
      value: _count, // 当前进度
      backgroundColor: Colors.yellow, // 进度条背景色
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // 进度条当前进度颜色
      minHeight: 10, // 最小宽度
    );
  }
  CircularProgressIndicator _circularProgressIndicator(double _count){
    return CircularProgressIndicator(
      // semanticsLabel: '${(_count * 100).toStringAsFixed(0)}%',
      value: _count, // 当前进度
      strokeWidth: 5, // 最小宽度
      backgroundColor: Colors.grey, // 进度条背景色
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // 进度条当前进度颜色
    );
  }
}