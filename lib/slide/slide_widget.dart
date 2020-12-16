import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widgets/slide/slide_vague_item.dart';

// 左滑删除/置顶（高斯模糊覆盖）
class SlideWidget extends StatefulWidget {
  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Slide")),
        body: Container(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return SlideItem();
            },
            itemCount: 5,
          ),
        ));
  }
}
