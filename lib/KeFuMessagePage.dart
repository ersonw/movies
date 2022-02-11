import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/data/KefuMessage.dart';
import 'package:movies/image_icon.dart';
import 'package:movies/model/KeFuMessageModel.dart';
import 'package:movies/utils/UploadOss.dart';
import 'package:movies/utils/UploadOssUtil.dart';

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
  final MessagesChangeNotifier _messagesChangeNotifier = MessagesChangeNotifier();
  final KeFuMessageModel _keFuMessageModel = KeFuMessageModel();

  @override
  void initState() {
    super.initState();
    _keFuMessageModel.read();
    messages = _keFuMessageModel.kefuMessages;
    _messagesChangeNotifier.addListener(() {
      messages = _keFuMessageModel.kefuMessages;
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
          Container(
            width: double.infinity,
            height: 70.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 7.0, 16.0, 7.0),
              decoration: BoxDecoration(
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
                      child: Image(image: ImageIcons.tuku)),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
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
                        decoration: InputDecoration(
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
                      child: Text(
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
      _keFuMessageModel.add(message);
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

      String? images = await UploadOssUtil.upload(File(image), Global.getNameByPath(image));
      if(images != null){
        message.image = images;
        _keFuMessageModel.add(message);
        toDown();
      }
      print(images);
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
                  Card(
                      margin: EdgeInsets.only(right: 10),
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 1.5,
                        child: message.image == null
                            ? Text(
                                message.text!,
                                textAlign: TextAlign.left,
                              )
                            : TextButton(
                                onPressed: () {},
                                child: Image.network(message.image!,width: 150,height: 150,)),
                      )),
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
                        image: DecorationImage(
                          image: AssetImage('assets/image/16pic_8733770_b.jpg'),
                        )),
                  ),
                  Card(
                      margin: EdgeInsets.only(right: 10),
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 1.5,
                        child: message.image == null
                            ? Text(
                                message.text!,
                                textAlign: TextAlign.left,
                              )
                            : TextButton(
                                onPressed: () {},
                                child: Image.file(
                                  File(message.image!),
                                  width: 150,
                                  height: 150,
                                )),
                      )),
                ],
              ),
      ],
    );
  }
}
