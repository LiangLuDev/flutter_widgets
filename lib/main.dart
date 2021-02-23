import 'package:flutter/material.dart';
import 'package:flutter_widgets/drag/drag_widget.dart';
import 'package:flutter_widgets/scroll/scroll_bar.dart';
import 'package:flutter_widgets/seekbar/test_seek_bar.dart';

import 'drag/drag_demo.dart';
import 'panellist/panel_grid_view.dart';
import 'parse/markdown_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TestSeekBar(),
    );
  }
}