import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/WIthdrawaCard.dart';

import 'HttpManager.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class WithdrawalCardsPage extends StatefulWidget {
  const WithdrawalCardsPage({Key? key}) : super(key: key);

  @override
  _WithdrawalCardsPage createState() => _WithdrawalCardsPage();
}

class _WithdrawalCardsPage extends State<WithdrawalCardsPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerBank = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  List<WithdrawalCard> _list = [];
  int _select = 0;
  void initState() {
    _init();
    // WithdrawalCard card = WithdrawalCard();
    // card.bank = '中国银行';
    // card.code = '6216602600003172785';
    // cards.add(card);
    super.initState();
  }
  _init() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getWithdrawal, {"data": jsonEncode(parm)}));
    if (result != null) {
      print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['cards'] != null) {
        _list = [];
        WithdrawalCard card = WithdrawalCard();
        card.bank = '添加新的收款方式';
        _list.add(card);
        List<WithdrawalCard> list = (map['cards'] as List)
            .map((e) => WithdrawalCard.formJson(e))
            .toList();
        setState(() {
          _list.addAll(list);
        });
      }
    }
  }
  _save() async {
    if(_controllerName.text.isEmpty || _controllerBank.text.isEmpty || _controllerCode.text.isEmpty){
      Global.showWebColoredToast('所有项都是必填项目，请勿留空！');
      return;
    }
    Map<String, dynamic> parm = {
      'name': _controllerName.text,
      'bank': _controllerBank.text,
      'code': _controllerCode.text,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.addCard, {"data": jsonEncode(parm)}));
    if (result != null) {
      print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['cards'] != null) {
        _list = [];
        WithdrawalCard card = WithdrawalCard();
        card.bank = '添加新的收款方式';
        _list.add(card);
        List<WithdrawalCard> list = (map['cards'] as List)
            .map((e) => WithdrawalCard.formJson(e))
            .toList();
        setState(() {
          _list.addAll(list);
        });
      }
    }
  }

  List<DropdownMenuItem<Object>> _selectedItemBuilder() {
    List<DropdownMenuItem<Object>> list = [];
    for (int i = 0; i < _list.length; i++) {
      WithdrawalCard card = _list[i];
      list.add(
        DropdownMenuItem(
          child: Text(
              '${card.bank}${card.code != null && card.code.length > 4 ? '-(${card.code.substring(card.code.length - 4)})' : ''}'),
          value: card.id,
        ),
      );
    }
    return list;
  }
  _initController(){
    _controllerName.text = _list[_select].name;
    _controllerBank.text = _list[_select].id != 0 ? _list[_select].bank : '';
    _controllerCode.text = _list[_select].code;
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    hint: const Text('    请选择收款方式     '),
                    value: _select,
                    underline: Container(
                        height: 4, color: Colors.green.withOpacity(0.7)),
                    items: _selectedItemBuilder(),
                    onChanged: (value) {
                      _select = int.parse(value.toString());
                      _initController();
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      child: const Text('姓名:'),
                    ),
                    Expanded(
                      child: TextField(
                        // obscureText: true,
                        // focusNode: _commentFocus,
                        controller: _controllerName,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          // _commentFocus.unfocus();
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(18)
                        ],
                        // controller: _controller,
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0xffcccccc)),
                            hintText: "请输入持卡人姓名"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      child: const Text('银行:'),
                    ),
                    Expanded(
                      child: TextField(
                        // obscureText: true,
                        // focusNode: _commentFocus,
                        controller: _controllerBank,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          // _commentFocus.unfocus();
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(18)
                        ],
                        // controller: _controller,
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0xffcccccc)),
                            hintText: "请输入开户银行"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: const BoxDecoration(
                  color: Color(0xfff6f8fb),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      child: const Text('卡号:'),
                    ),
                    Expanded(
                      child: TextField(
                        // obscureText: true,
                        // focusNode: _commentFocus,
                        controller: _controllerCode,
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        // onSubmitted: (value) => {
                        //   setState(() => {_inputString = value})
                        // },
                        onEditingComplete: () {
                          // _commentFocus.unfocus();
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(18)
                        ],
                        // controller: _controller,
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0xffcccccc)),
                            hintText: "请输入银行卡号"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async{
                      _save();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.orange),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    child: Container(
                      width: 140,
                      alignment: Alignment.center,
                      child: const Text(
                        '保存',
                        style: TextStyle(
                            color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _initController();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.orange),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    child: Container(
                      width: 140,
                      alignment: Alignment.center,
                      child: const Text(
                        '重置',
                        style: TextStyle(
                            color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerCode.dispose();
    _controllerBank.dispose();
    _controllerName.dispose();
    super.dispose();
  }
}
