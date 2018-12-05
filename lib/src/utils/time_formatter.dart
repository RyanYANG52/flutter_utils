class TimeFormatter {
  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String sixDigits(int n) {
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? "-" : "+";
    if (absN >= 100000) return "$sign$absN";
    return "${sign}0$absN";
  }

  static String formatDuration(Duration duration,
      [bool showMilliSeconds = false]) {
    StringBuffer buffer = StringBuffer();
    buffer
      ..write(twoDigits(duration.inHours))
      ..write(':')
      ..write(twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour)))
      ..write(':')
      ..write(
          twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute)));

    if (showMilliSeconds) {
      buffer
        ..write('.')
        ..write(threeDigits(
            duration.inMilliseconds.remainder(Duration.millisecondsPerSecond)));
    }
    return buffer.toString();
  }

  static String formatDateTime(DateTime dateTime,
      [bool showMilliSeconds = false]) {
    StringBuffer buffer = StringBuffer();
    buffer
      ..write(twoDigits(dateTime.hour))
      ..write(':')
      ..write(twoDigits(dateTime.minute))
      ..write(':')
      ..write(twoDigits(dateTime.second));

    if (showMilliSeconds) {
      buffer..write('.')..write(threeDigits(dateTime.millisecond));
    }
    return buffer.toString();
  }
}
