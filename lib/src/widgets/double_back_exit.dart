import 'dart:async';
import 'package:flutter/widgets.dart';

class DoubleBackExit extends StatefulWidget {
  final Widget child;
  final VoidCallback backOnceCallback;
  final FutureOr<void> Function() exitCallback;
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
      onWillPop: () async {
        if (_isBackOnce) {
          if (widget.exitCallback != null) {
            final result = widget.exitCallback();
            if (result is Future) {
              await result;
            }
          }
          return true;
        }
        _isBackOnce = true;
        Future<dynamic>.delayed(widget.interval).then((dynamic _) {
          _isBackOnce = false;
        });
        if (widget.backOnceCallback != null) {
          widget.backOnceCallback();
        }
        return false;
      },
      child: widget.child,
    );
  }
}
