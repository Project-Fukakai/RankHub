import 'dart:typed_data';
import 'dart:convert';

// struct.unpack("if") = little endian int32 + float32
final int32 = ByteData(4);
final float32 = ByteData(4);

bool getBool(int num, int index) => (num & (1 << index)) != 0;

class ByteReader {
  final Uint8List data;
  int position = 0;
  int bitPosition = 0;

  ByteReader(this.data);

  // ========================
  // 位读取：read_bool()
  // ========================
  bool readBool() {
    if (bitPosition == 8) {
      bitPosition = 0;
      position++;
    }
    bool result = (data[position] & (1 << bitPosition)) != 0;
    bitPosition++;
    return result;
  }

  void alignToByte() {
    if (bitPosition != 0) {
      position++;
      bitPosition = 0;
    }
  }

  // ========================
  // 字节读取
  // ========================
  int readByte() {
    alignToByte();
    return data[position++];
  }

  int readShort() {
    alignToByte();
    int result = data[position] | (data[position + 1] << 8);
    position += 2;
    return result;
  }

  int readVarShort() {
    alignToByte();
    int num = data[position];
    if (num < 128) {
      position++;
      return num;
    }
    int result = (num & 0x7F) | (data[position + 1] << 7);
    position += 2;
    return result;
  }

  // ========================
  // read_string
  // ========================
  String readString() {
    int length = readVarShort();
    if (length == 0) return '';
    final bytes = data.sublist(position, position + length);
    position += length;
    return utf8.decode(bytes, allowMalformed: true);
  }

  // ========================
  // struct.unpack("if") 等价
  // ========================
  Map<String, dynamic> readScoreAcc() {
    alignToByte();
    position += 8;

    // Python: unpack("if", bytes[position-8 : position])
    final slice = data.sublist(position - 8, position);

    // int32（little endian）
    int32.buffer.asUint8List().setAll(0, slice.sublist(0, 4));
    int score = int32.getInt32(0, Endian.little);

    // float32（little endian）
    float32.buffer.asUint8List().setAll(0, slice.sublist(4, 8));
    double acc = float32.getFloat32(0, Endian.little);

    return {"score": score, "acc": acc};
  }

  // ========================
  // 完整移植：read_record
  // ========================
  List<Map<String, dynamic>>? readRecord(
    String songId,
    Map<String, List<double>> chartConstantList,
    Map<String, dynamic> songInfoList,
  ) {
    // Python: end_position = pos + data[pos] + 1
    final endPosition = position + data[position] + 1;

    position++;
    int exists = data[position];

    position++;
    int fc = data[position];

    position++;

    if (chartConstantList.containsKey(songId)) {
      final constants = chartConstantList[songId]!;
      final List<Map<String, dynamic>> records = [];

      for (int level = 0; level < constants.length; level++) {
        if (getBool(exists, level)) {
          final scoreAcc = readScoreAcc();
          final double acc = scoreAcc["acc"];

          // 如果准确率低于70%，RKS为0
          final double rks;
          if (acc < 70.0) {
            rks = 0.0;
          } else {
            final double preRks = (acc - 55) / 45;
            rks = preRks * preRks * constants[level];
          }

          records.add({
            "id": songId,
            "name": songInfoList[songId]["name"],
            "artist": songInfoList[songId]["artist"],
            "level": ["EZ", "HD", "IN", "AT", "Legacy"][level],
            "constant": constants[level],
            "score": scoreAcc["score"],
            "acc": acc,
            "rks": rks,
            "fc": getBool(fc, level),
          });
        }
      }

      position = endPosition;
      return records;
    }

    position = endPosition;
    return null;
  }

  // ========================
  // 完整移植 read_progress
  // ========================
  Map<String, dynamic> readProgress() {
    return {
      "is_first_run": readBool(),
      "legacy_chapter_finished": readBool(),
      "already_show_collection_tip": readBool(),
      "already_show_auto_unlock_in_tip": readBool(),
      "completed": readString(),
      "song_update_info": readByte(),
      "challenge_mode_rank": readShort(),
      "money": List.generate(5, (_) => readVarShort()),
      "unlock_flag_of_spasmodic": readByte(),
      "unlock_flag_of_igallta": readByte(),
      "unlock_flag_of_rrharil": readByte(),
      "flag_of_song_record_key": readByte(),
      "random_version_unlocked": readByte(),
      "chapter8_unlock_begin": readBool(),
      "chapter8_unlock_second_phase": readBool(),
      "chapter8_passed": readBool(),
      "chapter8_song_unlocked": readByte(),
    };
  }
}
