import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

// 列表删除增加动画
class AnimatedListSize extends StatefulWidget {
  @override
  _AnimatedListSizeState createState() => _AnimatedListSizeState();
}

class _AnimatedListSizeState extends State<AnimatedListSize>
    with SingleTickerProviderStateMixin {
  List<int> _list = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    9,
    7,
    6,
    2,
    3,
    4,
    5,
    3,
    1,
    2,
    4,
    533,
    2,
    22
  ];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<KeyBean> keyList = List();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      for (KeyBean value in keyList) {
        value.setHeight(getY(value.key.currentContext));
      }
      _controller.addListener(() {
        print('_controller.offset : ${_controller.offset}');
        print('_controller.keyList : ${keyList.length}');
        for (int i = 0; i < keyList.length; i++) {
          KeyBean curKeyBean = keyList[i];
          KeyBean lastKeyBean = keyList[i++];
          if( i == keyList.length-1){
            return;
          }

          if (_controller.offset < lastKeyBean.height && _controller.offset < curKeyBean.height){
            print('addListener : ${curKeyBean.index}');
            continue;
          }

        }
      });
    });
  }

  double getY(BuildContext buildContext) {
    final RenderBox box = buildContext.findRenderObject();
    final topLeftPosition = box.localToGlobal(Offset.zero);
    return topLeftPosition.dy;
  }

  void _addItem() {
    final int _index = _list.length;
    _list.insert(0, _index);
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 400));
  }

  void _removeItem() {
    final int _index = _list.length - 1;
    var item = _list[0].toString();
    _listKey.currentState
        .removeItem(0, (context, animation) => _buildItem(item, animation));
    _list.removeAt(0);
  }

  Widget _buildItem(String _item, Animation _animation) {
    final curve = CurvedAnimation(parent: _animation, curve: Curves.linear);
    Animation<double> size =
        CurvedAnimation(curve: Interval(0.0, 0.7), parent: curve);
    Animation<double> opacity =
        CurvedAnimation(curve: Interval(0.7, 1.0), parent: curve);
    return SizeTransition(
      sizeFactor: size,
      child: FadeTransition(
        opacity: opacity,
        child: Card(
          child: ListTile(
            title: Text(
              _item,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedList'),
      ),
      body: AnimatedList(
        controller: _controller,
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: (BuildContext context, int index, Animation animation) {
          GlobalKey globalKey = GlobalKey();
          if (keyList.length <= _list.length) {
            keyList.add(KeyBean(index, globalKey));
          }
          return Container(
              key: globalKey,
              child: _buildItem(_list[index].toString(), animation));
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => _addItem(),
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 60,
          ),
          FloatingActionButton(
            onPressed: () => _removeItem(),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class KeyBean {
  int index;
  final GlobalKey key;
  double height;

  KeyBean(this.index, this.key);

  setHeight(double height) {
    this.height = height;
  }
}
