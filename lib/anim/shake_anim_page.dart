import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

class ShakeAnimPage extends StatefulWidget {
  @override
  _ShakeAnimPageState createState() => _ShakeAnimPageState();
}

class _ShakeAnimPageState extends State<ShakeAnimPage> with TickerProviderStateMixin {


  GlobalKey<AnimatorWidgetState> _key = GlobalKey<AnimatorWidgetState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('抖动动画'),
      ),
      body: Center(
        child: HeadShake(
          preferences: AnimationPreferences(autoPlay: AnimationPlayStates.None),
          key: _key,
          child: FlatButton(
            onPressed: () {
              _key.currentState.forward();
            },
            child: Text(
              '执行动画',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black,
          ),
        )
      ),
    );
  }
}
