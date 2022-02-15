import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/data/CountryCode.dart';
import 'package:ncindexlistview/ncindexlistview.dart';
class CountryCodePage extends StatefulWidget {
  const CountryCodePage({Key? key}) : super(key: key);

  @override
  _CountryCodePage createState() => _CountryCodePage();

}
class _CountryCodePage extends State<CountryCodePage>{
  List<CountryCode> _dataSource = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CountryCode code = CountryCode();
    code.code = '+61';
    code.title =

  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child:  NCIndexListView<String>(
        dataSource: _dataSource,
        getNameText: (s) => s,
        itemBuilder: (context, value) {
          return TextButton(
            onPressed: () {  },
            child: ListTile(title: Text(value),),
          );
        },
        itemHeight: 50,
      ),
    );
  }
}