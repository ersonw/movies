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
  WithdrawalManagementPage({Key? key, required this.type}) : super(key: key);
  static const int WITHDRAWAL_DIAMOND = 100;
  static const int WITHDRAWAL_BALANCE = 101;
  static const int WITHDRAWAL_GOLD = 102;
  static const int WITHDRAWAL_GAME = 103;
  int type;

  @override
  _WithdrawalManagementPage createState() => _WithdrawalManagementPage();
}

class _WithdrawalManagementPage extends State<WithdrawalManagementPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
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
  int page = 1;
  int total = 1;
  int expand = 0;

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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        _initList();
      }
    });
    _textEditingController.text = '0';
    userModel.addListener(() {
      if (alive) {
        setState(() {
          _initBalance();
        });
      }
    });
    _textEditingController.addListener(() {
      if (alive && _textEditingController.text.isNotEmpty) {
        setState(() {
          withDrawa = double.parse(_textEditingController.text).toInt();
        });
      }
    });
    Global.getUserInfo();
  }

  _initBalance() {
    switch (widget.type) {
      case WithdrawalManagementPage.WITHDRAWAL_DIAMOND:
        balance = userModel.user.diamond;
        break;
      case WithdrawalManagementPage.WITHDRAWAL_GOLD:
        balance = userModel.user.gold;
        break;
      case WithdrawalManagementPage.WITHDRAWAL_GAME:
        _balanceGame();
        break;
      default:
        _balance();
        break;
    }
  }

  _balanceGame() async {
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getGameBalance, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null && map['gameBalance'] != null){
        setState(() {
          balance =  (map['gameBalance'] * 100).toInt();
        });
      }
    }
  }
  _balance() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getBalance, {"data": jsonEncode(parm)}));
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      if (map['balance'] != null) {
        setState(() {
          balance = map['balance'];
        });
      }
    }
  }

  List<DropdownMenuItem<Object>> _selectedItemBuilder() {
    List<DropdownMenuItem<Object>> list = [];
    for (int i = 0; i < cards.length; i++) {
      WithdrawalCard card = cards[i];
      list.add(
        DropdownMenuItem(
          child: Text(
              '${card.bank}${card.code != null && card.code.length > 4 ? '-(${card.code.substring(card.code.length - 4)})' : ''}'),
          value: i,
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
          cards = (map['cards'] as List)
              .map((e) => WithdrawalCard.formJson(e))
              .toList();
        });
      }
    }
  }

  _initList() async {
    if (page > total) {
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
        List<WithdrawalRecord> list = (map['list'] as List)
            .map((e) => WithdrawalRecord.formJson(e))
            .toList();
        setState(() {
          if (page > 1) {
            _list.addAll(list);
          } else {
            _list = list;
          }
        });
      }
    }
  }

  _withdrawal() async {
    Map<String, dynamic> parm = {
      'amount': withDrawa,
      'card': cards[_select].id,
      'type': widget.type,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.Withdrawal, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['verify'] == true) {
        _initList();
        Global.getUserInfo();
        _textEditingController.text = '0';
      }
      if (map['msg'] != null) {
        Global.showWebColoredToast(map['msg']);
      }
    }
  }
  _cancelWithdrawal(int id) async {
    Map<String, dynamic> parm = {
      'id': id,
      // 'type': widget.type,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.cancelWithdrawal, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if (map['verify'] == true) {
        _initList();
        Global.getUserInfo();
        _textEditingController.text = '0';
      }
      if (map['msg'] != null) {
        Global.showWebColoredToast(map['msg']);
      }
    }
  }

  _proportion() {
    switch (widget.type) {
      case WithdrawalManagementPage.WITHDRAWAL_DIAMOND:
        return proportionDiamond;
      case WithdrawalManagementPage.WITHDRAWAL_GOLD:
        return proportionGold;
      default:
        return proportionBalance;
    }
  }

  _onPressed() async {
    if (cards[_select].id == 0) {
      Global.showWebColoredToast('请先选择收款方式或者先添加新的收款方式！');
      return;
    }
    int amount = ((withDrawa) ~/ _proportion());
    if (widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE || widget.type == WithdrawalManagementPage.WITHDRAWAL_GAME) {
      amount = ((withDrawa) * (_proportion() / 100)).toInt();
      if (withDrawa > (balance / 100)) {
        Global.showWebColoredToast('提现大于拥有额度，操作失败！');
        return;
      }
    }else{
      if (withDrawa > (balance )) {
        Global.showWebColoredToast('提现大于拥有额度，操作失败！');
        return;
      }
    }
    // print(amount);
    if (amount < (MiniWithdrawal / 100)) {
      Global.showWebColoredToast(
          '单笔最小提现不能少于等值￥${(MiniWithdrawal / 100).toStringAsFixed(2)}！');
      return;
    }
    if (amount > (MaxWithdrawal / 100)) {
      Global.showWebColoredToast(
          '单笔最大提现不能多于等值￥${(MaxWithdrawal / 100).toStringAsFixed(2)}！');
      return;
    }

    if (await ShowAlertDialogBool(context, '提现确认',
        '您正在操作的提现价值 ￥${(amount ).toStringAsFixed(2)},确定继续操作吗？')) {
      _withdrawal();
    }
  }

  List<ExpansionPanel> itemBuilder() {
    List<ExpansionPanel> list = [];
    for(int i=0;i< _list.length; i++){
      WithdrawalRecord record = _list[i];
       list.add(
           ExpansionPanel(
             canTapOnHeader: true,
             headerBuilder: (context, isExpanded) {
               return InkWell(
                 onTap: () => setState(() {
                   _list[i].open = !_list[i].open;
                 }),
                 child: Container(
                   margin: const EdgeInsets.all(5),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Text('订单ID: ${record.orderNo}',style: const TextStyle(fontSize: 15),),
                         ],
                       ),
                       const Padding(padding: EdgeInsets.only(top: 10)),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(
                             width: ((MediaQuery.of(context).size.width) / 2.5),
                             child: Text('备注：${record.reason}',style: const TextStyle(color: Colors.black45,fontSize: 15),),
                           ),
                           Text('￥-${((record.amount * 1) / 100).toStringAsFixed(2)}',style: const TextStyle(fontSize: 21,color: Colors.orange),),
                         ],
                       ),
                     ],
                   ),
                 ),
               );
             },
             body: Container(
               margin: const EdgeInsets.all(5),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     margin: const EdgeInsets.all(5),
                     child: record.status < 0 ?
                     Stepper(
                       currentStep: (-(record.status)),
                       type: StepperType.vertical,
                       steps: [
                         Step(
                           title: const Text('提交订单'),
                           content: Text('提交时间：${Global.getTimeToString(record.addTime)}'),
                           isActive: true,
                           state: StepState.complete,
                         ),
                         Step(
                           title: const Text('取消订单'),
                           content: Text('更新时间：${Global.getTimeToString(record.updateTime)}'),
                           isActive: (-(record.status)) > 0,
                           state: (-(record.status)) > 0 ? StepState.complete : StepState.indexed,
                         ),
                         Step(
                           title: const Text('出款失败'),
                           content: Text('更新时间：${Global.getTimeToString(record.updateTime)}'),
                           isActive: (-(record.status)) == 2,
                           state: (-(record.status)) == 2 ? StepState.complete : StepState.indexed,
                         ),
                       ],
                         controlsBuilder: (BuildContext context, ControlsDetails details){
                         return Container();
                         }
                     )
                     : Stepper(
                       currentStep: record.status,
                       type: StepperType.vertical,
                       steps: [
                         Step(
                           title: const Text('提交订单'),
                           content: Text('提交时间：${Global.getTimeToString(record.addTime)}'),
                           isActive: true,
                           state: StepState.complete,
                         ),
                         Step(
                           title: const Text('审核订单'),
                           content: Text('更新时间：${Global.getTimeToString(record.updateTime)}'),
                           isActive: record.status > 0,
                           state: record.status > 0 ? StepState.complete : StepState.indexed,
                         ),
                         Step(
                           title: const Text('成功出款'),
                           content: Text('更新时间：${Global.getTimeToString(record.updateTime)}'),
                           isActive: record.status == 2,
                           state: record.status == 2 ? StepState.complete : StepState.indexed,
                         ),
                       ],
                         controlsBuilder: record.status > 0 ?   (BuildContext context, ControlsDetails details){
                         return Container();
                         } :
                             (BuildContext context, ControlsDetails details){
                           VoidCallback? onStepCancel = details.onStepCancel;
                           return Row(
                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               FlatButton(
                                 onPressed: onStepCancel,
                                 child: const Text('取消申请',style: TextStyle(color: Colors.red),),
                               ),
                             ],
                           );
                         },
                       onStepCancel: ()async {
                         if(await ShowAlertDialogBool(context, '提现订单', '取消提现申请将会以等值的人民币发放到现金账户,确认取消订单号：${record.orderNo} 的提现申请吗？')){
                           _cancelWithdrawal(record.id);
                         }
                       },
                     ),
                   ),
                 ],
               ),
             ),
             isExpanded: record.open,
           ),
       );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: Colors.black12,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
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
                      margin:
                          const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Text(
                        '余额: ${ widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE || widget.type == WithdrawalManagementPage.WITHDRAWAL_GAME ? '￥${(((balance / 100) - withDrawa).toStringAsFixed(2))}' : '￥${(balance - withDrawa)}'}',
                        style: TextStyle(
                            color: (widget.type ==
                                        WithdrawalManagementPage
                                            .WITHDRAWAL_BALANCE
                                    ? (withDrawa > (balance / 100))
                                    : (withDrawa > balance))
                                ? Colors.red
                                : Colors.grey,
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
                    margin: withDrawa != balance
                        ? const EdgeInsets.only(left: 13, right: 13)
                        : const EdgeInsets.all(13),
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
                        withDrawa != balance
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    if(widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE || widget.type == WithdrawalManagementPage.WITHDRAWAL_GAME){
                                      if(  MaxWithdrawal > (balance )){
                                        _textEditingController.text =
                                            (balance ~/ 100).toString();
                                      }else{
                                        _textEditingController.text =
                                            (MaxWithdrawal ~/ 100).toString();
                                      }
                                    }else{
                                      if( (MaxWithdrawal / 100) > (balance / _proportion())){
                                        _textEditingController.text =
                                            balance.toString();
                                      }else{
                                        _textEditingController.text =
                                            ((MaxWithdrawal ~/ 100) * _proportion()).toString();
                                      }

                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  // padding: MaterialStateProperty.all(EdgeInsets.only(top: 0,bottom: 0)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
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
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '实际到账: ${widget.type == WithdrawalManagementPage.WITHDRAWAL_BALANCE || widget.type == WithdrawalManagementPage.WITHDRAWAL_GAME ? '${_proportion()}%' : '${_proportion()} = 1￥'}'),
                      DropdownButton(
                        hint: const Text('请选择收款方式'),
                        value: _select,
                        underline: Container(
                            height: 4, color: Colors.green.withOpacity(0.7)),
                        items: _selectedItemBuilder(),
                        onChanged: (value) => setState(() {
                          _select = int.parse(value.toString());
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 10, right: 10),
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .push<void>(
                                CupertinoPageRoute(
                                  // title: '确认订单',
                                  builder: (context) =>
                                      const WithdrawalCardsPage(),
                                ),
                              )
                              .then((value) => _init());
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1.0, color: Colors.black12),
                ),
                child: ExpansionPanelList(
                  //交互回调属性，里面是个匿名函数
                  expansionCallback: (index, bol) => setState(() {
                    _list[index].open = !bol;
                  }),
                  //进行map操作，然后用toList再次组成List
                  children: itemBuilder(),
                ),
              ),
            ],
          ),),
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
