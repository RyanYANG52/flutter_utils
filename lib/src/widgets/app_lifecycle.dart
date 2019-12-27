import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLifecycle extends StatefulWidget {
  final VoidCallback onInit;
  final FutureOr<void> Function() onClose;
  final VoidCallback onBecameForeground;
  final VoidCallback onBecameBackground;
  final Widget app;
  final Duration keepAliveDurationInBackground;

  const AppLifecycle({
    Key key,
    @required this.app,
    this.onInit,
    this.onClose,
    this.onBecameBackground,
    this.onBecameForeground,
    this.keepAliveDurationInBackground,
  }) : super(key: key);

  @override
  _AppLifecycleState createState() => _AppLifecycleState();
}

class _AppLifecycleState extends State<AppLifecycle>
    with WidgetsBindingObserver {
  Timer _closeTimer;
  bool _isBackground = false;
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) &&
        !_isBackground) {
      _isBackground = true;
      if (widget.onBecameBackground != null) {
        widget.onBecameBackground();
      }
      if (widget.keepAliveDurationInBackground != null) {
        _closeTimer = Timer(widget.keepAliveDurationInBackground, () async {
          await _closeApp();
          SystemNavigator.pop();
        });
      }
    } else if ((state == AppLifecycleState.resumed ||
            state == AppLifecycleState.inactive) &&
        _isBackground) {
      _isBackground = false;
      _closeTimer?.cancel();
      if (widget.onBecameForeground != null) {
        widget.onBecameForeground();
      }
    }
  }

  @override
  void dispose() async{
    await _closeApp();
    super.dispose();
  }

  Future _closeApp() async{
    if (!_isClosed) {
      _closeTimer?.cancel();
      WidgetsBinding.instance.removeObserver(this);
      if (widget.onClose != null) {
        final result = widget.onClose();
        if(result is Future){
          await result;
        }        
      }
      _isClosed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.app;
  }
}
