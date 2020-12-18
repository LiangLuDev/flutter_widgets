import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoWidget extends StatefulWidget {
  String url;
  Map<String, String> attributes;

  CustomVideoWidget(this.url, {this.attributes});

  @override
  _CustomVideoWidgetState createState() => _CustomVideoWidgetState();
}

class _CustomVideoWidgetState extends State<CustomVideoWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  initializePlayer() async {
    _controller = VideoPlayerController.network(widget.url);
    await _controller.initialize();
    setState(() {
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller.value.initialized
        ? Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 200,
            // color: Colors.black26,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: VideoPlayer(_controller)),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey, // 底色
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 200,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
  }
}
