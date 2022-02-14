/**
 * @Title:
 * @Package
 * @Description: 单列 多列 日期选择器
 * @author A18ccms A18ccms_gmail_com
 * @date
 * @version V1.0
 */


import 'package:flutter/material.dart';

import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:date_format/date_format.dart';


const double _kPickerHeight=216.0;
const double _kItemHeigt=40.0;
const Color _kBtnColor=Color(0xFF323232);
const Color _kTitleColor=Color(0xFF787878);
const double _kTextFontSize=17.0;

typedef _StringClickCallBack=void Function(int selectIndex,Object selectStr);
typedef _ArrayClickCallBack=void Function(List<int> selecteds,List<dynamic> strData);
typedef _DateClickCallBack=void Function(dynamic selectDateStr,dynamic selectData);


enum DateType {
  YMD, // y,m,d
  YM, // y,m
  YMD_HM, //y,m,d,hh,mm
  YMD_AP_HM, //y,m,d,ap,hh,mm

}

class JhPickerTool{

  static void openModalPicker(
      BuildContext context,{
        required PickerAdapter adapter,
        String? title,
        List<int>?  selecteds,
        required PickerConfirmCallback clickCallBack,
      }) {
    Picker(
        adapter: adapter,
        title: Text(title??"请选择",style: const TextStyle(color: _kTitleColor,fontSize: _kTextFontSize),),
        selecteds: selecteds,
        cancelText: '取消',
        confirmText: "确定",
        cancelTextStyle: const TextStyle(color: _kBtnColor,fontSize: _kTextFontSize),
        confirmTextStyle: const TextStyle(color: _kBtnColor,fontSize: _kTextFontSize),
        textAlign: TextAlign.right,
        itemExtent: _kItemHeigt,
        height: _kPickerHeight,
        selectedTextStyle: const TextStyle(color: Colors.black),
        onConfirm: clickCallBack
    ).showModal(context);
  }


  //日期选择器
  static void showDatePicker(
      BuildContext context,{
        required DateType dateType,
        String? title,
        DateTime? maxValue,
        DateTime? minValue,
        DateTime? value,
        DateTimePickerAdapter? adapter,
        required _DateClickCallBack clickCallBack,}
      ) {
    int timeType;
    if(dateType==DateType.YM) {
      timeType=PickerDateTimeType.kYM;
    }else if(dateType==DateType.YMD_HM){
      timeType=PickerDateTimeType.kYMDHM;
    }else if(dateType==DateType.YMD_AP_HM) {
      timeType=PickerDateTimeType.kYMD_AP_HM;
    }else {
      timeType=PickerDateTimeType.kYMD;
    }
    openModalPicker(context, adapter: adapter?? DateTimePickerAdapter(
      type: timeType,
      isNumberMonth: true,
      yearSuffix: "年",
      monthSuffix: "月",
      daySuffix: "日",
      strAMPM: const["上午","下午"],
      maxValue: maxValue,
      minValue: minValue,
      value: value??DateTime.now(),
    ), title: title,
        clickCallBack: (Picker picker,List<int> selecteds){
          DateTime time=(picker.adapter as DateTimePickerAdapter).value!;
          var timeStr;
          if(dateType==DateType.YM) {
            time = DateTime(time.year,time.month);
            timeStr=time.year.toString()+"年"+time.month.toString()+"月";
          }else if(dateType==DateType.YMD_HM){
            time = DateTime(time.year,time.month,time.day,time.hour,time.minute);
            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日"+time.hour.toString()+"时"+time.minute.toString()+"分";
          }else if(dateType == DateType.YMD_AP_HM) {
            time = DateTime(time.year,time.month,time.day,time.hour,time.minute);
            var str = formatDate(time, [am])=="AM" ? "上午":"下午";
            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日"+str+time.hour.toString()+"时"+time.minute.toString()+"分";
          }else {
            time = DateTime(time.year,time.month,time.day);
            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日";
          }
          clickCallBack(timeStr,time.millisecondsSinceEpoch);
        });

  }

}

