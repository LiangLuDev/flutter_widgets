import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'json_bean.dart';

class TestJsonPage extends StatefulWidget {
  @override
  _TestJsonPageState createState() => _TestJsonPageState();
}

class _TestJsonPageState extends State<TestJsonPage> {
  JsonBean _jsonBean;

  getJson() {
    rootBundle.loadString('assets/test.json').then((value) {
      try {
        _jsonBean = JsonBean.fromMap(json.decode(value));
        print('_jsonBean ${_jsonBean.success}');
      } catch (e) {
        print('e $e');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Json测试'),),
      body: Container(
        child: Column(
          children: [
            FlatButton(onPressed: () {
              getJson();
            }, child: Text('获取json',style: TextStyle(color: Colors.blue),)),
            Text(_jsonBean != null ? _jsonBean.data[0].intro : '空')
          ],
        ),
      ),
    );
  }
}
