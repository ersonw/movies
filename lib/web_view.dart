import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String url;
  bool? inline;
  WebViewExample ({Key? key, required this.url, this.inline}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('网页访问'),),
      // navigationBar: widget.inline == true ? const CupertinoNavigationBar(previousPageTitle: '',) : const CupertinoNavigationBar(),
      navigationBar: const CupertinoNavigationBar(),
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
      ),
    );
  }
}