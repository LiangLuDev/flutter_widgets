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
  Future _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  initializePlayer() async {
    _controller = VideoPlayerController.network(widget.url);
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 200,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      children: [
                        GestureDetector(
                            onTap: (){
                              if(!_isPlaying)return;
                              _isPlaying = false;
                              _controller.pause();
                              setState(() {

                              });
                            },
                            child: VideoPlayer(_controller)),
                        Offstage(
                          offstage: _isPlaying,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.slow_motion_video_rounded,
                                size: 48,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _controller.play();
                                _isPlaying = true;
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    ))),
          );
        } else {
          return Container(
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
      },
    );
  }
}
