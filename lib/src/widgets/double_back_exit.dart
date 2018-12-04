import 'package:flutter/widgets.dart';

class DoubleBackExit extends StatefulWidget {
  final Widget child;
  final VoidCallback backOnceCallback;
  final VoidCallback exitCallback;
  final Duration interval;

  const DoubleBackExit({
    Key key,
    @required this.child,
    this.backOnceCallback,
    this.exitCallback,
    this.interval = const Duration(seconds: 2),
  })  : assert(child != null),
        super(key: key);

  @override
  _DoubleBackExitState createState() => _DoubleBackExitState();
}

class _DoubleBackExitState extends State<DoubleBackExit> {
  bool _isBackOnce = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isBackOnce) {
          if (widget.exitCallback != null) {
            widget.exitCallback();
          }
          return Future.value(true);
        }
        _isBackOnce = true;
        Future.delayed(widget.interval).then((_) {
          _isBackOnce = false;
        });
        if (widget.backOnceCallback != null) {
          widget.backOnceCallback();
        }
        return Future.value(false);
      },
      child: widget.child,
    );
  }
}
