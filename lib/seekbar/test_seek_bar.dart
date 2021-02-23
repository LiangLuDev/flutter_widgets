import 'package:flutter/material.dart';
import 'package:flutter_widgets/seekbar/seek_bar.dart';

class TestSeekBar extends StatefulWidget {
  @override
  _TestSeekBarState createState() => _TestSeekBarState();
}

class _TestSeekBarState extends State<TestSeekBar> {
  double _tempValue = 0.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('进度条'),
      ),
      body: Center(
        child: Container(
          width: 200,
          child: SeekBar(
            value: _tempValue,
            // height: 5,
            onValueChanged: (v) {
              setState(() => _tempValue = v.value);
            },
          ),
        ),
      ),
    );
  }
}
