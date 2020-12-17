
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 滑动事件示例
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListenerWidget(),
            _DragWidget(),
            DoubleGestureWidget(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: "指针事件",
            ),
            Tab(
              icon: Icon(Icons.rss_feed),
              text: "手势",
            ),
            Tab(
              icon: Icon(Icons.perm_identity),
              text: "手势冲突",
            )
          ],
          unselectedLabelColor: Colors.blueGrey,
          labelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.red,
        ),
      ),
    );
  }
}

class ListenerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Listener(
          child: Container(
            color: Colors.red,
            width: 300,
            height: 300,
          ),
          onPointerDown: (event) => print("down $event"),
          onPointerMove: (event) => print("move $event"),
          onPointerUp: (event) => print("up $event"),
        ));
  }
}

class _DragWidget extends StatefulWidget {
  @override
  _DragState createState() => new _DragState();
}

class _DragState extends State<_DragWidget> {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("demo"),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: _top,
              left: _left,
              child: GestureDetector(
                child: Container(color: Colors.red, width: 50, height: 50),
                onTap: () => print("Tap"),
                onDoubleTap: () => print("Double Tap"),
                onLongPress: () => print("Long Press"),
                onPanUpdate: (e) {
                  setState(() {
                    _left += e.delta.dx;
                    _top += e.delta.dy;
                  });
                },
              ),
            )
          ],
        ));
  }
}

class DoubleGestureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RawGestureDetector(
          gestures: {
            MultipleSlideGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                MultipleSlideGestureRecognizer>(
                    () => MultipleSlideGestureRecognizer(),
                    (MultipleSlideGestureRecognizer instance) {
                  instance.onUpdate = (DragUpdateDetails details) => print(' MultipleSlideGestureRecognizer parent tapped ');
                }),
            // MultipleTapGestureRecognizer:
            //     GestureRecognizerFactoryWithHandlers<MultipleTapGestureRecognizer>(
            //   () => MultipleTapGestureRecognizer(),
            //   (MultipleTapGestureRecognizer instance) {
            //     instance.onTap = () => print('parent tapped ');
            //   },
            // )
          },
          child: Container(
            color: Colors.pinkAccent,
            child: Center(
              child: GestureDetector(
                  onTap: () => print('Child tapped'),
                  onPanUpdate: (DragUpdateDetails details){
                    print('GestureDetector parent tapped ');
                  },
                  child: Container(
                    color: Colors.blueAccent,
                    width: 200.0,
                    height: 200.0,
                  )),
            ),
          ),
        ));
  }
}

class MultipleSlideGestureRecognizer extends PanGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class MultipleTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
