import 'dart:convert';

import 'package:movies/HttpManager.dart';
import 'package:movies/network/NWApi.dart';
import 'package:movies/network/NWMethod.dart';
import 'package:oss_dart/oss_dart.dart';
import 'dart:io';
class UploadOssUtil {
  static Future<void> upload(File file, String fileKey)async {
    OssClient client = OssClient(bucketName: 'bucketName',endpoint: 'endpoint',tokenGetter: getStsAccount);

    List<int> fileData = file.readAsBytesSync();//上传文件的二进制
    // String fileKey = 'ABC.text';//上传文件名
    var response;
    //上传文件
    response = await client.putObject(fileData, fileKey);
    //获取文件
    response = await client.getObject(fileKey);
    //分片上传
    //First get uploadId
    String uploadId = await client.initiateMultipartUpload(fileKey);
    //Second upload part
    num partNum = 1;//上传分块的序号
    String etag = await client.uploadPart(fileData,fileKey,uploadId,partNum);
    //Third complate multiUpload
    List etags = [etag];//所有区块上传完成后返回的etag，按顺序排列
    response = await client.completeMultipartUpload(etags, fileKey, uploadId);
    //response 是阿里云返回的xml格式的数据，需要单独解析
    print(response);
  }
  static Future<Map> getStsAccount()async{
    var data = await DioManager().requestAsync(NWMethod.GET, NWApi.getStsAccount, {});
    print(data);
    return jsonDecode(data!);
  }
}