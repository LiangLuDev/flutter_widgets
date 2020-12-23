import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/utils/text_util.dart';

import 'markdown_bsapp_bean.dart';

class CustomMarkdownAppWidget extends StatefulWidget {
  MarkdownBsappBean _bean;

  CustomMarkdownAppWidget(this._bean);

  @override
  _CustomMarkdownAppWidgetState createState() =>
      _CustomMarkdownAppWidgetState();
}

class _CustomMarkdownAppWidgetState extends State<CustomMarkdownAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: Color(0xFFF7F7F7), // 底色
        color: Colors.black.withOpacity(0.03), // 底色
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget._bean.iconUrl,
                height: 48,
                width: 48,
                fit: BoxFit.fill,
              )),
          Container(
            margin: EdgeInsets.only(left: 14),
            child: Column(
              children: [
                Text(
                  widget._bean.appName,
                  style: textStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(
                    widget._bean.desc,
                    style: textStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          FlatButton(
            height: 28,
            minWidth: 72,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {},
            child: Text(
              '安装',
              style: textStyle(
                  fontSize: 13,
                  color: Color(0xFF00D062),
                  fontWeight: FontWeight.bold),
            ),
            color: Colors.black.withOpacity(0.03),
          )
        ],
      ),
    );
  }
}
