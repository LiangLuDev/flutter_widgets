import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// 左滑响应Slidable左滑删除
/// 右滑响应PageView滚动
class DragWidget extends StatefulWidget {
  @override
  _DragWidgetState createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  DragStartDetails dragStartDetails;
  Drag _drag;
  ScrollHoldController _hold;
  PageController _pageController = PageController(viewportFraction: 0.8);
  var _currPageValue = 0.0;
  Map<Type, GestureRecognizerFactory> _gestureRecognizers;

  ScrollPhysics _physics;

  initGestureRecognizer() {
    _gestureRecognizers = <Type, GestureRecognizerFactory>{
      CustomHorizontalDragGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<
                  CustomHorizontalDragGestureRecognizer>(
              () => CustomHorizontalDragGestureRecognizer(),
              (CustomHorizontalDragGestureRecognizer instance) {
        instance
          ..onStart = _handleDragStart
          ..onDown = _handleDragDown
          ..onUpdate = _handleDragUpdate
          ..onEnd = _handleDragEnd
          ..onCancel = _handleDragCancel;
      }),
    };
  }

  _handleDragStart(details) {
    _drag = _pageController.position.drag(details, _disposeDrag);
  }

  _handleDragDown(details) {
    _hold = _pageController.position.hold(_disposeHold);
  }

  _handleDragUpdate(details) {
    if (details.delta.dx > 0) {
      _physics = PageScrollPhysics().applyTo(const ClampingScrollPhysics());
      _drag?.update(details);
    } else {
      _physics =
          PageScrollPhysics().applyTo(const NeverScrollableScrollPhysics());
      _drag?.cancel();
    }
  }

  _handleDragEnd(details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    assert(_hold == null || _drag == null);
    _hold?.cancel();
    _drag?.cancel();
    assert(_hold == null);
    assert(_drag == null);
  }

  void _disposeHold() {
    _hold = null;
  }

  void _disposeDrag() {
    _drag = null;
  }

  _buildPageItem(int index) {
    double value;
    if (_pageController.position.haveDimensions) {
      value = _pageController.page - index;
    } else {
      value = (_currPageValue - index).toDouble();
    }
    value =
        _currPageValue < index ? 1 : (1 - (value.abs())).clamp(0, 1).toDouble();
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initGestureRecognizer();
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
      body: RawGestureDetector(
        behavior: HitTestBehavior.deferToChild,
        gestures: _gestureRecognizers,
        child: Container(
          height: 100,
          child: PageView.builder(
              reverse: true,
              //必须
              controller: _pageController,
              allowImplicitScrolling: true,
              itemCount: 5,
              physics: _physics,
              itemBuilder: (BuildContext context, int index) {
                return _buildPageItem(index);
              }),
        ),
      ),
    );
  }
}

class CustomHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
