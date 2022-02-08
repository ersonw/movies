import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/functions.dart';
import 'package:movies/web_view.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({Key? key}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey();
  late QRViewController controller;
  Barcode? result;
  String text = '对着二维码扫';

//in order to get hot reload to work.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫一扫二维码'),
        backgroundColor: Colors.transparent,
      ),
      // backgroundColor: Colors.grey,
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: onQRViewCreated,
                  overlay: QrScannerOverlayShape(
//customizing scan area
                    borderWidth: 10,
                    borderColor: Colors.teal,
                    borderLength: 20,
                    borderRadius: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await controller.flipCamera();
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.flash_on,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await controller.toggleFlash();
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              // margin: EdgeInsets.all(8.0),
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController p1) {
//called when View gets created.
    this.controller = p1;
    controller.scannedDataStream.listen((scanevent) {
      setState(() {
//UI gets created with new QR code.
        var str = '${scanevent.code}';
        if(result == null){
          result = scanevent;
        }else if(str == '${result!.code}'){
          return;
        }
        Navigator.pop(context);
        if(str.contains('http')){
          // print(str);
          Navigator.push(context, CupertinoPageRoute(
            // builder: (context) => TakePictureScreen(cameras: Global.cameras, ),
            builder: (context) => WebViewExample(url: str),
          ),
          );
        }else{
          // text = '未识别内容:${str}';
          // Navigator.pop(context);
          ShowCopyDialog(context, '二维码扫描', str);
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
