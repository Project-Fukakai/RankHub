import 'package:pointycastle/export.dart';
import 'dart:typed_data';

Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List ciphertext) {
  final cipher = CBCBlockCipher(AESEngine())
    ..init(false, ParametersWithIV(KeyParameter(key), iv));

  final output = Uint8List(ciphertext.length);
  var offset = 0;

  while (offset < ciphertext.length) {
    cipher.processBlock(ciphertext, offset, output, offset);
    offset += cipher.blockSize;
  }

  return _pkcs7Unpad(output);
}

// PKCS7 unpad
Uint8List _pkcs7Unpad(Uint8List data) {
  int padLen = data.last;
  return data.sublist(0, data.length - padLen);
}
