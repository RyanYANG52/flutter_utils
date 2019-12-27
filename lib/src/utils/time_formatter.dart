extension NumberFormatter on num {
  String get twoDigits {
    int n = this ?? 0;
    if (n >= 10) return "$n";
    return "0$n";
  }

  String get threeDigits {
    int n = this ?? 0;
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  String get fourDigits {
    int n = this ?? 0;
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  String get sixDigits {
    int n = this ?? 0;
    assert(n < -9999 || n > 9999);
    int absN = n.abs();
    String sign = n < 0 ? "-" : "+";
    if (absN >= 100000) return "$sign$absN";
    return "${sign}0$absN";
  }
}

extension DurationFormatter on Duration {
  String format({bool showMilliSeconds = false}) {
    Duration duration = this ?? Duration.zero;
    StringBuffer buffer = StringBuffer();
    buffer
      ..write(duration.inHours.twoDigits)
      ..write(':')
      ..write(duration.inMinutes.remainder(Duration.minutesPerHour).twoDigits)
      ..write(':')
      ..write(
          duration.inSeconds.remainder(Duration.secondsPerMinute).twoDigits);

    if (showMilliSeconds) {
      buffer
        ..write('.')
        ..write(duration.inMilliseconds
            .remainder(Duration.millisecondsPerSecond)
            .threeDigits);
    }
    return buffer.toString();
  }
}

extension DateTimeFormatter on DateTime {
  String format({bool showMilliSeconds = false}) {
    DateTime dateTime = this ?? DateTime(0);
    StringBuffer buffer = StringBuffer();
    buffer
      ..write(dateTime.hour.twoDigits)
      ..write(':')
      ..write(dateTime.minute.twoDigits)
      ..write(':')
      ..write(dateTime.second.twoDigits);

    if (showMilliSeconds) {
      buffer..write('.')..write(dateTime.millisecond.threeDigits);
    }
    return buffer.toString();
  }
}
