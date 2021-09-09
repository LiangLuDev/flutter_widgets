import 'package:flutter/material.dart';
import 'package:webdav_client/webdav_client.dart';

class WebdavPage extends StatefulWidget {
  @override
  _WebdavPageState createState() => _WebdavPageState();
}

class _WebdavPageState extends State<WebdavPage> {
  var serverAddress = "https://dav.jianguoyun.com/dav/";
  var email = '1327995362@qq.com';
  var password = 'ajce75esjvcmy9jj';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Webdav'),),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            child: TextField(
              maxLines: 1,
              autofocus: false,
              onChanged: (text) {
                serverAddress = text;
              },
              decoration: InputDecoration(
                labelText: '服务器地址',
                hintText: "请输入服务器地址",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: TextField(
              maxLines: 1,
              autofocus: false,
              onChanged: (text) {
                email = text;
              },
              decoration: InputDecoration(
                labelText: '邮箱',
                hintText: "请输入邮箱",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            child: TextField(
              maxLines: 1,
              autofocus: false,
              onChanged: (text) {
                password = text;
              },
              decoration: InputDecoration(
                labelText: '密码',
                hintText: "请输入密码",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          FlatButton(
              onPressed: () {
                if (serverAddress == null || email == null || password == null) {
                  print('请正确填写信息 serverAddress : $serverAddress - email:$email - password : $password}');
                  return;
                }

                loginWebdav();
              },
              child: Text('登录'))
        ],
      ),
    );
  }

  loginWebdav() async{
    var client = newClient(
      serverAddress,
      user: email,
      password: password,
      debug: false,
    );

    try {
      await client.ping();
      await client.mkdir('/FireworksReader');
      client.readDir('/FireworksReader').then((value){
        print('${value.length > 0}');
        value.forEach((f) {
          print('${f.name} ${f.path}');
        });
      }).catchError((e){
        print('catchError $e');
      });

    } catch (e) {
      print('catch $e');
    }
  }



}
