class JsonModelDemo {
  late String key;
  late String value;

  Map toJson() {
    Map map = {};
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}
