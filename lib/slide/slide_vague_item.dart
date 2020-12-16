import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class SlideItem extends StatefulWidget {
  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> with TickerProviderStateMixin{
  double _left = 400;
  double _progress = 100;
  double _downDx = 0;
  double _upDx = 0;
  double _width = 400;
  var _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: GestureDetector(
        onPanStart: (details) {
          _downDx = details.localPosition.dx;
          setState(() {});
        },
        onPanUpdate: (details) {
          _upDx = details.localPosition.dx;
          _left += details.delta.dx;
          if (_left <= 0) _left = 0;
          if (_left >= _width) _left = _width;
          _progress = ((100 / _width) * _left);
          setState(() {});
        },
        onPanEnd: (details) {
          if (_upDx < _downDx) {
            if (_progress > 80) {
              _progress = 100;
              _left = _width;
            } else {
              _progress = 0;
              _left = 0;
            }
          } else {
            if (_progress > 20) {
              _progress = 100;
              _left = _width;
            } else {
              _progress = 0;
              _left = 0;
            }
          }
          setState(() {});
        },
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              width: _width,
              height: 100,
              child: ListTile(
                title: Text('标题ing'),
                subtitle: Text('你好呀，今天天气很不错，耶耶耶'),
              ),
            ),
            AnimatedPositioned(
                left: _left,
                duration: Duration(milliseconds: 100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: (100 - _progress) / 20,
                      sigmaY: (100 - _progress) / 20),
                  child: Container(
                    height: 100,
                    width: _width,
                    color: Colors.white10,
                    child: Row(
                      children: [
                        IconButton(icon: Icon(Icons.add), onPressed: () {})
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}
