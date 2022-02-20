import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/data/KefuMessage.dart';
import 'package:movies/data/WebSocketMessage.dart';
import 'package:movies/functions.dart';
import 'package:movies/image_icon.dart';
import 'package:movies/model/KeFuMessageModel.dart';
import 'package:movies/utils/UploadOssUtil.dart';

import 'PhotpGalleryPage.dart';
import 'global.dart';

class KeFuMessagePage extends StatefulWidget {
  const KeFuMessagePage({Key? key}) : super(key: key);

  @override
  _KeFuMessagePage createState() => _KeFuMessagePage();
}

class _KeFuMessagePage extends State<KeFuMessagePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isDown = false;
  List<KefuMessage> messages = [];

  @override
  void initState() {
    super.initState();
    keFuMessageModel.read();
    messages = keFuMessageModel.kefuMessages;
    messagesChangeNotifier.addListener(() {
      messages = keFuMessageModel.kefuMessages;
    });
    _textEditingController.addListener(() {
      // print(_controller.text);
    });
    // print(_scrollController.position.maxScrollExtent);
    _scrollController.addListener(() {
      if (_scrollController.offset
              .compareTo(_scrollController.position.maxScrollExtent) ==
          0) {
        _isDown = true;
      } else {
        _isDown = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text("反馈详情")],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: _build(),
          ),
          //这个就是固定低栏
          SizedBox(
            width: double.infinity,
            height: 70.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, 7.0, 16.0, 7.0),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        // Navigator.pop(context);
                        List<Media>? res = await ImagesPicker.pick(
                          count: 1,
                          pickType: PickType.image,
                          language: Language.System,
                          maxTime: 30,
                          // maxSize: 500,
                          cropOpt: CropOption(
                              aspectRatio: CropAspectRatio.custom,
                              cropType: CropType.circle),
                        );
                        if (res != null) {
                          var image = res[0].thumbPath;
                          setState(() {
                            sendPicture(image!);
                          });
                        }
                      },
                      child: const Image(image: ImageIcons.tuku)),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: const BoxDecoration(
                          color: Color(0xfff6f8fb),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _textEditingController,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          setState(() {
                            sendMessage();
                          });
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200)
                        ],
                        // controller: _controller,
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0xffcccccc)),
                            hintText: "说点什么吧"),
                      ),
                    ),
                  ),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amberAccent),
                      ),
                      onPressed: () {
                        setState(() {
                          sendMessage();
                        });
                      },
                      child: const Text(
                        "发送",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      KefuMessage message = KefuMessage();
      message.text = _textEditingController.text;
      message.date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      message.isMe = true;
      keFuMessageModel.add(message);
      _sendToServer(message);
      _textEditingController.text = '';
      toDown();
    }
  }
  void sendPicture(String image) async{
    if (image.isNotEmpty) {
      KefuMessage message = KefuMessage();
      message.image = image;
      message.date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      message.isMe = true;
      message.status = WebSocketMessage.message_kefu_sending;
      setState(() {
        keFuMessageModel.add(message);
      });
      String? images = await UploadOssUtil.upload(File(image), Global.getNameByPath(image));
      if(images == null){
        message.status = WebSocketMessage.message_kefu_send_fail;
        setState(() {
          keFuMessageModel.change(message);
        });
      }else{
        message.image = images;
        setState(() {
          keFuMessageModel.change(message);
        });
        _sendToServer(message);
      }

      toDown();
      // print(images);
    }
  }
  void _sendToServer(KefuMessage message) async{
    message.isRead = true;
    if(await Global.sendKeFuMessage(message) == false){
      keFuMessageModel.status(message.id,WebSocketMessage.message_kefu_send_fail);
    }
  }
  void _reSend(KefuMessage message) async {
    if(await ShowAlertDialogBool(context, '重新发送', '确定要重新发送此条消息吗？')){
      keFuMessageModel.status(message.id, WebSocketMessage.message_kefu_sending);
      setState(() {
        keFuMessageModel.change(message);
      });
      if(message.image?.contains('http') != true){
        String? images = await UploadOssUtil.upload(File(message.image!), Global.getNameByPath(message.image!));
        if(images != null){
          message.image = images;
          _sendToServer(message);
        }else{
          keFuMessageModel.status(message.id, WebSocketMessage.message_kefu_send_fail);
        }
        setState(() {
          keFuMessageModel.change(message);
        });
        return;
      }
      _sendToServer(message);
    }
  }
  void _deleteMessage(KefuMessage _message){
    Timer(const Duration(microseconds: 500), (){
      setState(() {
        keFuMessageModel.del(_message);
      });
    });
  }
  void _cancelSending(KefuMessage _message) async {
    if(await ShowAlertDialogBool(context, '取消发送', '确定要取消发送此条消息吗？')){
      if(keFuMessageModel.getStatus(_message.id) == WebSocketMessage.message_kefu_sending){
        _deleteMessage(_message);
      }
    }
  }
  void toDown() {
    // Global.messages.kefuMessage = messages;
    // Global.saveMessages();
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000), curve: Curves.ease);
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
  void _showPicButton(KefuMessage _message){
    Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (c, a, s) {
              return PhotpGalleryPage(
                index: 0,
                photoList: [_message.image],
              );
            },
        )
    );
  }
  Widget _build() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            toDown();
          },
          backgroundColor: Colors.blue),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext _context, int index) {
          return _buildList(index);
        },
      ),
    );
  }
  Widget _buildSending(KefuMessage message){
    Widget widget = Container();
    switch(message.status){
      case WebSocketMessage.message_kefu_sending:
        widget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              width: 36,
              height: 36,
              child: TextButton(
                onPressed: () {
                  _cancelSending(message);
                },
                child: const Icon(Icons.autorenew, color: Colors.black,),
              ),
            )
          ],
        );
        break;
      case WebSocketMessage.message_kefu_send_success:
        // widget = Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children:  const [
        //     SizedBox(
        //       width: 30,
        //       height: 30,
        //       child: Icon(Icons.check_circle, color: Colors.green,),
        //     )
        //   ],
        // );
        break;
      case WebSocketMessage.message_kefu_send_fail:
        widget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              // margin: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  _reSend(message);
                },
                child: const Icon(Icons.info,color: Colors.red,),
              ),
            )
          ],
        );
        break;
      default:
        break;
    }
    return widget;
  }

  Widget _showPic(KefuMessage _message){
    String image = _message.image ?? '';
    if(image.contains("http")){
      return Image.network(
        image,
        width: 150,
        height: 150,
        errorBuilder: (context, url, StackTrace? error) {
          // print(error!);
          _deleteMessage(_message);
          return const Icon(Icons.disabled_by_default,color: Colors.red,);
        },
      );
    }
    return Image.file(
      File(image),
      width: 150,
      height: 150,
      errorBuilder: (context, url, StackTrace? error) {
        // print(error!);
        _deleteMessage(_message);
        return const Icon(Icons.disabled_by_default,color: Colors.red,);
      },
    );
  }
  Widget _showMessageCard(KefuMessage message){
    if(message.text == null){
      return Card(
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            // width: (MediaQuery.of(context).size.width) / 1.5,
            child: TextButton(
                onPressed: () {
                  _showPicButton(message);
                },
                child: _showPic(message)),
          ));
    }else{
      Size size = Global.boundingTextSize(message.text!,TextStyle());
      double width = size.width + 20;
      if(size.width > (MediaQuery.of(context).size.width) / 1.5){
        width = (MediaQuery.of(context).size.width) / 1.5;
      }
      return Card(
          margin: const EdgeInsets.only(right: 10),
          child: Container(
            margin: const EdgeInsets.only(left: 10,right: 10),
            width: width,
            child: TextButton(
              onPressed: () {  },
              child: Text(
                message.text!,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ));
    }
  }
  Widget _buildList(int index) {
    KefuMessage message = messages[index];
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Global.getDateTime(message.date)),
        message.isMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildSending(message),
                  _showMessageCard(message),
                  Container(
                    width: 45,
                    height: 45,
                    // margin: EdgeInsets.only(left: vw()),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50.0),
                        image: DecorationImage(
                          // image: AssetImage('assets/image/default_head.gif'),
                          image: NetworkImage(Global.profile.user.avatar!),
                        )),
                  ),
                  // message.image == null ? Text(message.text!) : Image(image: NetworkImage(message.image!)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    // margin: EdgeInsets.only(left: vw()),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/image/16pic_8733770_b.jpg'),
                        )),
                  ),
                  _showMessageCard(message),
                ],
              ),
      ],
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.clear();
  }
}
