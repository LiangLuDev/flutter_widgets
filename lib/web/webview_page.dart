import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoadFinished = false;
  String _url = 'http://store.blackshark.com/v/index.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoadFinished
            ? Text(
                'xx商城',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              )
            : CupertinoActivityIndicator(),
        backgroundColor: Theme.of(context).backgroundColor,
        brightness: Theme.of(context).brightness,
        centerTitle: true,
        elevation: 0,
      ),
      body: Builder(builder: (context) {
        return WebView(
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) {
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _isLoadFinished = true;
              });
            });
          },
        );
      }),
    );
  }
}
