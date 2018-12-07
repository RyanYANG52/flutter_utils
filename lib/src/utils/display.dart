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
      return DisplayMetrics._(
        density: result['density'],
        densityDpi: result['densityDpi'],
        width: result['width'],
        height: result['height'],
        scaledDensity: result['scaledDensity'],
        xdpi: result['xdpi'],
        ydpi: result['ydpi'],
      );
    }
    return null;
  }
}

class DisplayMetrics {
  DisplayMetrics._({
    this.densityDpi,
    this.scaledDensity,
    this.density,
    this.xdpi,
    this.ydpi,
    this.width,
    this.height,
  })  : widthInCm = width * 2.54 / xdpi,
        heightInCm = height * 2.54 / ydpi;

  /// The exact physical pixels per inch of the screen in the X dimension.
  final double xdpi;

  /// The exact physical pixels per inch of the screen in the Y dimension.
  final double ydpi;

  /// The absolute width of the available display size in pixels.
  final int width;

  /// The absolute height of the available display size in pixels.
  final int height;

  /// The absolute width of the available display size in centmeters.
  final double widthInCm;

  /// The absolute height of the available display size in centmeters.
  final double heightInCm;

  /// The screen density expressed as dots-per-inch.
  final int densityDpi;

  /// A scaling factor for fonts displayed on the display. This is the same as
  /// [density], except that it may be adjusted in smaller increments at runtime
  /// based on a user preference for the font size.
  final double scaledDensity;

  /// The logical density of the display. This is a scaling factor for the
  /// Density Independent Pixel unit, where one DIP is one pixel on an
  /// approximately 160 dpi screen (for example a 240x320, 1.5"x2" screen),
  /// providing the baseline of the system's display. Thus on a 160dpi screen
  /// this density value will be 1; on a 120 dpi screen it would be .75; etc.
  ///
  /// This value does not exactly follow the real screen size
  /// (as given by xdpi and ydpi, but rather is used to scale the size of the
  /// overall UI in steps based on gross changes in the display dpi.
  /// For example, a 240x320 screen will have a density of 1 even if its width
  /// is 1.8", 1.3", etc. However, if the screen resolution is increased to
  /// 320x480 but the screen size remained 1.5"x2" then the density would be
  /// increased (probably to 1.5).
  final double density;
}
