import 'package:flutter/services.dart';

class Display {
  factory Display() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('plugins.ryanyang52.flutterutils/display');
      _instance = Display._(methodChannel);
    }
    return _instance;
  }
  Display._(this._methodChannel);

  static Display _instance;
  final MethodChannel _methodChannel;

  Future<DisplayMetrics> get metrics async {
    var result = await _methodChannel.invokeMethod('getDisplayMetrics');
    if (result != null) {
      var xdpi = result['xdpi'];
      var ydpi = result['ydpi'];
      var screenWidth = result['width'];
      var screenHeight = result['height'];
      return DisplayMetrics._(xdpi, ydpi, screenWidth, screenHeight);
    }
    return null;
  }
}

class DisplayMetrics {
  DisplayMetrics._(
    this.xdpi,
    this.ydpi,
    this.screenWidth,
    this.screenHeight,
  )   : screenWidthInCm = screenWidth * 2.54 / xdpi,
        screenHeightInCm = screenHeight * 2.54 / ydpi;

  final double xdpi;
  final double ydpi;
  final double screenWidthInCm;
  final double screenHeightInCm;
  final int screenHeight;
  final int screenWidth;
}
