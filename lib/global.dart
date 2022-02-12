import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:movies/MessagesChangeNotifier.dart';
import 'package:movies/ProfileChangeNotifier.dart';
import 'package:movies/data/KefuMessage.dart';
import 'package:movies/data/Messages.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/data/User.dart';
import 'package:movies/data/Config.dart';
import 'package:movies/data/Profile.dart';
import 'package:movies/data/WebSocketMessage.dart';
import 'package:movies/functions.dart';
import 'package:movies/HttpManager.dart';
import 'package:movies/model/KeFuMessageModel.dart';
import 'package:movies/model/UserModel.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:movies/utils/UploadOss.dart';
import 'data/Profile.dart';
enum SocketStatus {
  SocketStatusConnected, // 已连接
  SocketStatusFailed, // 失败
  SocketStatusClosed, // 连接关闭
}
class Global {
  static MediaInfo _compressedVideoInfo = MediaInfo(path: '');
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static late final cameras;
  static bool _isLogin = false;
  static late BuildContext MainContext;
  static late final String uid;
  static  WebSocketChannel?  channel = null;
  static final ProfileChangeNotifier _profileChangeNotifier = ProfileChangeNotifier();
  static final KeFuMessageModel _keFuMessageModel = KeFuMessageModel();
  static final MessagesChangeNotifier _messagesChangeNotifier = MessagesChangeNotifier();
  static Profile profile = Profile();
  static Messages messages = Messages();
  static late SharedPreferences _prefs;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
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
    if(_messages != null){
      try{
        messages = Messages.formJson(jsonDecode(_messages));
      }catch(e){
        print(e);
      }
    }
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    uid = await getUUID();
    print(_messages);
    print(_profile);
    await _init();
    await initSock();
    // await loginSocket();
    _profileChangeNotifier.addListener(() {
      if(UserModel().isLogin == false) {
        getUserInfo();
      }else if(_isLogin == false) {
        loginSocket();
      }
    });
  }
  static Size boundingTextSize(String text, TextStyle style,  {int maxLines = 2^31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style), maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  static String generateMd5(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
  static Future<void> initSock()async {
    channel = WebSocketChannel.connect(
        Uri.parse(NWApi.baseWs),
    );
    channel?.stream.listen(
      channelListen,
      onDone: () async{
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
  static Future<void> loginSocket()async {
    WebSocketMessage _message = WebSocketMessage();
    _message.code = WebSocketMessage.login;
    _message.data = jsonEncode({ "token": profile.user.token });
    channel?.sink.add(_message.toString());
  }
  static Future<bool> sendKeFuMessage(KefuMessage message) async{
    WebSocketMessage _message = WebSocketMessage();
    _message.code = WebSocketMessage.message_kefu_sending;
    _message.data = message.toString();
    if(channel != null){
      channel?.sink.add(_message.toString());
      return true;
    }
    return false;
  }
  static Future<void> channelListen(data)async {
    // print(UserModel().isLogin);
    if(UserModel().isLogin == false) {
      getUserInfo();
    }else if(_isLogin == false) {
      loginSocket();
    }
    if(data == 'H') return;
    WebSocketMessage message = WebSocketMessage.formJson(jsonDecode(data));
    switch(message.code){
      case WebSocketMessage.login_success:
        _isLogin = true;
        break;
      case WebSocketMessage.login_fail:
        _isLogin = false;
        UserModel().token = '';
        // _profileChangeNotifier.notifyListeners();
        break;
      case WebSocketMessage.message_kefu_send_fail:
        ShowAlertDialog(MainContext, '发送消息', message.message);
        KefuMessage kefuMessage = KefuMessage.formJson(jsonDecode(message.data!));
        _keFuMessageModel.status(kefuMessage.id, message.code);
        break;
      case WebSocketMessage.message_kefu_send_success:
        KefuMessage kefuMessage = KefuMessage.formJson(jsonDecode(message.data!));
        _keFuMessageModel.status(kefuMessage.id, message.code);
        break;
      case WebSocketMessage.message_kefu_recevie:
        _keFuMessageModel.add(KefuMessage.formJson(jsonDecode(message.data!)));
        break;
      default:
        break;
    }
    // print(_userModel.token);
  }
  static String getDateTime(int date){
    int t = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - date);
    String str = '';
    if(t > 60){
      t = t ~/ 60;
      if(t > 60){
        t = t ~/ 60;
        if(t > 24){
          t = t ~/ 24;
          if(t > 30){
            t = t ~/ 30;
            if(t > 12){
              t = t ~/ 12;
              str = '$t年前';
            }else{
              str = '$t月前';
            }
          }else{
            str = '$t天前';
          }
        }else{
          str = '$t小时前';
        }
      }else{
        str = '$t分钟前';
      }
    }else{
      str = '$t秒前';
    }
    return str;
  }
  static Future<void> _init() async {
    if(profile.config.hash == null || profile.config.hash.isEmpty){
      getConfig();
    }
    // await checkVersion();
    if(profile.config.autoLogin){
      if(profile.user.token == null || profile.user.token.isEmpty){
        await getUserInfo();
      }
    }
    getSystemMessage();
  }
  static Future<void> checkVersion() async {
    DioManager().request(
        NWMethod.GET,
        NWApi.checkVersion,
        params: {},
        success: (data){
          // print("success data = $data");
          if(data != null && data.isNotEmpty){
            Config config = Config.fromJson(jsonDecode(data));
            if(config.hash.contains(profile.config.hash)){
              getConfig();
            }
            if(MainContext != null){
              if(config.version.compareTo(profile.config.version) > 0){
                ShowOptionDialog(MainContext, '新版本上线', '目前版本：${profile.config.version}\n最新版本:${config.version}', config.url, config.force);
              }
            }
          }
        }, error:(error) {
          // print(error);
    });
  }
  static Future<void> getConfig() async {
    DioManager().request(
        NWMethod.GET,
        NWApi.baseConfig,
        params: {},
        success: (data){
          // print("success data = $data");
          if(data != null && data.isNotEmpty) {
            Config config = Config.fromJson(jsonDecode(data));
            profile.config.hash = config.hash;
            profile.config.autoLogin = config.autoLogin;
            profile.config.force = config.force;
            profile.config.url = config.url;
            profile.config.bootImage = config.bootImage;
            profile.config.ossConfig = config.ossConfig;
            saveProfile();
          }
        }, error:(error) {});
  }
  static Future<void> getSystemMessage() async {
    DioManager().request(
        NWMethod.GET,
        NWApi.getSystemMessage,
        params: {},
        success: (data) async{
          // print("success data = $data");
          if(data != null && data.isNotEmpty) {
            SystemMessage message = SystemMessage.formJson(jsonDecode(data));
            bool have = false;
            List<SystemMessage> systemMessages = messages.systemMessage;
            for(int i=0; i< systemMessages.length; i++){
              if(systemMessages[i].id == message.id){
                have = true;
              }
            }
            if(!have){
              messages.systemMessage.add(message);
            }
            // messages.systemMessage = [];
            saveMessages();
          }
        }, error:(error) {});
  }
  static Future<void> getUserInfo() async {
    DioManager().request(
        NWMethod.POST,
        NWApi.getInfo,
        params: {'identifier': uid},
        success: (data){
          print("success data = $data");
          if(data != null) {
            profile.user = User.fromJson(jsonDecode(data));
            saveProfile();
          }
        }, error:(error) {});
  }
  static Future<String> getUUID() async{
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String uid = '';
    try {
      if (Platform.isAndroid) {
        var build =  await deviceInfoPlugin.androidInfo;
        uid = build.androidId;
        // print(uid);
        //UUID for Android
      } else if (Platform.isIOS) {
        var build =  await deviceInfoPlugin.iosInfo;
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
  static Future choseVideo() async{
    List<Media> _listVideoPaths = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.video,
      selectCount: 1,
    );
    if(_listVideoPaths.isNotEmpty && _listVideoPaths[0].thumbPath != null){
      UploadOss.upload(
          file: File(_listVideoPaths[0].thumbPath!),
          rootDir: "upload",
          callback: (data) {
            print(data);
          },
          onSendProgress: (int i){
            print(i);
          }
      );
    }
  }
  /*
  * 根据本地路径获取名称
  * */
  static String getNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath.substring(filePath.lastIndexOf("/")+1,filePath.length);
  }
  //压缩视频
  static Future<void> runFlutterVideoCompressMethods(File videoFile) async {
    final mediaInfo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    _compressedVideoInfo = mediaInfo!;
    // setState(() {
    //   _compressedVideoInfo = mediaInfo;
    // });
  }
  static Future<void> postFile(String path)async{
    File file = File(path);
    var sfile = await file.open();
    var x = 0;
    var fileSize = file.lengthSync();
    var chunkSize = 1000000;
    var val;
    while (x < fileSize) {
    }
  }
//  持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
  static saveMessages() => _prefs.setString('messages', jsonEncode(messages.toJson()));
}