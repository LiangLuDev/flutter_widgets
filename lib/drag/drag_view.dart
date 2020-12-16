import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// 仿网易云tab滑动冲突
final PageController _pageController = PageController();

class DragView extends StatefulWidget {
  @override
  _DragViewState createState() => _DragViewState();
}

class _DragViewState extends State<DragView> {


  PageView myPageView = PageView(
    controller: _pageController,
    allowImplicitScrolling: true,
    children: <Widget>[
      Container(color: Colors.red),
      GreenShades(),
      Container(color: Colors.yellow),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabBarView inside PageView'),
      ),
      body: myPageView,
    );
  }
}

class GreenShades extends StatefulWidget {
  @override
  _GreenShadesState createState() => _GreenShadesState();
}

class _GreenShadesState extends State<GreenShades>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Local dragStartDetail.
    DragStartDetails dragStartDetails;
    // Current drag instance - should be instantiated on overscroll and updated alongside.
    Drag drag;
    return Column(
      children: <Widget>[
        TabBar(
          labelColor: Colors.green,
          indicatorColor: Colors.green,
          controller: _tabController,
          tabs: <Tab>[
            const Tab(text: "Dark"),
            const Tab(text: "Normal"),
            const Tab(text: "Light"),
          ],
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                dragStartDetails = notification.dragDetails;
              }
              if (notification is OverscrollNotification) {
                drag = _pageController.position.drag(dragStartDetails, () {});
                drag.update(notification.dragDetails);
              }
              if (notification is ScrollEndNotification) {
                drag?.cancel();
              }
              //
              // if (notification is UserScrollNotification &&
              //     notification.direction == ScrollDirection.forward &&
              //     !_tabController.indexIsChanging &&
              //     dragStartDetails != null &&
              //     _tabController.index == 0) {
              //   _pageController.position.drag(dragStartDetails, () {});
              // }
              //
              // // Simialrly Handle the last tab.
              // if (notification is UserScrollNotification &&
              //     notification.direction == ScrollDirection.reverse &&
              //     !_tabController.indexIsChanging &&
              //     dragStartDetails != null &&
              //     _tabController.index == _tabController.length - 1) {
              //   _pageController.position.drag(dragStartDetails, () {});
              // }
              return true;
            },
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(color: Colors.green[800]),
                Container(color: Colors.green),
                Container(color: Colors.green[200]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}