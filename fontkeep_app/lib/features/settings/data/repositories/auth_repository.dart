import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fontkeep_app/core/security/local_encryption.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthRepository {
  final FlutterSecureStorage _storage;
  final AppDatabase _db;

  static const _keyClientId = 'custom_client_id';
  static const _keyClientSecret = 'custom_client_secret';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyExpiry = 'token_expiry';

  static const List<String> _scopes = [drive.DriveApi.driveFileScope];

  AuthRepository(this._storage, this._db);

  Future<void> _write(String key, String value) async {
    if (Platform.isMacOS) {
      final encrypted = LocalEncryption.encrypt(value);
      await _db
          .into(_db.secureSettings)
          .insertOnConflictUpdate(
            SecureSettingsCompanion.insert(key: key, value: encrypted),
          );
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  Future<String?> _read(String key) async {
    if (Platform.isMacOS) {
      final record = await (_db.select(
        _db.secureSettings,
      )..where((t) => t.key.equals(key))).getSingleOrNull();

      if (record == null) return null;
      return LocalEncryption.decrypt(record.value);
    } else {
      return await _storage.read(key: key);
    }
  }

  Future<void> _delete(String key) async {
    if (Platform.isMacOS) {
      await (_db.delete(
        _db.secureSettings,
      )..where((t) => t.key.equals(key))).go();
    } else {
      await _storage.delete(key: key);
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _read(_keyAccessToken);
    return token != null;
  }

  Future<void> saveCustomCredentials(String id, String secret) async {
    await _write(_keyClientId, id);
    await _write(_keyClientSecret, secret);
  }

  Future<ClientId?> getClientId() async {
    final id = await _read(_keyClientId);
    final secret = await _read(_keyClientSecret);

    if (id != null && id.isNotEmpty) {
      return ClientId(id, secret);
    }
    return null;
  }

  Future<AuthClient> signIn() async {
    final clientId = await getClientId();
    if (clientId == null) {
      throw Exception("No Client ID configured. Please set one in Settings.");
    }

    final client = await clientViaUserConsent(clientId, _scopes, (url) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    });

    await _saveCredentials(client.credentials);

    return client;
  }

  Future<AuthClient?> getAuthenticatedClient() async {
    final clientId = await getClientId();
    if (clientId == null) return null;

    final accessToken = await _read(_keyAccessToken);
    final refreshToken = await _read(_keyRefreshToken);
    final expiryStr = await _read(_keyExpiry);

    if (accessToken == null) return null;

    final expiry = expiryStr != null
        ? DateTime.parse(expiryStr)
        : DateTime.now();

    final credentials = AccessCredentials(
      AccessToken('Bearer', accessToken, expiry),
      refreshToken,
      _scopes,
    );

    final client = autoRefreshingClient(clientId, credentials, http.Client());

    client.credentialUpdates.listen((newCreds) {
      _saveCredentials(newCreds);
    });

    return client;
  }

  Future<void> signOut() async {
    await _delete(_keyAccessToken);
    await _delete(_keyRefreshToken);
    await _delete(_keyExpiry);
  }

  Future<void> _saveCredentials(AccessCredentials credentials) async {
    await _write(_keyAccessToken, credentials.accessToken.data);
    if (credentials.refreshToken != null) {
      await _write(_keyRefreshToken, credentials.refreshToken!);
    }
    await _write(_keyExpiry, credentials.accessToken.expiry.toIso8601String());
  }
}
