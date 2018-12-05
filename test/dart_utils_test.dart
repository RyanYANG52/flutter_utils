import 'dart:async';

import 'package:flutter_utils/dart_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BitConverter test', () {
    List<int> list = [0xAF, 0xC6, 0x53, 0x01, 0x55, 0x66, 0x77, 0x88];

    var int16BigEndian = BitConverter.readInt16(list, 0, true);
    expect(int16BigEndian, -20538);

    var int16LittleEndian = BitConverter.readInt16(list, 2, false);
    expect(int16LittleEndian, 339);

    var int32 = BitConverter.readInt32(list, 0);
    expect(int32, -1345957119);

    var uint24 = BitConverter.readUint(list, 0, 3);
    expect(uint24, 11519571);

    var int64 = BitConverter.readInt64(list, 0);
    expect(int64, -5780841806490601592);
  });

  test('Trail test', () async {
    int counter = 0;
    int trailCount = 3;
    bool isDone = false;
    StreamController<int> input = StreamController<int>();
    var trailStream = input.stream.transform(trail(trailCount));
    trailStream.listen((values) {
      if (counter > trailCount) {
        expect(values.length, trailCount);
        expect(values[0], counter - trailCount + 1);
      } else {
        expect(values.length, counter);
        expect(values[0], 1);
      }
      expect(values[values.length - 1], counter);
    }).onDone(() {
      isDone = true;
    });
    for (var i = 0; i < 10; i++) {
      counter++;
      input.add(counter);
      await Future(() {});
    }
    await input.close();
    expect(isDone, true);
  });

  test('TimeFormatter test', () {
    DateTime dateTime = DateTime.utc(2000, 10, 10, 3, 59, 9, 90);
    expect(TimeFormatter.formatDateTime(dateTime), '03:59:09');
    expect(TimeFormatter.formatDateTime(dateTime, true), '03:59:09.090');

    Duration duration =
        Duration(hours: 3, minutes: 59, seconds: 9, milliseconds: 90);
    expect(TimeFormatter.formatDuration(duration), '03:59:09');
    expect(TimeFormatter.formatDuration(duration, true), '03:59:09.090');
  });
}
