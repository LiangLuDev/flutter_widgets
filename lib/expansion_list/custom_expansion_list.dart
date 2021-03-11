import 'package:flutter/material.dart';

class CustomExpansionList extends StatefulWidget {
  @override
  _CustomExpansionListState createState() => _CustomExpansionListState();
}

class _CustomExpansionListState extends State<CustomExpansionList> {
  List<int> mList; //组成一个int类型数组，用来控制索引
  List<ExpandStateBean> expandStateList; //开展开的状态列表,ExpandStateBean是自定义的类

  @override
  initState() {
    super.initState();
    _ExpansionPanelListDemoState();
  }
  //构造方法，调用这个类的时候自动执行
  _ExpansionPanelListDemoState() {
    mList = new List();
    expandStateList = new List();
    //遍历两个List进行赋值
    for (int i = 0; i < 19; i++) {
      mList.add(i);
      expandStateList.add(ExpandStateBean(i, false)); //item初始状态为闭着的
    }
  }

  //修改展开与闭合的内部方法
  _setCurrentIndex(int index, isExpand) {
    setState(() {
      //遍历可展开状态列表
      expandStateList.forEach((item) {
        if (item.index == index) {
          //取反，经典取反方法
          item.isOpen = !isExpand;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("expansion panel list"),
      ),
      //加入可滚动组件(ExpansionPanelList必须使用可滚动的组件)
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(title: Text('This is No.$index'),
            leading: Icon(Icons.favorite,color: Colors.white,),
          backgroundColor: Colors.lightBlue,
          initiallyExpanded: false,//默认是否展开
            children: [
            Text('This is No.$index'),
            Text('This is No.$index'),
            Text('This is No.$index'),
          ],);
        },
      ),
    );
  }
}

//list中item状态自定义类
class ExpandStateBean {
  var isOpen; //item是否打开
  var index; //item中的索引
  ExpandStateBean(this.index, this.isOpen);
}
