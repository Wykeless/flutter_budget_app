import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class PasswordManager {
  //*Generates a salt to be used when hashing the given email/password
  Uint8List generateSecureSalt(int length) {
    final random = Random.secure();
    final salt = List<int>.generate(length, (index) => random.nextInt(256));
    return Uint8List.fromList(salt);
  }

  //* Hashing the given email/password using the salt
  Uint8List hashValue(String value, Uint8List salt) {
    const codec = Utf8Codec();
    final key = codec.encode(value);
    final combinedData = Uint8List.fromList([...key, ...salt]);
    final hash = sha256.convert(combinedData);
    return Uint8List.fromList(hash.bytes);
  }

  //* checks whether the given password/email and the stored hash value is the same
  bool isValueMatching({
    required String givenHashValue,
    required String storedHashValue,
    required String hashSalt,
  }) {
    final convertedHashSalt = convertStringToUint8List(hashSalt: hashSalt);
    final computedHash = hashValue(givenHashValue, convertedHashSalt);
    return computedHash.toString() == storedHashValue.toString();
  }

  //* Converts string to Uint8List
  Uint8List convertStringToUint8List({required String hashSalt}) {
    //* Remove the square brackets and split the string by ', ' to get individual byte values as strings
    List<String> byteStrings =
        hashSalt.replaceAll('[', '').replaceAll(']', '').split(', ');

    //* Convert the byte strings to integers
    List<int> bytes = byteStrings.map((e) => int.parse(e)).toList();

    //* Create a Uint8List from the list of bytes
    Uint8List uint8List = Uint8List.fromList(bytes);

    return uint8List;
  }
}
