import 'package:flutter_utils/dart_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
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
}