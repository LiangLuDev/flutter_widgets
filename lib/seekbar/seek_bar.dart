import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  ///最小值
  double min;

  ///最大值
  double max;

  ///进度值
  double value;

  /// 高度
  double height;

  /// 指示器的半径
  double indicatorRadius;

  ///指示器的颜色
  Color indicatorColor;

  ///进度条背景的颜色
  Color backgroundColor;

  /// 进度条当前进度的颜色
  Color progressColor;

  // 进度条圆角
  double radius;

  ///进度改变的回调
  ValueChanged<ProgressValue> onValueChanged;

  /// 是否可以触摸响应触摸事件
  bool isCanTouch;

  SeekBar(
      {this.min = 0.0,
      this.max = 1.0,
      this.value = 0,
      this.height = 2,
      this.indicatorRadius = 9,
      this.indicatorColor = Colors.blue,
      this.backgroundColor = Colors.grey,
      this.progressColor = Colors.blue,
      this.radius,
      this.onValueChanged,
      this.isCanTouch = true});

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  ///进度值
  double _value;

  ///高度
  double height;

  ///总高度
  double totalHeight;

  ///中间的指示器的圆角
  double indicatorRadius;

  double length;
  double e;
  double start;
  double end;
  Offset touchPoint = Offset.zero;
  ProgressValue v;

  @override
  void initState() {
    super.initState();
    _value = (widget.value - widget.min) / (widget.max - widget.min);
    height = widget.height ?? 5.0;
    indicatorRadius = widget.indicatorRadius ?? height + 2;

    if (indicatorRadius >= height) {
      totalHeight = indicatorRadius * 2;
    } else {
      totalHeight = height;
    }
    length = (widget.max - widget.min); //总���小
  }

  Widget _buildSeekBar(
      BuildContext context, double value, double min, double max) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 10,
      ),
      child: CustomPaint(
        painter: _SeekBarPainter(
            backgroundColor:
                widget.backgroundColor ?? Theme.of(context).primaryColor,
            progressColor:
                widget.progressColor ?? Theme.of(context).dividerColor,
            value: value,
            min: min,
            max: max,
            indicatorRadius: indicatorRadius,
            progresseight: height,
            radius: widget.radius ?? height / 2,
            indicatorColor:
                widget.indicatorColor ?? Theme.of(context).dividerColor),
      ),
    );
  }

  // Updates height and value when user taps on the SeekBar.
  void _onTapUp(TapUpDetails tapDetails) {
    RenderBox renderBox = context.findRenderObject();
    setState(() {
      touchPoint = new Offset(
          renderBox.globalToLocal(tapDetails.globalPosition).dx, 0.0);
      _value = touchPoint.dx / context.size.width;
      _setValue();
    });
  }

  void _onPanDown(DragDownDetails details) {
    RenderBox box = context.findRenderObject();
    touchPoint = box.globalToLocal(details.globalPosition);
    //防止绘画越界
    if (touchPoint.dx <= 0) {
      touchPoint = new Offset(0, 0.0);
    }
    if (touchPoint.dx >= context.size.width) {
      touchPoint = new Offset(context.size.width, 0);
    }
    if (touchPoint.dy <= 0) {
      touchPoint = new Offset(touchPoint.dx, 0.0);
    }
    if (touchPoint.dy >= context.size.height) {
      touchPoint = new Offset(touchPoint.dx, context.size.height);
    }
    setState(() {
      _value = touchPoint.dx / context.size.width;
      _setValue();
    });
  }

  // Updates height and value when user drags the SeekBar.
  void _onPanUpdate(DragUpdateDetails dragDetails) {
    RenderBox box = context.findRenderObject();
    touchPoint = box.globalToLocal(dragDetails.globalPosition);
    //防止绘画越界
    if (touchPoint.dx <= 0) {
      touchPoint = new Offset(0, 0.0);
    }
    if (touchPoint.dx >= context.size.width) {
      touchPoint = new Offset(context.size.width, 0);
    }
    if (touchPoint.dy <= 0) {
      touchPoint = new Offset(touchPoint.dx, 0.0);
    }
    if (touchPoint.dy >= context.size.height) {
      touchPoint = new Offset(touchPoint.dx, context.size.height);
    }
    setState(() {
      _value = touchPoint.dx / context.size.width;
      _setValue();
    });
  }

  void _onPanEnd(DragEndDetails dragDetails) {
    setState(() {
    });
  }

  void _setValue() {
    double realValue = length * _value + widget.min; //真实的值

    if (widget.onValueChanged != null) {
      ProgressValue v = ProgressValue(progress: _value, value: realValue);
      widget.onValueChanged(v);
    }
  }

  @override
  void didUpdateWidget(SeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _value = (widget.value - widget.min) / (widget.max - widget.min);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCanTouch) {
      return GestureDetector(
          onPanDown: _onPanDown,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onTapUp: _onTapUp,
          child: _buildSeekBar(context, _value, widget.min, widget.max));
    } else {
      return _buildSeekBar(context, _value, widget.min, widget.max);
    }
  }
}

@immutable
class _SeekBarPainter extends CustomPainter {
  ///背景颜色
  final Color backgroundColor;

  ///进度条的颜色
  final Color progressColor;

  ///进度值
  final double value;

  ///最大值
  final double min;

  ///最小值
  final double max;

  ///指示器的半径，进度条右侧的原点
  double indicatorRadius;

  ///最外层的圆角
  double radius;

  ///进度条的高度
  double progresseight;

  ///指示器的颜色
  Color indicatorColor;

  _SeekBarPainter({
    this.backgroundColor,
    this.progressColor,
    this.value,
    this.min,
    this.max,
    this.indicatorRadius,
    this.indicatorColor,
    this.radius,
    this.progresseight,
  });

  // 画path
  Path drawPath(double progresseight, double x, double totalHeight, double r) {
    Path path = new Path();
    //如果间隔存在，而且半径大于0，而且如果进度条的高度大于间隔的直径，半径就取高度的，否则进度条会变形
    double R = r;
    double startY = 0.0;
    double endY = progresseight;
    startY = (-progresseight + totalHeight) / 2;
    endY = (progresseight + totalHeight) / 2;
    if (r == null || r == 0.0) {
      path
        ..moveTo(0.0, startY)
        ..lineTo(x, startY)
        ..lineTo(x, endY)
        ..lineTo(0.0, endY);
    } else {
      path
        ..moveTo(R, startY)
        ..lineTo(x - R, startY)
        ..arcToPoint(Offset(x - R, endY),
            radius: Radius.circular(R), clockwise: true, largeArc: false)
        ..lineTo(R, endY)
        ..arcToPoint(Offset(R, startY),
            radius: Radius.circular(R), clockwise: true, largeArc: true);
    }
    path..close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(
        drawPath(progresseight, size.width, size.height, radius), paint); //画背景

    paint.color = progressColor;

    // 画进度条
    void drawBar(double x, double progress) {
      if (x <= 0.0) return;
      canvas.drawPath(drawPath(progresseight, x, size.height, radius), paint);
    }

    // 画当前显示的值的指示器
    void drawIndicator() {
      if (indicatorRadius <= 0.0) return;
      if (indicatorColor == null) {
        indicatorColor = progressColor;
      }
      Paint indicatorPaint = new Paint()
        ..style = PaintingStyle.fill
        ..color = indicatorColor;
      canvas.drawCircle(Offset(value * size.width, size.height / 2),
          indicatorRadius, indicatorPaint);
    }

    drawBar(value.clamp(0.0, 1.0) * size.width, value); //画进度

    drawIndicator(); //draw indicator
  }

  @override
  bool shouldRepaint(_SeekBarPainter oldPainter) {
    return oldPainter != this;
  }
}

class ProgressValue {
  /// 进度，如0.10，从0-1
  final double progress;

  /// 真实的值，给定最小和最大值，否则返回的是宽度的值
  final double value;

  const ProgressValue({this.value = 0.0, this.progress = 0.0});

  @override
  String toString() {
    return 'ProgressValue{progress: $progress, value: $value}';
  }
}
