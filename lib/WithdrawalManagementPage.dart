import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/functions.dart';
import 'package:movies/global.dart';

import 'HttpManager.dart';
import 'WithdrawalCardsPage.dart';
import 'data/WIthdrawaCard.dart';
import 'data/WithdrawalRecord.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class WithdrawalManagementPage extends StatefulWidget {
  WithdrawalManagementPage({Key? key, required this.type }) : super(key: key);
  static const int WITHDRAWAL_DIAMOND = 100;
  static const int WITHDRAWAL_BALANCE = 101;
  static const int WITHDRAWAL_GOLD = 102;
  int type;
  @override
  _WithdrawalManagementPage createState() => _WithdrawalManagementPage();

}
class _WithdrawalManagementPage extends State<WithdrawalManagementPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  int balance = 0;
  int withDrawa = 0;
  bool alive = true;
  List<WithdrawalCard> cards = [];
  List<WithdrawalRecord> _list = [];
  int _select = 0;
  int proportionBalance = 0;
  int proportionDiamond = 0;
  int proportionGold = 0;
  int MiniWithdrawal = 0;
  int MaxWithdrawal = 0;
  int page=1;
  int total=1;

  @override
  void initState() {
    _init();
    _initList();
    _initBalance();
    // WithdrawalCard card = WithdrawalCard();
    // card.bank = '中国银行';
    // card.code = '6216602600003172785';
    // cards.add(card);
    super.initState();
    _textEditingController.text= '0';
    userModel.addListener(() {
      if(alive){
        setState(() {
          _initBalance();
        });
      }
    });
    _textEditingController.addListener(() {
      if(alive && _textEditingController.text.isNotEmpty){
        setState(() {
          withDrawa = int.parse(_textEditingController.text);
        });
      }
    });
    Global.getUserInfo();
  }
  _initBalance(){
    switch(widget.type){
      case WithdrawalManagementPage.WITHDRAWAL_DIAMOND:
        balance = userModel.user.diamond;
        break;
      case WithdrawalManagementPage.WITHDRAWAL_GOLD:
        balance = userModel.user.gold;
        break;
      default:
        _balance();
        break;
    }
  }
  _balance() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getBalance, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map['balance'] != null){
        setState(() {
          balance = map['balance'];
        });
      }
    }
  }
  List<DropdownMenuItem<Object>> _selectedItemBuilder(){
    List<DropdownMenuItem<Object>> list = [];
    for(int i=0;i< cards.length;i++){
      WithdrawalCard card = cards[i];
      list.add(DropdownMenuItem(
        child: Text('${card.bank}${card.code != null && card.code.length > 4 ? '-(${card.code.substring(card.code.length-4)})' : ''}'),
        value: card.id,
      ),
      );
    }
    return list;
  }
  _init() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getWithdrawal, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['proportionBalance'] != null) {
        setState(() {
          proportionBalance = map['proportionBalance'];
        });
      }
      if (map['proportionDiamond'] != null) {
        setState(() {
          proportionDiamond = map['proportionDiamond'];
        });
      }
      if (map['proportionGold'] != null) {
        setState(() {
          proportionGold = map['proportionGold'];
        });
      }
      if (map['MiniWithdrawal'] != null) {
        setState(() {
          MiniWithdrawal = map['MiniWithdrawal'];
        });
      }
      if (map['MaxWithdrawal'] != null) {
        setState(() {
          MaxWithdrawal = map['MaxWithdrawal'];
        });
      }
      if (map['cards'] != null) {
        setState(() {
          cards = (map['cards'] as List).map((e) => WithdrawalCard.formJson(e)).toList();
        });
      }
    }
  }
  _initList() async {
    if(page > total){
      page--;
      return;
    }
    Map<String, dynamic> parm = {
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getWithdrawalRecords, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['list'] != null) {
        List<WithdrawalRecord> list = (map['list'] as List).map((e) => WithdrawalRecord.formJson(e)).toList();
        setState(() {
          if(page>1){
            _list.addAll(list);
          }else{
            _list=list;
          }
        });
      }
    }
  }
  _withdrawal() async {
    Map<String, dynamic> parm = {
      'amount': withDrawa,
      'card': _select,
      'type': widget.type,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.Withdrawal, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['verify'] == true) {
        _initList();
      }
      if (map['msg'] != null) {
        Global.showWebColoredToast(map['msg'] );
      }
    }
  }
  _proportion(){
    switch(widget.type){
      case WithdrawalManagementPage.WITHDRAWAL_DIAMOND:
        return proportionDiamond;
      case WithdrawalManagementPage.WITHDRAWAL_GOLD:
        return proportionGold;
      default:
        return proportionBalance;
    }
  }
  _onPressed() async {
    print((withDrawa / _proportion()));
    if((withDrawa / _proportion()) < (MiniWithdrawal / 100)){
      Global.showWebColoredToast('单笔最小提现不能少于等值￥${(MiniWithdrawal / 100).toStringAsFixed(2)}！');
      return;
    }
    if((withDrawa / _proportion()) > (MaxWithdrawal / 100)){
      Global.showWebColoredToast('单笔最大提现不能多于等值￥${(MaxWithdrawal / 100).toStringAsFixed(2)}！');
      return;
    }
    if(_select == 0){
      Global.showWebColoredToast('请先选择收款方式或者先添加新的收款方式！');
      return;
    }
    if(widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE){
      if(withDrawa > (balance / 100)){
        Global.showWebColoredToast('提现大于拥有额度，操作失败！');
        return;
      }
      if(await ShowAlertDialogBool(context, '提现确认', '您正在操作的提现额度为$withDrawa 剩余额度为 ${((balance / 100) - withDrawa).toStringAsFixed(2)} 兑换价值 ￥${((withDrawa  / _proportion()) / 100).toStringAsFixed(2)},确定继续操作吗？')){
        _withdrawal();
      }
    }else{

      if(withDrawa > balance){
        Global.showWebColoredToast('提现大于拥有额度，操作失败！');
        return;
      }
      if(await ShowAlertDialogBool(context, '提现确认', '您正在操作的提现额度为$withDrawa 剩余额度为 ${balance - withDrawa} 兑换价值 ￥${(withDrawa / _proportion()).toStringAsFixed(2)},确定继续操作吗？')){
        _withdrawal();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: 80,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Colors.black12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        child:  Text(
                          '余额: ${widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE ? (((balance / 100) - withDrawa).toStringAsFixed(2)) : (balance - withDrawa)}',
                          style:  TextStyle(
                              color: (widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE ? (withDrawa > (balance / 100)) : (withDrawa > balance)) ? Colors.red : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Color(0xfff6f8fb),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.center,
                    child: Container(
                      margin: withDrawa != balance ? const EdgeInsets.only(left: 13,right: 13) : const EdgeInsets.all(13),
                      child: Row(
                        children: [
                          Container(
                            child: const Text('预提现:'),
                          ),
                          Expanded(
                            child: TextField(
                              // obscureText: true,
                              // focusNode: _commentFocus,
                              controller: _textEditingController,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              // onSubmitted: (value) => {
                              //   setState(() => {_inputString = value})
                              // },
                              onEditingComplete: () {
                                _commentFocus.unfocus();
                                _onPressed();
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
                                  hintText: "请输入数量"),
                            ),
                          ),
                          withDrawa != balance ? TextButton(
                            onPressed: () {
                              setState(() {
                                _textEditingController.text = balance.toString();
                              });
                            },
                            style: ButtonStyle(
                              // padding: MaterialStateProperty.all(EdgeInsets.only(top: 0,bottom: 0)),
                              backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                            child: Container(
                              width: 40,
                              // height: 20,
                              alignment: Alignment.center,
                              child: const Text(
                                '全部',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('提现比例: ${ widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE ? _proportion() / 100 : _proportion()} = 1￥'),
                        DropdownButton(
                          hint: const Text('请选择收款方式'),
                          value: _select,
                          underline: Container(height: 4, color: Colors.green.withOpacity(0.7)),
                          items:  _selectedItemBuilder(),
                          onChanged: (value) => setState(() {
                            _select = int.parse(value.toString());
                          }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _onPressed();
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
                              '立即提现',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push<void>(
                              CupertinoPageRoute(
                                // title: '确认订单',
                                builder: (context) => const WithdrawalCardsPage(),
                              ),
                            ).then((value) => _init());
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
                              '管理卡号',
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
          ],
        ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    alive = false;
    _commentFocus.unfocus();
    _textEditingController.dispose();
    super.dispose();
  }
}