import 'dart:math' as math;

extension NumUtil on double {
  double roundAsFixed({int fractionDigits = 2}) {
    var mod = math.pow(10, fractionDigits);
    return (this * mod).roundToDouble() / mod;
  }
}
