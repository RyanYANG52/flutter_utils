import 'dart:math' as math;

// class NumUtil{
//   static double roundAsFixed(double value, int fractionDigits){
//       var mod = math.pow(10, fractionDigits);
//       return (value * mod).roundToDouble() / mod;
//   }
// }

extension NumUtil on double {
  double roundAsFixed({int fractionDigits = 2}) {
    var mod = math.pow(10, fractionDigits);
    return (this * mod).roundToDouble() / mod;
  }
}
