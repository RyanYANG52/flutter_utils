const int maxUnsignedInt16 = 0xFFFF;
const int maxSignedInt16 = 0x7FFF;

const int maxUnsignedInt32 = 0xFFFFFFFF;
const int maxSignedInt32 = 0x7FFFFFFF;

const int maxUnsignedInt64 = 0xFFFFFFFFFFFFFFFF;
const int maxSignedInt64 = 0x7FFFFFFFFFFFFFFF;

extension BytesConverter on List<int> {
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
    return value.toSigned(16);
  }

  int readInt32(int startIndex, [bool isBigEndian = true]) {
    int value = this.readUint(startIndex, 4, isBigEndian);
    return value.toSigned(32);
  }

  int readInt64(int startIndex, [bool isBigEndian = true]) {
    int value = this.readUint(startIndex, 8, isBigEndian);
    return value.toSigned(64);
  }
}