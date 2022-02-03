import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';


class ImageClipperTest extends StatefulWidget {
  final String pic;
  const ImageClipperTest({
    Key? key,
    required this.pic
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ImageClipperTestState();
  }
}

class _ImageClipperTestState extends State<ImageClipperTest> {
  late ImageClipper clipper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片裁剪'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Container(color: Colors.grey, child: Image.network(widget.pic,fit: BoxFit.fill,)),
              width: 200,
              height: 150,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                color: Colors.green,
                child: CustomPaint(
                  painter: clipper,
                  size: Size(100, 100),
                )),
            RaisedButton(child: Text('Clip'), onPressed: () => clip())
          ],
        ),
      ),
    );
  }

  Future<ui.Image> _loadImge() async {
    ImageStream imageStream = NetworkImage(widget.pic).resolve(ImageConfiguration());
    Completer<ui.Image> completer = Completer<ui.Image>();
    void imageListener(ImageInfo info, bool synchronousCall) {
      ui.Image image = info.image;
      completer.complete(image);
      imageStream.removeListener(ImageStreamListener(imageListener));
    }

    imageStream.addListener(ImageStreamListener(imageListener));
    return completer.future;
  }

  clip() async {
    late ui.Image uiImage;
    _loadImge().then((image){uiImage = image;}).whenComplete(() {
      clipper = ImageClipper(uiImage);
      setState(() {});
    });
  }
}
/// 图片裁剪
class ImageClipper extends CustomPainter {
  final ui.Image image;
  final double left;
  final double top;
  final double right;
  final double bottom;

  ImageClipper(this.image,{this.left = 0.3,this.top = 0.3,this.right = 0.6,this.bottom = 0.6});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(image.width * left, image.height * top,
            image.width * right, image.height * bottom),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}