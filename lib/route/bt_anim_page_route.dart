import 'package:flutter/material.dart';

class BtAnimPageRoute extends PageRouteBuilder {
  final Widget widget;

  BtAnimPageRoute(this.widget)
      : super(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) {
              return widget;
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) {
              Tween<Offset> tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0.0, 0.0));
              Color color = Color.fromRGBO(0, 0, 0, 0);
              return new PageEntry(
                child: child,
                backgroundColor: color,
                animate: tween.animate(CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
              );
            });
}

class PageEntry extends StatefulWidget {
  final Color backgroundColor;
  final Animation<Offset> animate;
  final Widget child;

  PageEntry({this.backgroundColor, @required this.animate, @required this.child});

  @override
  PageEntryState createState() => PageEntryState();
}

class PageEntryState extends State<PageEntry> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> position;
  double positionPercent;

  bool isMove = false;
  bool isClose = false;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    this.positionPercent = 0;
    this.position = widget.animate;
  }

  void changeOffset(DragUpdateDetails details, {bool isSlideClose = false}) {
    Size size = MediaQuery.of(context).size;
    double percent = 0;
    Offset offset;
    double closePosition;
    double canClosePosition;
    if (isSlideClose) {
      double offsetPositionDy = (size.height - (size.height - (localPosition.dy - details.localPosition.dy)));
      percent = -(offsetPositionDy / size.height);
      offset = Offset(0.0, percent);
      closePosition = size.height * 0.2;
      canClosePosition = offsetPositionDy.abs();
      print('closePosition $closePosition');
      print('canClosePosition $canClosePosition');
    } else {
      percent = details.localPosition.dx / size.width;
      offset = Offset(0.0, percent);
      closePosition = size.width * 0.2;
      canClosePosition = details.localPosition.dx;
    }
    Tween<Offset> tween = Tween<Offset>(begin: offset, end: offset);
    setState(() {
      this.positionPercent = percent;
      this.position = tween.animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
      isClose = canClosePosition > closePosition;
    });
  }

  void logout({bool isSlideClose = false}) {
    Tween<Offset> tween = Tween<Offset>(begin: Offset(0.0, this.positionPercent), end: Offset(0.0, 1));
    this.position = tween.animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    this.controller.forward()
      ..then((value) {
        Navigator.pop(context);
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Offset localPosition;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.backgroundColor,
      child: SlideTransition(
        position: this.position,
        child: GestureDetector(
          onVerticalDragStart: (details) {
            setState(() {
              localPosition = details.localPosition;
            });
          },
          onVerticalDragUpdate: (details) {
            if (details.localPosition.dy - localPosition.dy > 0) {
              changeOffset(details, isSlideClose: true);
            }
          },
          onVerticalDragEnd: (details) {
            setState(() {
              // 如果不是拉到阈值退出当前页，则让它还原初始位置
              if (this.isClose == false) {
                this.position = widget.animate;
              } else {
                logout(isSlideClose: true);
              }
            });
          },
          onHorizontalDragStart: (details) {
            Size size = MediaQuery.of(context).size;
            Offset localPosition = details.localPosition;
            // 是否可以滑动的起始位置
            double canMovePosition = size.width * 0.1;
            if (localPosition.dx <= canMovePosition) {
              setState(() {
                this.isMove = true;
              });
            }
          },
          onHorizontalDragUpdate: (details) {
            if (isMove) {
              changeOffset(details);
            }
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              // 如果不是拉到阈值退出当前页，则让它还原初始位置
              if (this.isClose == false) {
                this.position = widget.animate;
              } else {
                logout();
              }
              this.isMove = false;
            });
          },
          child: Container(
            decoration: new BoxDecoration(
              boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0)],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
