import 'dart:async';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:movies/LoadingChangeNotifier.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/SpreadVideoDialog.dart';
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
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:movies/utils/UploadOss.dart';
import 'DialogVideoRecommended.dart';
import 'LoadingDialog.dart';
import 'PlayerPage.dart';
import 'RestartWidget.dart';
import 'data/Player.dart';
import 'data/Profile.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

final MessagesChangeNotifier messagesChangeNotifier = MessagesChangeNotifier();
final KeFuMessageModel keFuMessageModel = KeFuMessageModel();
final ConfigModel configModel = ConfigModel();
final UserModel userModel = UserModel();
final LoadingChangeNotifier loadingChangeNotifier = LoadingChangeNotifier();
class Global {

  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  static late final cameras;
  static bool _isLogin = false;
  static late BuildContext MainContext;
  static late final String uid;
  static WebSocketChannel? channel;

  static Profile profile = Profile();
  static Messages messages = Messages();
  static late SharedPreferences _prefs;

  static bool isLoading = false;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
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
    // print(_messages);
    // print(_profile);
    await _init();
    await initSock();
    // await loginSocket();
    // userModel.addListener(() {
    //   if (UserModel().isLogin == false) {
    //     getUserInfo();
    //   } else if (_isLogin == false) {
    //     loginSocket();
    //   }
    // });
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
    if(user.avatar?.contains('http') == true){
      //
    }else{
      if(user.avatar != null && user.avatar != ''){
        String? images = await UploadOssUtil.upload(
            File(user.avatar!), Global.getNameByPath(user.avatar!));
        if (images == null) {
          showWebColoredToast("头像上传失败！");
          return;
        }
        user.avatar = images;
        showWebColoredToast("头像上传成功！");
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
    channel = WebSocketChannel.connect(
      Uri.parse(NWApi.baseWs),
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
        if (userModel.isLogin) {
          WebSocketMessage _message = WebSocketMessage();
          _message.code = WebSocketMessage.login;
          _message.data = jsonEncode({"token": userModel.token});
          channel?.sink.add(_message.toString());
        }else{
          getUserInfo();
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
        userModel.token = '';
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
        showWebColoredToast('账号信息修改成功!');
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
    Navigator.of(MainContext, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        builder: (context) => PlayerPage(id: id),
      ),
    );
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
  static void showDownloadPage(String downloadUrl, String title) async{

    // Navigator.of(MainContext, rootNavigator: true).push<void>(
    //   CupertinoPageRoute(
    //     title: "下载管理",
    //     // fullscreenDialog: true,
    //     builder: (context) => DownloadVideoPage(
    //       downloadUrl: downloadUrl,
    //       title: title,
    //     ),
    //   ),
    // );
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
  static String getNumbersToChinese(int n){
    if(n < 9999){
      return '$n';
    }else{
      double d= n / 10000;
      if(d < 999){
        return '${d.toStringAsFixed(2)}W';
      }else{
        d= d / 1000;
        return '${d.toStringAsFixed(2)}KW';
      }
    }
  }
  static void handlerInvite(String data){
    print(data);
  }
  // static String getNumbersToChinese(int n){
  //   if(n < 1000){
  //     return '$n';
  //   }else{
  //     int d= n ~/ 1000;
  //     if(d < 10){
  //       return '${d}K';
  //     }else{
  //       d= d ~/ 10;
  //       return '${d}W';
  //     }
  //   }
  // }
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
            ShowOptionDialog(
                MainContext,
                '新版本上线',
                '目前版本：${profile.config.version}\n最新版本:${config.version}',
                config.url,
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
        profile.config.url = config.url;
        profile.config.domain = config.domain;
        profile.config.bootImage = config.bootImage;
        profile.config.ossConfig = config.ossConfig;
        profile.config.onlinePays = config.onlinePays;
        profile.config.vipBuys = config.vipBuys;
        profile.config.buyDiamonds = config.buyDiamonds;
        profile.config.buyGolds = config.buyGolds;
        print(config);
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
        RestartWidget.restartApp(MainContext);
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
    List<Media> _listVideoPaths = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.video,
      selectCount: 1,
    );
    if (_listVideoPaths.isNotEmpty && _listVideoPaths[0].thumbPath != null) {
      UploadOss.upload(
          file: File(_listVideoPaths[0].thumbPath!),
          rootDir: "upload",
          callback: (data) {
            print(data);
          },
          onSendProgress: (int i) {
            print(i);
          });
    }
  }

  /*
  * 根据本地路径获取名称
  * */
  static String getNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  //压缩视频
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
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));

  static saveMessages() =>
      _prefs.setString('messages', jsonEncode(messages.toJson()));

  static Future<void> loading(bool load) async {
    loadingChangeNotifier.isLoading = load;
  }
  static Future<void> showDialogVideo(Player player) async {
    Navigator.push(MainContext, DialogRouter(SpreadVideoDialog(
      player: player,
    )));
  }
  static Future<void> showDialogVideoRecommended(Player player) async {
    Navigator.push(MainContext, DialogRouter(DialogVideoRecommended(
      player: player,
    )));
  }
  static Future<bool> requestPhotosPermission() async {
    //获取当前的权限
    var statusPhotos = await Permission.photos.status;
    var statusCamera = await Permission.camera.status;
    if (statusPhotos == PermissionStatus.granted && statusCamera == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      statusPhotos = await Permission.photos.request();
      statusCamera = await Permission.camera.request();
      if (statusPhotos == PermissionStatus.granted && statusCamera == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
  static Future<String?> capturePng(GlobalKey repaintKey) async {
    try {
      print('开始保存');
      RenderRepaintBoundary boundary = repaintKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result); // result是图片地址
      Global.showWebColoredToast(result);
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