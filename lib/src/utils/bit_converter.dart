const int maxUnsignedInt16 = 0xFFFF;
const int maxSignedInt16 = 0x7FFF;

const int maxUnsignedInt32 = 0xFFFFFFFF;
const int maxSignedInt32 = 0x7FFFFFFF;

const int maxUnsignedInt64 = 0xFFFFFFFFFFFFFFFF;
const int maxSignedInt64 = 0x7FFFFFFFFFFFFFFF;

extension BitConverter on List<int> {
  int readUint(int startIndex, [int byteLength = 4, bool isBigEndian = true]) {
    int value;
    if (isBigEndian) {
      value = this[startIndex + byteLength - 1];
      for (var i = 1; i < byteLength; i++) {
        value |= (this[startIndex + byteLength - 1 - i] << (8 * i));
      }
    } else {
      value = this[startIndex];
      for (var i = 1; i < byteLength; i++) {
        value |= (this[startIndex + i] << (8 * i));
      }
    }
    return value;
  }

  int readUint16(int startIndex, [bool isBigEndian = true]) {
    int value = this.readUint(startIndex, 2, isBigEndian);
    return value;
  }

  int readInt16(int startIndex, [bool isBigEndian = true]) {
    int value = this.readUint(startIndex, 2, isBigEndian);
    if (value > maxSignedInt16) {
      value = value - maxUnsignedInt16 - 1;
    }
    return value;
  }

  int readInt32(int startIndex, [bool isBigEndian = true]) {
    int value = this.readUint(startIndex, 4, isBigEndian);
    if (value > maxSignedInt32) {
      value = value - maxUnsignedInt32 - 1;
    }
    return value;
  }

  int readInt64(int startIndex, [bool isBigEndian = true]) {
    int value = this.readUint(startIndex, 8, isBigEndian);
    if (value > maxSignedInt64) {
      value = value - maxUnsignedInt64 - 1;
    }
    return value;
  }
}