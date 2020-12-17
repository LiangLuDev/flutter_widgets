import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown/markdown.dart' as m;

/// Markdown解析，支持自定义标签
class MarkdownCustomWidget extends StatefulWidget {
  @override
  _MarkdownCustomWidgetState createState() => _MarkdownCustomWidgetState();
}

class _MarkdownCustomWidgetState extends State<MarkdownCustomWidget> {
  String data = '';
  loadData(){
    rootBundle.loadString('assets/test_md.md').then((value) {
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
        title: Text(
          'MarkdownCustomWidget',
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: MarkdownWidget(data: data,
        styleConfig: StyleConfig(pConfig: PConfig(
          custom: (m.Element element) {
            print('element ${element.tag}');
            print('element ${element.textContent}');
            print('element ${element.attributes['content']}');
            return Container(height: 50,width: 50,color: Colors.red,);
          },
        ),
        ),
        ),
      ),
    );
  }
}
