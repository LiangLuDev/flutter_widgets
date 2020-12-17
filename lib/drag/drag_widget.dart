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
  Drag drag;
  PageController _pageController = PageController(viewportFraction: 0.9);
  SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      print('_pageController : ${_pageController.position.pixels}');
    });
    slidableController = SlidableController(
      onSlideAnimationChanged: (Animation<double> slideAnimation) {},
      onSlideIsOpenChanged: (bool isOpen) {},
    );
  }

  double _left = 400;
  double _progress = 100;
  double _downDx = 0;
  double _upDx = 0;
  double _width = 400;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DragWidget'),),
      body: Container(
        height: 100,
        child: PageView.builder(
            reverse: true,
            controller: _pageController,
            allowImplicitScrolling: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Slidable.builder(
                actionExtentRatio: 0.23,
                actionPane: SlidableDrawerActionPane(),
                child: Container(
                  color: Colors.red,
                  child: ListTile(
                    title: Text('title $index'),
                    subtitle: Text('subtitle $index'),
                  ),
                ),
                secondaryActionDelegate: SlideActionBuilderDelegate(builder: (BuildContext context, int index, Animation<double> animation, SlidableRenderingMode step) {
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
                }, actionCount: 1),
                onDragStart: (DragStartDetails details){
                  dragStartDetails = details;
                },
                onDragUpdate: (details){
                  if(details.delta.dx > 0 ){ // allow pageview scroll
                    drag = _pageController.position.drag(dragStartDetails, () {});
                    drag.update(details);
                  }else{
                    drag?.cancel();
                  }
                },
                onDragEnd: (details){
                  drag?.cancel();
                },
              );
            }),
      ),
    );
  }
}
