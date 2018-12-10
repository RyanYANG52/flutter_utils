import 'package:flutter/widgets.dart';

enum ShineMode { lighten, darken, opacityOver }

class ShinyLogo extends StatefulWidget {
  const ShinyLogo({
    Key key,
    @required this.child,
    @required this.shineColor,
    this.repeatDuration = const Duration(milliseconds: 1200),
    this.shineDurationPercent = 0.5,
    this.shininess = 0.5,
    this.bandSizePercent = 0.3,
    this.mode = ShineMode.lighten,
  })  : assert(child != null),
        assert(shineColor != null),
        assert(shininess >= 0 && shininess <= 1),
        assert(shineDurationPercent >= 0 && shineDurationPercent <= 1),
        assert(bandSizePercent >= 0 && bandSizePercent <= 1),
        super(key: key);

  final Widget child;

  /// The shine color of the ShinyLogo,  must be parent widget's backgroundColor
  /// when [mode] is [ShineMode.opacityOver]
  final Color shineColor;

  /// when [shineColor] is lighter than parent widget's background color, 
  /// use [ShineMode.lighten]
  /// when [shineColor] is darker than parent widget's background color, 
  /// use [ShineMode.darken]
  /// when use [ShineMode.opacityOver], [shineColor] must be parent widget's
  /// backgroundColor to work
  final ShineMode mode;
  final double shininess;
  final Duration repeatDuration;
  final double shineDurationPercent;
  final double bandSizePercent;

  @override
  _ShinyLogoState createState() => _ShinyLogoState();
}

class _ShinyLogoState extends State<ShinyLogo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animatable<double> _stopTween;
  Color _edgeColor;
  Color _midColor;

  void _initValues() {
    if (widget.mode == ShineMode.opacityOver) {
      _edgeColor = widget.shineColor.withOpacity(widget.shininess);
      _midColor = widget.shineColor.withOpacity(0.0);
    } else {
      _edgeColor = widget.shineColor.withOpacity(0.0);
      _midColor = widget.shineColor.withOpacity(widget.shininess);
    }

    double edgeStop = (1.0 - widget.shineDurationPercent) / 2;
    _stopTween = CurveTween(curve: Interval(edgeStop, 1.0 - edgeStop));
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

  BlendMode _getBlendMode(ShineMode mode) {
    switch (mode) {
      case ShineMode.opacityOver:
        return BlendMode.srcOver;
      case ShineMode.darken:
        return BlendMode.darken;
      default:
        return BlendMode.lighten;
    }
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    double scale = 1.0 + widget.bandSizePercent * 2.0;
    double value =
        _stopTween.evaluate(_controller) * scale - widget.bandSizePercent;

    return DecoratedBox(
        decoration: BoxDecoration(
            backgroundBlendMode: _getBlendMode(widget.mode),
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
                  _edgeColor,
                  _midColor,
                  _edgeColor
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
