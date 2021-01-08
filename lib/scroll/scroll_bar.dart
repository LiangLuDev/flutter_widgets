import 'package:flutter/material.dart';

class ScrollBarWidget extends StatefulWidget {
  @override
  _ScrollBarWidgetState createState() => _ScrollBarWidgetState();
}

class _ScrollBarWidgetState extends State<ScrollBarWidget> {
  bool _isOnScrollBar = false;
  double _barOffset = 0; //scrollbar位置
  double _viewOffset = 0; //列表滚动位置
  double _barHeight = 63; //scrollbar高度
  double _barMaxScrollExtent = 0; //scrollbar最大可滑动的范围
  double _barMinScrollExtent = 0; //scrollbar最小可滑动的范围
  double _viewMaxScrollExtent = 0; //列表最大可滑动的范围

  ScrollController _scrollBarController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScrollBarWidget'),
      ),
      body: Container(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            _viewMaxScrollExtent =
                _scrollBarController.position.maxScrollExtent;
            _barMaxScrollExtent = context.size.height - _barHeight;
            changePosition(notification);
            return true;
          },
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollBarController,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    color: Colors.red,
                    child: ListTile(
                      title: Text('title $index'),
                      subtitle: Text('subtitle $index'),
                    ),
                  );
                },
                itemCount: 20,
              ),
              Positioned(right: 1, top: _barOffset, child: scrollBar()),
            ],
          ),
        ),
      ),
    );
  }

  Widget scrollBar() {
    return RepaintBoundary(
      child: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedContainer(
          width: _isOnScrollBar ? 40 : 30,
          height: _barHeight,
          color: Colors.transparent,
          padding: EdgeInsets.only(left: _isOnScrollBar ? 32 : 27),
          duration: Duration(milliseconds: 100),
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.black, // 底色
              borderRadius: BorderRadius.circular((20.0)),
            ),
          ),
        ),
      ),
    );
  }

  _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isOnScrollBar = true;
    });
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (_isOnScrollBar) {
        _barOffset += details.delta.dy;
        if (_barOffset < _barMinScrollExtent) {
          _barOffset = _barMinScrollExtent;
        }
        if (_barOffset > _barMaxScrollExtent) {
          _barOffset = _barMaxScrollExtent;
        }

        double viewDelta = getScrollViewDelta(
            details.delta.dy, _barMaxScrollExtent, _viewMaxScrollExtent);

        _viewOffset = _scrollBarController.position.pixels + viewDelta;
        if (_viewOffset < _scrollBarController.position.minScrollExtent) {
          _viewOffset = _scrollBarController.position.minScrollExtent;
        }
        if (_viewOffset > _viewMaxScrollExtent) {
          _viewOffset = _viewMaxScrollExtent;
        }
        _scrollBarController.jumpTo(_viewOffset);
      }
    });
  }

  _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      _isOnScrollBar = false;
    });
  }

  changePosition(ScrollNotification notification) {
    if (_isOnScrollBar) return;
    if (notification.metrics.axis == Axis.horizontal) return;
    setState(() {
      if (notification is ScrollUpdateNotification) {
        _barOffset = getBarDelta(
          notification.metrics.pixels,
          _barMaxScrollExtent,
          _viewMaxScrollExtent,
        );

        if (_barOffset < _barMinScrollExtent ||
            _barOffset == _barMinScrollExtent) {
          _barOffset = _barMinScrollExtent;
        }
        if (_barOffset > _barMaxScrollExtent) {
          _barOffset = _barMaxScrollExtent;
        }

        _viewOffset += notification.scrollDelta;
        if (_viewOffset < _scrollBarController.position.minScrollExtent) {
          _viewOffset = _scrollBarController.position.minScrollExtent;
        }
        if (_viewOffset > _viewMaxScrollExtent) {
          _viewOffset = _viewMaxScrollExtent;
        }
      }
    });
  }

  double getBarDelta(
    double scrollViewDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    return scrollViewDelta * barMaxScrollExtent / (viewMaxScrollExtent);
  }

  double getScrollViewDelta(
    double barDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }
}
