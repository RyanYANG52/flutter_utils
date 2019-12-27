import 'package:flutter_utils/dart_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BitConverter test', () {
    List<int> list = [0xAF, 0xC6, 0x53, 0x01, 0x55, 0x66, 0x77, 0x88];

    var int16BigEndian = list.readInt16(0, true);
    expect(int16BigEndian, -20538);

    var int16LittleEndian = list.readInt16(2, false);
    expect(int16LittleEndian, 339);

    var int32 = list.readInt32(0);
    expect(int32, -1345957119);

    var uint24 = list.readUint(0, 3);
    expect(uint24, 11519571);

    var int64 = list.readInt64(0);
    expect(int64, -5780841806490601592);
  });

  // test('Trail test', () async {
  //   const expectedOutput = [
  //     [1],
  //     [1, 2],
  //     [1, 2, 3],
  //     [2, 3, 4],
  //     [3, 4, 5],
  //     [4, 5, 6],
  //   ];
  //   var count = 0;
  //   Stream.fromIterable(<int>[1, 2, 3, 4, 5, 6])
  //       .transform(trail(3))
  //       .listen(expectAsync1(
  //     (result) {
  //       expect(expectedOutput[count], result);
  //       count++;
  //     },
  //     count: 6
  //   ));

  //   // code should reach here
  //   await expectLater(true, true);
  // });

  test('TimeFormatter test', () {
    DateTime dateTime = DateTime.utc(2000, 10, 10, 3, 59, 9, 90);
    expect(dateTime.format(), '03:59:09');
    expect(dateTime.format(showMilliSeconds: true), '03:59:09.090');

    Duration duration =
        Duration(hours: 3, minutes: 59, seconds: 9, milliseconds: 90);
    expect(duration.format(), '03:59:09');
    expect(duration.format(showMilliSeconds: true), '03:59:09.090');
  });
}
