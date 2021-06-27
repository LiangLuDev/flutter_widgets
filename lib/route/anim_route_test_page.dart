import 'package:flutter/material.dart';

class AnimRouteTestPage extends StatefulWidget {

  @override
  _AnimRouteTestPageState createState() => _AnimRouteTestPageState();
}

class _AnimRouteTestPageState extends State<AnimRouteTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text('AnimRouteTestPage'),
      ),
    );
  }
}
