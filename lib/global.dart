import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:movies/DownloadsManager.dart';
import 'package:movies/LoadingChangeNotifier.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/SlideRightRoute.dart';
import 'package:movies/SpreadVideoDialog.dart';
import 'package:movies/data/CashInOrder.dart';
import 'package:movies/data/KefuMessage.dart';
import 'package:movies/data/Messages.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/data/User.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/Profile.dart';
import 'package:movies/data/WebSocketMessage.dart';
import 'package:movies/functions.dart';
import 'package:movies/HttpManager.dart';
import 'package:movies/model/ConfigModel.dart';
import 'package:movies/model/KeFuMessageModel.dart';
import 'package:movies/model/UserModel.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:movies/utils/UploadOssUtil.dart';
import 'package:movies/web_view.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:movies/utils/UploadOss.dart';
import 'DialogVideoRecommended.dart';
import 'DownloadFile.dart';
import 'GameView.dart';
import 'LoadingDialog.dart';
import 'OnlinePayPage.dart';
import 'PlayerPage.dart';
import 'RestartWidget.dart';
import 'data/CashIn.dart';
import 'data/Download.dart';
import 'data/OnlinePay.dart';
import 'data/Player.dart';
import 'data/Profile.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:encrypt/encrypt.dart' as XYQ;

import 'main.dart';
final MessagesChangeNotifier messagesChangeNotifier = MessagesChangeNotifier();
final KeFuMessageModel keFuMessageModel = KeFuMessageModel();
final ConfigModel configModel = ConfigModel();
final UserModel userModel = UserModel();
final LoadingChangeNotifier loadingChangeNotifier = LoadingChangeNotifier();
final OpeninstallFlutterPlugin _openinstallFlutterPlugin = OpeninstallFlutterPlugin();
class Global {
  static const String REPORT_TESTS = 'effect_test';
  static const String REPORT_CREATE_ORDER = 'createOrder';
  static const String REPORT_OPEN_VIP = 'openVip';
  static const String REPORT_BIND_PHONE = 'bindPhone';
  static const String REPORT_PHONE_LOGIN = 'phoneLogin';
  static const String REPORT_PLAYER_GAME = 'playerGame';
  static const String REPORT_CASH_IN_GAME = 'cashInGame';
  static const String mykey = 'e797e49a5f21d99840c3a07dee2c3c7c';
  static const String myiv = 'e797e49a5f21d99840c3a07dee2c3c7a';
  static String codeInvite = '';
  static String channelCode = '';
  static bool channelIs = false;
  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  // static late PackageInfo packageInfo;
  static late final cameras;
  static bool _isLogin = false;
  static bool initMain = false;
  static late BuildContext MainContext;
  static late final String uid;
  static WebSocketChannel? channel;

  static Profile profile = Profile();
  static Messages messages = Messages();
  static late SharedPreferences _prefs;
  static bool mounted = false;
  static String? link;
  static bool isLoading = false;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initPlatformStateForStringUniLinks();
    // packageInfo = await PackageInfo.fromPlatform();
    loadingChangeNotifier.addListener(() {
      if(isLoading){
        Navigator.push(MainContext, DialogRouter(LoadingDialog(false)));
      }
    });
    // bool data = await fetchData();
    // print(data);
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    var _messages = _prefs.getString("messages");
    // print(_messages);
    if (_messages != null) {
      try {
        messages = Messages.formJson(jsonDecode(_messages));
      } catch (e) {
        print(e);
      }
    }
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    uid = await getUUID();
    // runApp(const GongGaoApp());
    if(await initNetworks()){
      await _initAssets();
      _openinstallFlutterPlugin.init(wakeupHandler);
      _openinstallFlutterPlugin.install(installHandler);
      await _init();
      await initSock();
      runApp(const MyAdaptingApp());
    }else{
      runApp(const GongGaoApp());
    }
  }
  static String encryptCode(String text){
    final key = XYQ.Key.fromUtf8(mykey);
    final iv = XYQ.IV.fromUtf8(myiv);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }
  static String decryptCode(String text){
    final encrypted = XYQ.Encrypted.fromBase64(text);
    final key = XYQ.Key.fromUtf8(mykey);
    final iv = XYQ.IV.fromUtf8(myiv);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    return encrypter.decrypt(encrypted, iv: iv);
  }
  static Future<void> showPayDialog(clickCallback callback)async{
    List<OnlinePay> list = await _initOnlinePays();
    Navigator.push(MainContext, DialogRouter(OnlinePayPage(list ,callback: callback,)));
  }
  static Future<void> reportOpen(String type)async{
    _openinstallFlutterPlugin.reportEffectPoint(type, 1);
  }
  static Future<List<OnlinePay>> _initOnlinePays() async {
    List<OnlinePay> list = [];
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getOnlinePays, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if (map != null && map["list"] != null){
        list = (map['list'] as List).map((e) => OnlinePay.formJson(e)).toList();
      }
    }
    return list;
  }
  static Future<void> installHandler(Map<String, dynamic> data) async {
    // print(data['channelCode']);
    // channelCode = '101';
    if(null != data['bindData']){
      Map<String, dynamic> map = jsonDecode(data['bindData']);
      if(null != map['code']){
        codeInvite = map['code'];
        _handlerInvite();
      }
      if(null != map['video']){
        if(int.tryParse(map['video']) != null){
          playVideo(int.parse(map['video']));
        }
      }
    }
    if(null != data['channelCode'] && data['channelCode'].toString().isNotEmpty){
      channelCode = data['channelCode'];
    }
    // handlerChannel();
  }
  static void handlerChannel(){
    if(channelCode == null || channelCode.isEmpty){
      return;
    }
    if(channelIs){
      return;
    }
    Map<String,dynamic> map = {
      'code': channelCode
    };
    DioManager().request(NWMethod.POST, NWApi.joinChannel,
        params: {'data': jsonEncode(map)}, success: (data) {
          print("success data = $data");
          if (data != null) {
            map = jsonDecode(data);
            if(map['msg'] != null) showWebColoredToast(map['msg']);
            if(map['verify'] != null) channelIs = (map['verify']);
          }
        }, error: (error) {});
  }
  static Future<void> wakeupHandler(Map<String, dynamic> data) async {
    if(null != data['bindData']){
      Map<String, dynamic> map = jsonDecode(data['bindData']);
      if(null != map['code']){
        codeInvite = map['code'];
        _handlerInvite();
      }
      if(null != map['video']){
        if(int.tryParse(map['video']) != null){
          playVideo(int.parse(map['video']));
        }
      }
    }
    if(null != data['channelCode']){
      channelCode = (data['channelCode']);
    }
  }
  static Future<void> toChat({bool game = false}) async {
    if (game) {
      Global.openWebview('${configModel.config.kefuGameUrl}${getUser()}', inline: true);
    }else{
      Global.openWebview('${configModel.config.kefuUrl}${getUser()}', inline: true);
    }
    // await Meiqiachat.toChat();
    // String? path = await getPhoneLocalPath();
    // if(path != null){
    //   path = path + '/index.html';
    //   File file = File(path);
    //   if(!(await file.exists())) {
    //     String data = await rootBundle.loadString( './assets/files/index.html');
    //     await file.writeAsString(data);
    //   }
    //   // print(file.uri);
    //   Global.openWebview(file.uri.toString(), inline: true);
    // }
    // Global.openWebview(Image.asset(''), inline: true);
  }
  static Future<void> toGameChat(CashInOrder order) async {
    Map<String, dynamic> content = <String,dynamic>{};
    content['title'] = '游戏充值订单号：${order.orderId}';
    content['img'] = 'http://23porn.oss-accelerate.aliyuncs.com/GoldCoins.png';
    content['price'] = '${(order.amount / 100).toStringAsFixed(2)}元';
    Global.openWebview('${configModel.config.kefuGameUrl}${getUser()}?content=${Uri.encodeComponent(jsonEncode(content))}', inline: true);
  }
  static String getUser(){
    String u = '/uid/${userModel.user.id}/name/${Uri.encodeComponent(userModel.user.nickname)}';
    if(userModel.user.avatar != null){
      // u = '$u/avatar/${Uri.encodeComponent(userModel.user.avatar!)}';
      // u = '$u/avatar/${userModel.user.avatar}';
    }
    return u;
  }
  static Future<String> _getShareUrl() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getShareCount, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['shareUrl'] != null){
        return map['shareUrl'];
      }
    }
    return '';
  }
  static Future<void> _initAssets()async {
    // String? path = await getPhoneLocalPath();
    // if(path != null){
      //
    // }
  }
  static Future<void> openH5Game(String url)async {
    Navigator.push(
      MainContext,
      SlideRightRoute(page: GameView(url: url,)),
    );
  }
  static Future<bool> initNetworks() async {
    // if(await _initNetwork() == false) {
    //   RestartWidget.restartApp(MainContext);
    //   return;
    // }
    // if(configModel.config.domain == null || configModel.config.domain.isEmpty){
      await requestPhotosPermission();
      //DIO网络访问
      try {
        Response response = await Dio().get('https://github1.oss-cn-hongkong.aliyuncs.com/ios/app-release.config');
        // Response response = await Dio().get('https://github1.oss-cn-hongkong.aliyuncs.com/ios/app-release.config.decode');
        // Response response = await Dio().get('http://23porn.oss-accelerate.aliyuncs.com/app-release.config');
        // Response response = await Dio().get('http://23porn.oss-accelerate.aliyuncs.com/app-release.config.decode');
        // print(response);
        String? result = response.data.toString();
        // List<int> bytes = utf8.encode(result);
        // base64.encode(bytes);
        // print(base64.encode(bytes));
        // List<int> decoded = base64.decode(result);
        // result = utf8.decode(decoded);
        result = decryptCode(result);
        // print(result);
        // result = encryptCode(result);
        // print(result);
        if (result != null) {
          Config config = configModel.config;
          Map<String, dynamic> map = jsonDecode(result);
          if (map['wsDomain'] != null) {
            config.wsDomain = map['wsDomain'];
          }
          if (map['domain'] != null) {
            config.domain = map['domain'];
          }
          configModel.config = config;
          await getUserInfo();
          return true;
        }
      } catch (e) {
        print(e);
      }
    // }
    return false;
  }
  static Future<bool> _initNetwork() async {
    try {
      String hostname = 'baidu.com';
      final r = await InternetAddress.lookup(hostname);
      if(r.isNotEmpty && r.first.address.isNotEmpty) {
        return true;
      }
    }catch (e) {
      print(e);
    }
    return false;
  }
  static Future<void> initPlatformStateForStringUniLinks() async {
    // late String initialLink;
    // // App未打开的状态在这个地方捕获scheme
    // try {
    //   initialLink = (await getInitialLink())!;
    //   print('initial link: $initialLink');
    //   if (initialLink != null) {
    //     print('initialLink--$initialLink');
    //     //  跳转到指定页面
    //     // schemeJump(context, initialLink);
    //   }
    // } on PlatformException {
    //   initialLink = 'Failed to get initial link.';
    // } on FormatException {
    //   initialLink = 'Failed to parse the initial link as Uri.';
    // }
    // // App打开的状态监听scheme
    //  String _sub = getLinksStream().listen((String link) {
    //   if (!mounted || link == null) return;
    //   print('link--$link');
    //   //  跳转到指定页面
    //   // schemeJump(context, link);
    // }, onError: (Object err) {
    //   if (!mounted) return;
    // }) as String;
  }
  static void changePassword(String old, String news){
    WebSocketMessage message = WebSocketMessage();
    message.code = WebSocketMessage.user_change_passwoed;
    Map<String, String> map = {};
    map['old'] = old;
    map['new'] = news;
    message.data = jsonEncode(map);
    channel?.sink.add(message.toString());
  }
  static void changeUserProfile(User user) async{
    if(user.avatar == null || user.avatar?.startsWith('http') == true){
      //
    }else{
      if(user.avatar != null && user.avatar != ''){
        String data = await QrCodeToolsPlugin.decodeFrom(user.avatar)
            .catchError((Object o, StackTrace s)  {
          print(o.toString());
        });
        if (data == null || data.isEmpty){
          String? images = await UploadOssUtil.upload(
              File(user.avatar!), Global.getNameByPath(user.avatar!));
          if (images == null) {
            showWebColoredToast("头像上传失败！");
            return;
          }
          user.avatar = images;
          userModel.user = user;
          showWebColoredToast("头像上传成功！");
        }else{
          showWebColoredToast("头像上传失败！不能上传带有二维码的图片作为头像");
          return;
        }
      }
    }

    WebSocketMessage message = WebSocketMessage();
    message.code = WebSocketMessage.user_change;
    message.data = user.toString();
    channel?.sink.add(message.toString());
  }
  static void showWebColoredToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      // webBgColor: '#FFFFFF',
      // textColor: Colors.black,
      timeInSecForIosWeb: 5,
    );
  }
  static Future<double> loadApplicationCache() async {
    /// 获取文件夹
    Directory directory = await getApplicationDocumentsDirectory();

    /// 获取缓存大小
    double value = await getTotalSizeOfFilesInDir(directory);
    return value;
  }
  static Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity>? children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children) {
          total += await getTotalSizeOfFilesInDir(child);
        }
      return total;
    }
    return 0;
  }
  static String formatSize(double? value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value! > 1024) {
      index++;
      value = (value / 1024);
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
  static Future<void> clearApplicationCache() async {
    Directory directory = await getApplicationDocumentsDirectory();
    //删除缓存目录
    await deleteDirectory(directory);
  }
  static Future<void> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
      }
    }
    await file.delete();
  }
  static Size boundingTextSize(String text, TextStyle style, {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  static String generateMd5(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
  static Future<void> initSock() async {
    String? wsUrl;
    if(configModel.config.wsDomain != null && configModel.config.wsDomain.isNotEmpty){
      wsUrl = configModel.config.wsDomain;
    }
    if(wsUrl != null && wsUrl.isNotEmpty){
      if(wsUrl.startsWith('http')){
        wsUrl = wsUrl.replaceAll('http', 'ws');
      }
    }
    // print(wsUrl);
    channel = WebSocketChannel.connect(
      Uri.parse(wsUrl ?? NWApi.baseWs),
    );
    channel?.stream.listen(
      channelListen,
      onDone: () async {
        // print(channel?.sink.runtimeType.toString());
        _isLogin = false;
        await Future.delayed(const Duration(milliseconds: 5000), () {
          initSock();
        });
      },
      onError: (error) async {
        print(error);
      },
    );
  }
  static Future<void> loginSocket() async {
    Timer(const Duration(seconds: 10), () {
      if(!_isLogin){
        // print(_isLogin);
        // print(userModel.isLogin);
        if (userModel.isLogin) {
          WebSocketMessage _message = WebSocketMessage();
          _message.code = WebSocketMessage.login;
          _message.data = jsonEncode({"token": userModel.token});
          channel?.sink.add(_message.toString());
        }else{
          // getUserInfo();
        }
      }
    });
  }
  static Future<bool> sendKeFuMessage(KefuMessage message) async {
    WebSocketMessage _message = WebSocketMessage();
    _message.code = WebSocketMessage.message_kefu_sending;
    _message.data = message.toString();
    if (channel != null) {
      channel?.sink.add(_message.toString());
      return true;
    }
    return false;
  }
  static Future<void> channelListen(data) async {
    loginSocket();
    if (data == 'H') return;
    WebSocketMessage message = WebSocketMessage.formJson(jsonDecode(data));
    switch (message.code) {
      case WebSocketMessage.login_success:
        _isLogin = true;
        break;
      case WebSocketMessage.login_fail:
        _isLogin = false;
        // userModel.token = '';
        break;
      case WebSocketMessage.message_kefu_send_fail:
        showWebColoredToast(message.message!);
        KefuMessage kefuMessage =
            KefuMessage.formJson(jsonDecode(message.data!));
        keFuMessageModel.status(kefuMessage.id, message.code);
        break;
      case WebSocketMessage.message_kefu_send_success:
        KefuMessage kefuMessage =
            KefuMessage.formJson(jsonDecode(message.data!));
        keFuMessageModel.status(kefuMessage.id, message.code);
        break;
      case WebSocketMessage.message_kefu_recevie:
        keFuMessageModel.add(KefuMessage.formJson(jsonDecode(message.data!)));
        break;
      case WebSocketMessage.user_change_fail:
        showWebColoredToast(message.message!);
        getUserInfo();
        break;
      case WebSocketMessage.user_change_success:
        // showWebColoredToast('修改成功!');
        // getUserInfo();
        break;
      case WebSocketMessage.user_change_passwoed_fail:
        showWebColoredToast(message.message!);
        break;
      case WebSocketMessage.user_change_passwoed_success:
        showWebColoredToast('密码修改成功!');
        break;
      default:
        break;
    }
    // print(_userModel.token);
  }
  static void playVideo(int id){
    // Navigator.of(MainContext, rootNavigator: true).push<void>(
    //   CupertinoPageRoute(
    //     builder: (context) => PlayerPage(id: id),
    //   ),
    // );
    Navigator.push(MainContext, SlideRightRoute(page:  PlayerPage(id: id)));
  }
  static Widget buildPlayIcon(Function fn){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => fn(),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: const Icon(Icons.play_arrow,color: Colors.white,size: 36,),
              ),
            ),
          ],
        ),
      ],
    );
  }
  static void showDownloadPage() async{

    // Navigator.of(MainContext, rootNavigator: true).push<void>(
    //   CupertinoPageRoute(
    //     title: "下载管理",
    //     // fullscreenDialog: true,
    //     builder: (context) => const DownloadsManager(),
    //   ),
    // );
    Navigator.push(MainContext, SlideRightRoute(page: const DownloadsManager()));

  }
  static String inSecondsTostring(int seconds) {
    if (seconds < 60) {
      return '00:${seconds < 10 ? '0$seconds' : seconds}';
    } else {
      int i = seconds ~/ 60;
      double d = seconds / 60;
      if (d < 60) {
        int t = ((d - i) * 60).toInt();
        return '${i < 10 ? '0$i': i}:${t < 10 ? '0$t': t}';
      } else {
        int ih = i ~/ 60;
        double id = i / 60;
        int t1 = ((id - ih) * 60).toInt();
        int t2 = ((d - i) * 60).toInt();
        return '${ih < 10 ? '0$ih' : ih }:${t1 < 10 ? '0$t1' : t1}:${t2 < 10 ? '0$t2' : t2}';
      }
    }
  }
  static String getTimeToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
  }
  static String getDateToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
  static String getNumbersToChinese(int n){
    if(n < 9999){
      return '$n';
    }else{
      double d= n / 10000;
      if(d < 9999){
        return '${d.toStringAsFixed(2)}万';
      }else{
        d= d / 10000;
        return '${d.toStringAsFixed(2)}亿';
      }
    }
  }
  static Future<Map<String, String>> getQueryString(String url)async{
    Map<String, String> map = <String, String>{};
    if(url.contains('?')){
      List<String> urls = url.split('?');
      if(urls.length > 1){
        url = urls[1];
        if(url.contains('&')){
          urls = url.split('&');
          for (int i =0;i< urls.length; i++){
            if(urls[i].contains('=')){
              List<String> temp = url.split('=');
              if(temp.length>1){
                map[temp[0]] = temp[1];
              }
            }
          }
        }else{
          List<String> temp = url.split('=');
          if(temp.length>1){
            map[temp[0]] = temp[1];
          }
        }
      }
    }
    return map;
  }
  static void handlerScan(String data) async{
    print(data);
    // String url = data.replaceAll(configModel.config.shareDomain, '');
    // if(url.contains('/')) url = url.replaceAll('/', '');
    // if(url.contains('-')){
    //   List<String> urls = url.split('-');
    //   int vid = int.parse(urls[0]);
    //   String code = urls[1];
    //   _handlerInvite(code: code);
    //   _handlerJoin(vid, code);
    // }else{
    //   _handlerInvite(code: url);
    // }
    Map<String, String> map = await getQueryString(data);
    if(map['code'] != null){
      _handlerInvite(code: map['code']! );
    }
    if(map['video'] != null && int.tryParse(map['video']!) != null){
      int vid = int.parse(map['video']!);
      playVideo(vid);
    }
  }
  static void _handlerInvite({String code = ''})async{
    if(code.isEmpty){
      code = codeInvite;
    }
    // showWebColoredToast(code);
    // showWebColoredToast(codeInvite);
    // if(code.isEmpty){
    //   return;
    // }
    Map<String,dynamic> map = {
      'code': code
    };
    DioManager().request(NWMethod.POST, NWApi.joinInvite,
        params: {'data': jsonEncode(map)}, success: (data) {
          print("success data = $data");
          if (data != null) {
            map = jsonDecode(data);
            if(map['msg'] != null) showWebColoredToast(map['msg']);
          }
        }, error: (error) {});
  }
  static String getDateTime(int date) {
    int t = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - date);
    String str = '';
    if (t > 60) {
      t = t ~/ 60;
      if (t > 60) {
        t = t ~/ 60;
        if (t > 24) {
          t = t ~/ 24;
          if (t > 30) {
            t = t ~/ 30;
            if (t > 12) {
              t = t ~/ 12;
              str = '$t年前';
            } else {
              str = '$t月前';
            }
          } else {
            str = '$t天前';
          }
        } else {
          str = '$t小时前';
        }
      } else {
        str = '$t分钟前';
      }
    } else {
      str = '$t秒前';
    }
    return str;
  }
  static String getYearsOld(int date) {

    String str = '';
    if (date> 0) {
      int t = DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(date).year;
      str = '$t岁';
    } else {
      str = '0岁';
    }
    return str;
  }
  static Future<void> _init() async {
    if (profile.config.hash == null || profile.config.hash.isEmpty) {
      getConfig();
    }
    getSystemMessage();
    userModel.addListener(() {
      if(userModel.isLogin){
        // loginSocket();
      }else{
        getUserInfo().then((value) => loginSocket());
      }
    });
  }
  static Future<void> checkVersion() async {
    DioManager().request(NWMethod.GET, NWApi.checkVersion, params: {},
        success: (data) {
      // print("success data = $data == ${configModel.config.hash}");
      if (data != null && data.isNotEmpty) {
        Config config = Config.fromJson(jsonDecode(data));
        if (config.hash != (configModel.config.hash)) {
          getConfig();
        }
        if (MainContext != null) {
          if (config.version.compareTo(profile.config.version) > 0) {
            String url = '';
            if(Platform.isIOS){
              // url = 'itms-services://?action=download-manifest&url=${config.urlIos}';
              url = config.urlIos;
            }else if(Platform.isAndroid){
              url=config.urlAndroid;
            }
            ShowOptionDialog(
                MainContext,
                '新版本上线',
                '当前版本：${profile.config.version}    最新版本:${config.version}\n${config.text}',
                url,
                config.force);
          }
        }
      }
    }, error: (error) {
      // print(error);
    });
  }
  static Future<void> getConfig() async {
    DioManager().request(NWMethod.GET, NWApi.baseConfig, params: {},
        success: (data) {
      // print("success data = $data");
      if (data != null && data.isNotEmpty) {
        Config config = Config.fromJson(jsonDecode(data));
        profile.config.hash = config.hash;
        profile.config.autoLogin = config.autoLogin;
        profile.config.force = config.force;
        profile.config.groupLink = config.groupLink;
        profile.config.shareDomain = config.domain;
        profile.config.activityUrl = config.activityUrl;
        profile.config.bootImage = config.bootImage;
        profile.config.ossConfig = config.ossConfig;
        profile.config.onlinePays = config.onlinePays;
        profile.config.vipBuys = config.vipBuys;
        profile.config.buyDiamonds = config.buyDiamonds;
        profile.config.buyGolds = config.buyGolds;
        profile.config.kefuUrl = config.kefuUrl;
        profile.config.kefuGameUrl = config.kefuGameUrl;
        // print(config);
        saveProfile();
      }
    }, error: (error) {});
  }
  static Future<void> getSystemMessage() async {
    DioManager().request(NWMethod.GET, NWApi.getSystemMessage, params: {},
        success: (data) async {
      // print("success data = $data");
      if (data != null && data.isNotEmpty) {
        SystemMessage message = SystemMessage.formJson(jsonDecode(data));
        bool have = false;
        List<SystemMessage> systemMessages = messages.systemMessage;
        for (int i = 0; i < systemMessages.length; i++) {
          if (systemMessages[i].id == message.id) {
            have = true;
          }
        }
        if (!have) {
          messages.systemMessage.add(message);
        }
        // messages.systemMessage = [];
        saveMessages();
      }
    }, error: (error) {});
  }
  static Future<void> getUserInfo() async {
    DioManager().request(NWMethod.POST, NWApi.getInfo,
        params: {'identifier': uid}, success: (data) {
      // print("success data = $data");
      if (data != null) {
        userModel.user = User.fromJson(jsonDecode(data));
        loginSocket();
        handlerChannel();
        if(userModel.user.superior == 0 && codeInvite.isNotEmpty){
          _handlerInvite();
        }
        // RestartWidget.restartApp(MainContext);
      }
    }, error: (error) {});
  }
  static Future<String> getUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String uid = '';
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        uid = build.androidId;
        // print(uid);
        //UUID for Android
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        uid = build.identifierForVendor;
        // uid = await FlutterUdid.udid;
      }else{
        uid = 'test';
      }
      // ignore: nullable_type_in_catch_clause
    } on PlatformException {
      print('Failed to get platform version');
    }
    return uid;
  }
  static Future<File> _getLocalFile(String filename) async {
    // get the path to the document directory.
    // String dir = (await getApplicationDocumentsDirectory()).path;
    String dir = (await getTemporaryDirectory()).parent.path;
    // String dir = (await getApplicationSupportDirectory()).path;
    // print('$dir/$filename');
    return File('$dir/$filename');
  }
  static Future choseVideo() async {
    // List<Media> _listVideoPaths = await ImagePickers.pickerPaths(
    //   galleryMode: GalleryMode.video,
    //   selectCount: 1,
    // );
    // if (_listVideoPaths.isNotEmpty && _listVideoPaths[0].thumbPath != null) {
    //   UploadOss.upload(
    //       file: File(_listVideoPaths[0].thumbPath!),
    //       rootDir: "upload",
    //       callback: (data) {
    //         print(data);
    //       },
    //       onSendProgress: (int i) {
    //         print(i);
    //       });
    // }
  }
  static String getNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }
  static Future<void> runFlutterVideoCompressMethods(File videoFile) async {
    final mediaInfo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    // setState(() {
    //   _compressedVideoInfo = mediaInfo;
    // });
  }
  static Future<void> postFile(String path) async {
    File file = File(path);
    var sfile = await file.open();
    var x = 0;
    var fileSize = file.lengthSync();
    var chunkSize = 1000000;
    var val;
    while (x < fileSize) {}
  }
//  持久化Profile信息
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
  static saveMessages() => _prefs.setString('messages', jsonEncode(messages.toJson()));
  static void openWebview(String data, {bool? inline}){
    Navigator.push(
      MainContext,
      CupertinoPageRoute(
        title: inline== true ? '':'非官方网址，谨防假冒!',
        builder: (context) => WebViewExample(url: data, inline: inline,),
      ),
    );
  }
  static Future<void> loading(bool load) async {
    loadingChangeNotifier.isLoading = load;
  }
  static Future<void> showDialogVideo(Player player) async {
    String shareUrl = await _getShareUrl();
    Navigator.push(MainContext, DialogRouter(SpreadVideoDialog(
      player: player,
      shareUrl: shareUrl,
    )));
  }
  static Future<void> showDialogVideoRecommended(Player player) async {
    Navigator.push(MainContext, DialogRouter(DialogVideoRecommended(
      player: player,
    )));
  }
  static Future<String> getVideoPath(String path) async{
    String? savePath = await getPhoneLocalPath();
    return '$savePath$path';
  }
  static void handlerDownload(Download download) async{
    // if(!(await Global.requestPhotosPermission())) return;
    File f = File(await getVideoPath(download.path));
    // File f = File(download.path);
    // List<String> paths = download.path.split('/');
    // paths.removeAt(paths.length - 1);
    // String path = paths.join('/');
    // // print(path);
    // if(!await File(path).exists()){
    //   Directory(path).createSync();
    // }
    if (!f.parent.existsSync()) {
      Directory(f.parent.path).createSync();
    }
    // Directory(download.path).deleteSync();
    await DownloadFile.download(
      url: download.url,
      savePath: f.path,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          download.progress = received / total;
          configModel.changeDownload(download);
          // print("下载1已接收：" +
          //     received.toString() +
          //     "总共：" +
          //     total.toString() +
          //     "进度：+${(received / total * 100).floor()}%");
        }
      },
      done: () {
        download.finish = true;
        configModel.changeDownload(download);
        // print("下载1完成");
      },
      failed: (e) {
        download.error = true;
        configModel.changeDownload(download);
        // File file = File(download.path);
        // if(file.existsSync()){
        //   file.deleteSync();
        // }
        showWebColoredToast("下载1失败：" + e.toString());
      },
    );
  }
  static void downloadFunction(String downloadUrl, String title) async{
    Download download = Download();
    /// 申请写文件权限
    bool isPermiss =  await Global.requestPhotosPermission();
    // print(isPermiss);
    if(isPermiss || Platform.isIOS) {
      ///手机储存目录
      // String? savePath = await getPhoneLocalPath();
      // if(savePath != null) savePath = "$savePath/videos/";
      String savePath = "/videos/";
      String appName = downloadUrl.split('/').last;
      String savePaths = "$savePath$appName";
      // print(savePaths);
      download.title = title;
      download.url = downloadUrl;
      download.path = savePaths;
      if(configModel.exists(download)) return;
      configModel.addDownload(download);
      handlerDownload(download);
      ///创建DIO
      // Dio dio = Dio();

      ///参数一 文件的网络储存URL
      ///参数二 下载的本地目录文件
      ///参数三 下载监听
      // Response response = await dio.download(
      //     widget.url, "$savePath$appName", onReceiveProgress: (received, total) {
      //   if (total != -1) {
      //     ///当前下载的百分比例
      //     print((received / total * 100).toStringAsFixed(0) + "%");
      //     CircularProgressIndicator(value: currentProgress,); //进度 0-1
      //     currentProgress = received / total;
      //     // setState(() {
      //     //   currentProgress = received / total;
      //     // });
      //   }
      // });
    }else{
      ///提示用户请同意权限申请
    }
  }
  static Future<String?> getPhoneLocalPath() async {
    final directory = Theme.of(MainContext).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path;
  }
  static void exportToDoc(String path) async{
    File file = File(await getVideoPath(path));
    if(file.existsSync()){
      ImageGallerySaver.saveFile(file.path);
      showWebColoredToast('导出成功!');
    }
  }
  static Future<bool> requestPhotosPermission() async {
    //获取当前的权限
    // var statusInternet = await Permission.interfaces.status;
    var statusPhotos = await Permission.photos.status;
    var statusCamera = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if (statusPhotos == PermissionStatus.granted && statusCamera == PermissionStatus.granted && storageStatus == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      statusPhotos = await Permission.photos.request();
      statusCamera = await Permission.camera.request();
      storageStatus = await Permission.storage.request();
      if (statusPhotos == PermissionStatus.granted && statusCamera == PermissionStatus.granted && storageStatus == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
  static Future<String?> capturePng(GlobalKey repaintKey) async {
    try {
      // print('开始保存');
      RenderRepaintBoundary boundary = repaintKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      // print(result);
      result != null ? Global.showWebColoredToast(Platform.isIOS ? (result['isSuccess'] == true ? '保存成功！': '保存失败！') : '保存成功：${result['filePath']}') : print(result);
      return result['filePath'];
    } catch (e) {
      print(e);
    }
    return null;
  }
}
class DialogRouter extends PageRouteBuilder{

  final Widget page;

  DialogRouter(this.page)
      : super(
    opaque: false,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}