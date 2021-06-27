import 'package:flutter/material.dart';
import 'package:flutter_widgets/route/anim_page_route.dart';

import 'anim_route_test_page.dart';

class AnimRoutePage extends StatefulWidget {
  @override
  _AnimRoutePageState createState() => _AnimRoutePageState();
}

class _AnimRoutePageState extends State<AnimRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('打开新页面'),
          onPressed: () => Navigator.of(context).push(AnimPageRoute(AnimRouteTestPage())),
        ),
      ),
    );
  }
}
