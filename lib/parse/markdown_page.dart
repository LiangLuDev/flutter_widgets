import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/parse/custom_video_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'custom_image_widget.dart';
import 'custom_markdown_widget.dart';

/// Markdown解析，支持自定义标签
class MarkdownPage extends StatefulWidget {
  @override
  _MarkdownPageState createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  String data = '';

  loadData() {
    rootBundle.loadString('assets/test_md.md').then((value) {
      this.data = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MarkdownPage',
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 30,right: 30),
        child: MarkdownWidget(
          data: data,
          styleConfig: StyleConfig(
            pConfig: PConfig(
              custom: customWidget,
            ),
            imgBuilder: (String url,attributes){
              return CustomImageWidget(url);
            }
          ),
        ),
      ),
    );
  }
}
