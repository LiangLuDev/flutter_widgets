import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/parse/custom_video_widget.dart';
import 'package:flutter_widgets/parse/markdown_bsapp_bean.dart';
import 'package:markdown/markdown.dart' as m;

import 'markdown_video_bean.dart';

Widget customWidget(m.Element element) {
  Widget widget = Container();
  Map jsonData = json.decode(element.textContent);
  if (jsonData.isEmpty) return widget;
  switch (element.tag) {
    case 'bs-app':
      MarkdownBsappBean bsappBean = MarkdownBsappBean.fromMap(jsonData);
      print('bsappBean :${bsappBean.appName}');
      widget = Container(
        child: Text(
          bsappBean.appName,
          style: TextStyle(color: Colors.red),
        ),
      );
      break;
    case 'bs-video':
      MarkdownVideoBean videoBean = MarkdownVideoBean.fromMap(jsonData);
      widget = CustomVideoWidget(videoBean.url);
      break;
  }
  return widget;
}