import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_widgets/drag/custom_page_scroll_physics.dart';

/// 左滑响应Slidable左滑删除
/// 右滑响应PageView滚动
class DragWidget extends StatefulWidget {
  @override
  _DragWidgetState createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  DragStartDetails dragStartDetails;
  Drag drag;
  PageController _pageController = PageController(viewportFraction: 0.8);
  var _currPageValue = 0.0;

  _buildPageItem(int index) {
    double value;
    if (_pageController.position.haveDimensions) {
      value = _pageController.page - index;
    } else {
      // If haveDimensions is false, use _currentPage to calculate value.
      value = (_currPageValue - index).toDouble();
      // print('haveDimensions $value');
    }
    value = _currPageValue < index ? 1 : (1 - (value.abs())).clamp(0, 1).toDouble();
    return Opacity(
      opacity: value,
      child: Slidable.builder(
        actionExtentRatio: 0.23,
        actionPane: SlidableDrawerActionPane(),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          color: Colors.red,
          child: ListTile(
            title: Text('title $index'),
            subtitle: Text('subtitle $index'),
          ),
        ),
        secondaryActionDelegate: SlideActionBuilderDelegate(
            builder: (BuildContext context, int index,
                Animation<double> animation, SlidableRenderingMode step) {
              return SlideAction(
                color: Theme.of(context).backgroundColor,
                closeOnTap: false,
                child: ClipOval(
                  child: Container(
                    height: 48,
                    width: 48,
                    padding: EdgeInsets.all(12),
                    color: Color(0xFFEB5147),
                    child: Icon(Icons.ac_unit),
                  ),
                ),
              );
            },
            actionCount: 1),
        onDragStart: (DragStartDetails details) {
          // dragStartDetails = details;
        },
        onDragUpdate: (details) {
          // if (details.delta.dx > 0) {
          //   // allow pageview scroll
          //   drag = _pageController.position.drag(dragStartDetails, () {});
          //   drag.update(details);
          // } else {
          //   drag?.cancel();
          // }
        },
        onDragEnd: (details) {
          // print('details ${details.primaryVelocity}');
          // print('details velocity${details.velocity}');
          // drag?.cancel();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currPageValue = _pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DragWidget'),
      ),
      body: Container(
        height: 100,
        child: PageView.builder(
            reverse: true,
            pageSnapping:false,//必须
            controller: _pageController,
            allowImplicitScrolling: true,
            itemCount: 5,
            physics: CustomPageScrollPhysics(),
            onPageChanged: (page) {
              print('page : $page');
            },
            itemBuilder: (BuildContext context, int index) {
              // return ListTile(
              //   title: Text('title $index'),
              //   subtitle: Text('subtitle $index'),
              // );
              return _buildPageItem(index);
            }),
      ),
    );
  }
}
