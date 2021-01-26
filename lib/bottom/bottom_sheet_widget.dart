import 'package:flutter/material.dart';
import 'package:sliding_panel/sliding_panel.dart';

// 根据内容弹框高度，支持列表
class BottomSheetWidget extends StatefulWidget {
  List<Widget> sheetWidget;
  Widget bodyWidget;

  // PanelHeaderWidget headerWidget;
  Widget headerWidget;

  // PanelFooterWidget footerWidget;
  Widget footerWidget;

  // 关闭弹框传递参数
  Object closeArguments = '';

  // 展开最大高度
  double expandedMaxHeight;

  // 展开回调
  Function expandedCallback;

  // 关闭弹框回调
  Function(dynamic result) closedCallback;

  Color bottomBackgroundColor;

  PanelController controller;

  BottomSheetWidget(
      {@required this.sheetWidget,
      @required this.bodyWidget,
      @required this.controller,
      this.headerWidget,
      this.footerWidget,
      this.closeArguments = '',
      this.expandedMaxHeight = 0.85,
      this.expandedCallback,
      this.closedCallback,
      this.bottomBackgroundColor});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget>
    with SingleTickerProviderStateMixin {
  PanelController _panelController;
  AnimationController _animationController;
  PanelState state;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    _panelController = widget.controller ?? PanelController();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (state == PanelState.expanded) {
          _panelController.close();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Stack(
            children: [
              // basicAppBar(context, '', isPaddingTop: false),
              Opacity(
                opacity: opacity,
                child: Container(
                  decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.dstIn,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: SlidingPanel(
          panelController: _panelController,
          initialState: InitialPanelState.dismissed,
          // body 是否跟随上升
          parallaxSlideAmount: 0.0,
          // 弹框上面的背景色
          backdropConfig:
              BackdropConfig(enabled: true, shadowColor: Colors.black),
          decoration: PanelDecoration(
            backgroundColor: widget.bottomBackgroundColor ??
                Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(12), right: Radius.circular(12)),
          ),
          content: PanelContent(
            // 弹框局部
            panelContent: widget.sheetWidget,
            // 弹框头部布局，弹框内容滚动时，header悬浮
            headerWidget:
                PanelHeaderWidget(headerContent: widget.headerWidget ?? null),
            // // 弹框底部布局，效果同headerWidget
            footerWidget: PanelFooterWidget(
                footerContent: widget.footerWidget ?? null,
                decoration: PanelDecoration(boxShadows: const <BoxShadow>[
                  // BoxShadow(
                  //   blurRadius: 0.0,
                  //   color: Color.fromRGBO(0, 0, 0, 0),
                  // ),
                ])),
            // 主体布局
            bodyContent: widget.bodyWidget,
          ),
          isTwoStatePanel: true,
          // 滑动跟随模式
          snapping: PanelSnapping.forced,
          panelClosedOptions: PanelClosedOptions(
              throwResult: widget.closeArguments,
              detachDragging: true,
              resetScrolling: true),
          size: PanelSize(
              closedHeight: 0.0,
              collapsedHeight: 0,
              expandedHeight: widget.expandedMaxHeight),
          autoSizing: PanelAutoSizing(
              autoSizeExpanded: true,
              useMinExpanded: true,
              headerSizeIsClosed: true),
          duration: Duration(milliseconds: 300),
          dragMultiplier: 2.0,
          onPanelStateChanged: (PanelState state) {
            this.state = state;
            if (state == PanelState.expanded) {
              opacity = 0.5;
              if (widget.closedCallback != null) {
                widget.expandedCallback();
              }
            }
          },
          onThrowResult:
              widget.closedCallback != null ? widget.closedCallback : null,
          onPanelSlide: (x) {
            opacity = x;
            setState(() {});
            print('onPanelSlide $x');
            _animationController.value = _panelController.percentPosition(
                _panelController.sizeData.closedHeight,
                _panelController.sizeData.expandedHeight);
          },
          safeAreaConfig: SafeAreaConfig(),
        ),
      ),
    );
  }
}
