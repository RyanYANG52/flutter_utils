class BitConverter {
  static const int maxUnsignedInt16 = 0xFFFF;
  static const int maxSignedInt16 = 0x7FFF;

  static const int maxUnsignedInt32 = 0xFFFFFFFF;
  static const int maxSignedInt32 = 0x7FFFFFFF;

  static const int maxUnsignedInt64 = 0xFFFFFFFFFFFFFFFF;
  static const int maxSignedInt64 = 0x7FFFFFFFFFFFFFFF;

  static int readUint(List<int> list, int startIndex,
      [int byteLength = 4, bool isBigEndian = true]) {
    int value;
    if (isBigEndian) {
      value = list[startIndex + byteLength - 1];
      for (var i = 1; i < byteLength; i++) {
        value |= (list[startIndex + byteLength - 1 - i] << (8 * i));
      }
    } else {
      value = list[startIndex];
      for (var i = 1; i < byteLength; i++) {
        value |= (list[startIndex + i] << (8 * i));
      }
    }
    return value;
  }

  static int readInt16(List<int> list, int startIndex,
      [bool isBigEndian = true]) {
    int value = readUint(list, startIndex, 2, isBigEndian);
    if (value > maxSignedInt16) {
      value = value - maxUnsignedInt16 - 1;
    }
    return value;
  }

  static int readInt32(List<int> list, int startIndex,
      [bool isBigEndian = true]) {
    int value = readUint(list, startIndex, 4, isBigEndian);
    if (value > maxSignedInt32) {
      value = value - maxUnsignedInt32 - 1;
    }
    return value;
  }

  static int readInt64(List<int> list, int startIndex,
      [bool isBigEndian = true]) {
    int value = readUint(list, startIndex, 8, isBigEndian);
    if (value > maxSignedInt64) {
      value = value - maxUnsignedInt64 - 1;
    }
    return value;
  }
}
