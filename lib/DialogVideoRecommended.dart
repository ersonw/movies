import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'data/Player.dart';
import 'global.dart';

class DialogVideoRecommended extends Dialog {
  Player player;
  DialogVideoRecommended({Key? key, required this.player})
      : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(

        ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  _close(context);
                },
              ),
              _dialog(context),
            ],
          )),
    );
  }
  _close(BuildContext context){
    Navigator.pop(context);
    // _textEditingController.dispose();
    // Navigator.pop(context);
    // Navigator.popUntil(context, (route) {
    //   if(route.isCurrent){
    //     return false;
    //   }
    //   return true;
    // });

  }
  Widget _dialog(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // _close(context);
          },
          child: Container(

            margin: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Container(
                  width: 350,
                  height: 200,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(player.pic),
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                  ),
                  // child: Global.buildPlayIcon(() {}),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width) / 1.3,
                      child: Text(player.title,
                        style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal,overflow: TextOverflow.ellipsis),),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width) / 1.3,
                      child: Text(player.tag,
                        style: const TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.normal,overflow: TextOverflow.ellipsis),),
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: InkWell(
                    child:  Container(
                      height: 100,
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        maxLength: 100,
                        maxLines: 5,
                        minLines: 1,
                        controller: _textEditingController,
                        keyboardType: TextInputType.multiline,
                        onEditingComplete: () {
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(100)
                        ],
                        // controller: _controller,
                        decoration: const InputDecoration(
                            // isDense: true,
                            contentPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black45),
                            hintText: "请详细描述你推荐此片的理由"),
                      ),
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Container(
                        width: 120,
                        height: 30,
                        margin: const EdgeInsets.only(top: 5,bottom: 20,left: 20),
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('取消',style: TextStyle(fontSize: 15,color: Colors.black),textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: 120,
                        height: 30,
                        margin: const EdgeInsets.only(top: 5,bottom: 20,left: 20),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('确认推荐',style: TextStyle(fontSize: 15,color: Colors.white),textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
