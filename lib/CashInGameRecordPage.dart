import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'data/CashInOrder.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class CashInGameRecordPage extends StatefulWidget {
  const CashInGameRecordPage({Key? key}) : super(key: key);

  @override
  _CashInGameRecordPage createState() => _CashInGameRecordPage();
}

class _CashInGameRecordPage extends State<CashInGameRecordPage> {
  final ScrollController _controller = ScrollController();
  List<CashInOrder> _list = [];
  int page = 1;
  int total = 1;
  bool loading = false;
  @override
  void initState() {
    _init();
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        setState(() {
          page++;
        });
        _init();
      }
    });
  }
  _init() async{
    // if(post) return;
    if(page > total) {
      setState(() {
        page--;
      });
      return;
    }
    Map<String, dynamic> parm = {
      'page': page,
    };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getCashInOrders, {"data": jsonEncode(parm)}));
    if (result == null) {
      return;
    }
    setState(() {
      loading = false;
    });
    Map<String, dynamic> map = jsonDecode(result);
    total = map['total'] > 0 ? map['total'] : 1;
    List<CashInOrder> list = (map['list'] as List).map((e) => CashInOrder.formJson(e)).toList();
    setState(() {
      if(page > 1){
        _list.addAll(list);
      }else{
        _list = list;
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                    controller: _controller,
                    children: [
                      Center(child: Container(
                        // margin: const EdgeInsets.only(top: 30, bottom: 30),
                        child: loading ? Image.asset(ImageIcons.Loading_icon,width: 150,) : Container(),
                      ),),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: [
                          SizedBox(
                            width: ((MediaQuery.of(context).size.width) / 2.5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(children: const [
                                Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ]),
                            ),
                          ),
                          const Center(
                              child: Text('充值记录',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ]),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      _buildList(),
                    ]),
              ),
            ]
        ),
    );
  }
  Future<void> _onRefresh() async {
    setState(() {
      loading = true;
    });
    page = 1;
    _init();
  }
  _buildList(){
    List<Widget> widgets = [];
    // widgets.add(
    //     Center(child: Container(
    //       // margin: const EdgeInsets.only(top: 30, bottom: 30),
    //       child: loading ? Image.asset(ImageIcons.Loading_icon,width: 150,) : Container(),
    //     ),)
    // );
    for (int i = 0; i < _list.length; i++){
      widgets.add(_buildListItem(i));
    }
    widgets.add(Center(
      child: page < total ? Image.asset(ImageIcons.Loading_icon,width: 150,) : Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        child: Text(
          _list.length > 5 ? '已经到底了！' : (_list.isEmpty ? '暂时还没有' : ''),
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    ));
    return Column(
      children: widgets,
    );
  }
  _buildListItem(int index){
    CashInOrder order = _list[index];
    return Container(
      margin: const EdgeInsets.all(10),
      width: ((MediaQuery.of(context).size.width) / 1),
      decoration:  BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: const Color(0xFFD9D9D9),),
        color: const Color(0xFFFAFAFA),
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("充值",style: TextStyle(color: Colors.black,fontSize:18,fontWeight: FontWeight.normal)),
                Row(
                  children: [
                    const Icon(Icons.add,color: Colors.orangeAccent,size: 20,),
                     Text((order.amount / 100).toStringAsFixed(2),style: const TextStyle(color: Colors.red,fontSize:30,fontWeight: FontWeight.bold)),
                    const Text("元",style: TextStyle(color: Colors.orangeAccent,fontSize:15)),
                  ]
                ),
              ]
            ),
            Container(
              margin: const EdgeInsets.only(top:10),
              height: 1,
              color: const Color(0xFFD9D9D9),
            ),
            Container(
              margin: const EdgeInsets.only(top:10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        Icon(Icons.access_time,color: Colors.black.withOpacity(0.3),size: 20,),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Text("充值时间",style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize:15,fontWeight: FontWeight.normal)),
                      ]
                  ),
                  Text(Global.getTimeToString(order.updateTime),style: const TextStyle(color: Colors.black,fontSize:15,fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        Icon(Icons.check_circle_outlined,color: Colors.black.withOpacity(0.3),size: 20,),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Text("充值状态",style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize:15,fontWeight: FontWeight.normal)),
                      ]
                  ),
                  Text(order.status < 0 ? '支付失败' : (order.status == 0 ? '支付中' : '支付成功'),
                    style:  TextStyle(color: order.status < 0 ? Colors.red : (order.status == 0 ? Colors.grey : Colors.green),fontSize: 15,)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
