import 'package:flutter/widgets.dart';

class ShinyLogo extends StatefulWidget {
  const ShinyLogo({
    Key key,
    @required this.child,
    @required this.parentBackground,
    this.repeatDuration = const Duration(milliseconds: 1200),
    this.shineDurationPercent = 0.5,
    this.opacityOffset = 0.5,
    this.bandSizePercent = 0.3,
    this.reversed = false,
  })  : assert(child != null),
        assert(opacityOffset > 0 && opacityOffset <= 1),
        assert(shineDurationPercent > 0 && shineDurationPercent < 1),
        assert(bandSizePercent > 0 && bandSizePercent < 1),
        super(key: key);

  final Widget child;
  final Color parentBackground;
  final double opacityOffset;
  final Duration repeatDuration;
  final double shineDurationPercent;
  final double bandSizePercent;
  final bool reversed;

  @override
  _ShinyLogoState createState() => _ShinyLogoState();
}

class _ShinyLogoState extends State<ShinyLogo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animatable<double> _stopTween;
  Color _beginColor;
  Color _endColor;

  void _initValues() {
    if (widget.reversed) {
      _beginColor = widget.parentBackground.withOpacity(widget.opacityOffset);
      _endColor = widget.parentBackground.withOpacity(0.0);
    } else {
      _beginColor = widget.parentBackground.withOpacity(0.0);
      _endColor = widget.parentBackground.withOpacity(widget.opacityOffset);
    }

    double beginStop = (1.0 - widget.shineDurationPercent) / 2;
    _stopTween = CurveTween(curve: Interval(beginStop, 1.0 - beginStop));
  }

  @override
  void initState() {
    super.initState();
    _initValues();
    _controller = AnimationController(
      duration: widget.repeatDuration,
      vsync: this,
    );

    _controller.repeat();
  }

  @override
  void didUpdateWidget(ShinyLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initValues();

    if (widget.repeatDuration != oldWidget.repeatDuration) {
      _controller.stop();
      _controller.duration = widget.repeatDuration;
    }
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    double scale = 1.0 + widget.bandSizePercent * 2.0;
    double value =
        _stopTween.evaluate(_controller) * scale - widget.bandSizePercent;
    return DecoratedBox(
        decoration: BoxDecoration(
            backgroundBlendMode:
                widget.reversed ? BlendMode.srcOver : BlendMode.lighten,
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp,
                stops: [
                  value - widget.bandSizePercent,
                  value,
                  value + widget.bandSizePercent
                ],
                colors: [
                  _beginColor,
                  _endColor,
                  _beginColor
                ])),
        position: DecorationPosition.foreground,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildAnimation,
      child: widget.child,
    );
  }
}
