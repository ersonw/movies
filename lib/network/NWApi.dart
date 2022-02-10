class NWApi {
  static const baseApi = "http://192.168.254.142:8015/api/";
  static const baseWs = "ws://192.168.254.142:8015";
  // static const baseWs = "ws://172.21.68.12:8015";
  // static const baseApi = "http://172.21.68.12:8015/api/";
  static const baseConfig = "getConfig";
  static const loginPath = "user/login";
  static const getInfo = "user/info";
  static const checkVersion = 'checkVersion';
  static const getSystemMessage = 'getSystemMessage';

  static const queryListPath = "/query/list";
  static const queryListJsonPath = "/query/listjson";
}
