import 'package:flutter/material.dart';

// 列表曝光功能
class Card extends StatelessWidget {
  final String text;

  Card({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      color: Colors.greenAccent,
      height: 300.0,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }
}

class VisibilityState {
  const VisibilityState({this.firstIndex, this.lastIndex});

  final int firstIndex;
  final int lastIndex;
}

class ChangeSet {
  final List<int> exposure = [];
  final List<int> hidden = [];

  bool get empty => exposure.length == 0 && hidden.length == 0;
}

class VisibilityMonitor {
  VisibilityState lastState;

  addSequenceToList(List<int> list, int sequenceStart, int sequenceEnd) {
    if (sequenceStart <= sequenceEnd) {
      for (var i = sequenceStart; i <= sequenceEnd; i++) {
        list.add(i);
      }
    } else {
      for (var i = sequenceEnd; i >= sequenceStart; i--) {
        list.add(i);
      }
    }
  }

  update(VisibilityState newState) {
    if (lastState != null &&
        newState.firstIndex == lastState.firstIndex &&
        newState.lastIndex == lastState.lastIndex) {
      return;
    }

    final changeSet = ChangeSet();

    if (lastState == null) {
      addSequenceToList(
          changeSet.exposure, newState.firstIndex, newState.lastIndex);
    } else if (newState.firstIndex > lastState.lastIndex) {
      addSequenceToList(
          changeSet.exposure, newState.firstIndex, newState.lastIndex);
      addSequenceToList(
          changeSet.hidden, lastState.firstIndex, lastState.lastIndex);
    } else if (newState.lastIndex < lastState.firstIndex) {
      addSequenceToList(
          changeSet.exposure, newState.lastIndex, newState.firstIndex);
      addSequenceToList(
          changeSet.hidden, lastState.lastIndex, lastState.firstIndex);
    } else {
      if (newState.firstIndex < lastState.firstIndex) {
        addSequenceToList(
            changeSet.exposure, lastState.firstIndex - 1, newState.firstIndex);
      }

      if (newState.firstIndex > lastState.firstIndex) {
        addSequenceToList(
            changeSet.hidden, lastState.firstIndex, newState.firstIndex - 1);
      }

      if (newState.lastIndex > lastState.lastIndex) {
        addSequenceToList(
            changeSet.exposure, lastState.lastIndex + 1, newState.lastIndex);
      }

      if (newState.lastIndex < lastState.lastIndex) {
        addSequenceToList(
            changeSet.hidden, lastState.lastIndex, newState.lastIndex + 1);
      }
    }

    lastState = newState;

    if (!changeSet.empty) {
      changeSet.exposure.forEach((i) {
        print('第 $i 张卡片曝光了');
      });

      // changeSet.hidden.forEach((i) {
      //   print('第 $i 张卡片隐藏了');
      // });
    }
  }
}

class MySliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  MySliverChildBuilderDelegate(
      Widget Function(BuildContext, int) builder, {
        int childCount,
        bool addAutomaticKeepAlives = true,
        bool addRepaintBoundaries = true,
      }) : super(builder,
      childCount: childCount,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries);

  final visibilityMonitor = VisibilityMonitor();

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    visibilityMonitor.update(VisibilityState(
      firstIndex: firstIndex,
      lastIndex: lastIndex,
    ));
  }
}

class HelloFlutter extends StatelessWidget {
  final items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      childrenDelegate: MySliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Card(text: '$index');
        }, childCount: items.length,
      ),
      cacheExtent: 0.0,
    );
  }
}