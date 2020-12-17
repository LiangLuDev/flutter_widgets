import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../net/http_helper.dart';
import 'package:html/dom.dart' as dom;

// html解析
class HtmlScreen extends StatefulWidget {
  @override
  _HtmlScreenState createState() => _HtmlScreenState();
}

class _HtmlScreenState extends State<HtmlScreen> {
  String data = '';

  loadData() {
    rootBundle.loadString('assets/test.html').then((value) {
      this.data = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_html Example'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          FlatButton(
              onPressed: () {
                HttpHelper.get('https://www.gentleflow.tech/',
                    success: (value) {
                  setState(() {});
                });
              },
              child: Text('获取网页数据')),
          HtmlWidget(
            data,
            onTapUrl: (url) {
              launch(url);
            },
            customWidgetBuilder: (dom.Element element) {
              if (element.localName == 'bs-game') {
                print('element ${element.text}');
                return Container(
                  color: Colors.orange,
                  child: Text(element.text),
                );
              }
              return null;
            },
          )
        ],
      ),
    );
  }
}
