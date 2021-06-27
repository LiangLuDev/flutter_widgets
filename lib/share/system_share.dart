import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

class SystemShare extends StatefulWidget {
  @override
  _SystemShareState createState() => _SystemShareState();
}

class _SystemShareState extends State<SystemShare> {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: '分享选中书源'
    );
  }

  Future<void> shareFile() async {
    Directory directory;
    if(Platform.isIOS){
      directory = await getApplicationSupportDirectory();
    }else if(Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }

    if(directory!=null) {
      String localPath = directory.path + '/HuaHuo-Source${DateTime
          .now()
          .millisecond}.json';
      File file = File(localPath);
      await file.writeAsString('{sourceName:"起点中文"}');
      await FlutterShare.shareFile(
        title: 'Example share',
        text: 'Example share text',
        chooserTitle: '分享选中书源',
        filePath: localPath,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Share text and link'),
                onPressed: share,
              ),
              FlatButton(
                child: Text('Share local file'),
                onPressed: shareFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
