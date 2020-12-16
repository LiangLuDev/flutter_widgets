
import 'dart:math';

import 'package:flutter/material.dart';

import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'shop_scroll_controller.dart';
import 'shop_scroll_coordinator.dart';


class MeiTuanHomePage extends StatefulWidget {
  MeiTuanHomePage({Key key}) : super(key: key);

  @override
  _MeiTuanHomePageState createState() => _MeiTuanHomePageState();
}

MediaQueryData mediaQuery;
double statusBarHeight;
double screenHeight;
class _MeiTuanHomePageState extends State<MeiTuanHomePage>
    with SingleTickerProviderStateMixin {
  ///页面滑动协调器
  ShopScrollCoordinator _shopCoordinator;
  ShopScrollController _pageScrollController;

  TabController _tabController;

  final double _sliverAppBarInitHeight = 200;
  final double _tabBarHeight = 50;
  double _sliverAppBarMaxHeight;

  @override
  void initState() {
    super.initState();
    _shopCoordinator = ShopScrollCoordinator();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery ??= MediaQuery.of(context);
    screenHeight ??= mediaQuery.size.height;
    statusBarHeight ??= mediaQuery.padding.top;

    _sliverAppBarMaxHeight ??= screenHeight;
    _pageScrollController ??= _shopCoordinator
        .pageScrollController(_sliverAppBarMaxHeight - _sliverAppBarInitHeight);

    _shopCoordinator.pinnedHeaderSliverHeightBuilder ??= () {
      return statusBarHeight + kToolbarHeight + _tabBarHeight;
    };
    return Scaffold(
      body: Listener(
        onPointerUp: _shopCoordinator.onPointerUp,
        child: CustomScrollView(
          controller: _pageScrollController,
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: Text("店铺首页", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue,
              expandedHeight: _sliverAppBarMaxHeight,
            ),
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: 100,
                minHeight: 100,
                child: Center(child: Text("我是活动Header")),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverAppBarDelegate(
                maxHeight: _tabBarHeight,
                minHeight: _tabBarHeight,
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Colors.black,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(text: "商品"),
                      Tab(text: "评价"),
                      Tab(text: "商家"),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Page1(shopCoordinator: _shopCoordinator),
                  Page2(shopCoordinator: _shopCoordinator),
                  Page3(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageScrollController?.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => this.minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}