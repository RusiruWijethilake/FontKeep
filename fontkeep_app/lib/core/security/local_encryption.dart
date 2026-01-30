import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';

class LocalEncryption {
  static Key? _key;
  static final _iv = IV.fromLength(16);
  static Encrypter? _encrypter;

  static Future<void> init() async {
    if (_key != null) return;

    String deviceId = 'FontKeep_Fallback_Key_2026';

    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        deviceId = macInfo.systemGUID ?? macInfo.model;
      } else if (Platform.isWindows) {
        final winInfo = await deviceInfo.windowsInfo;
        deviceId = winInfo.deviceId;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        deviceId = linuxInfo.machineId ?? 'linux_machine_id';
      }
    } catch (e) {
      print('Warning: Failed to get device ID for encryption: $e');
    }

    final keyBytes = sha256.convert(utf8.encode(deviceId)).bytes;
    _key = Key.fromBase16(
      keyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
    );

    _encrypter = Encrypter(AES(_key!));
  }

  static String encrypt(String plainText) {
    if (_encrypter == null) {
      throw Exception(
        "LocalEncryption not initialized! Call LocalEncryption.init() first.",
      );
    }
    if (plainText.isEmpty) return '';
    return _encrypter!.encrypt(plainText, iv: _iv).base64;
  }

  static String decrypt(String encryptedBase64) {
    if (_encrypter == null) {
      throw Exception(
        "LocalEncryption not initialized! Call LocalEncryption.init() first.",
      );
    }
    if (encryptedBase64.isEmpty) return '';
    try {
      return _encrypter!.decrypt64(encryptedBase64, iv: _iv);
    } catch (e) {
      return '';
    }
  }
}
