import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class AuthRepository {
  final FlutterSecureStorage _storage;

  static const _keyClientId = 'custom_client_id';
  static const _keyClientSecret = 'custom_client_secret';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyExpiry = 'token_expiry';

  static const List<String> _scopes = [drive.DriveApi.driveFileScope];

  AuthRepository(this._storage);

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _keyAccessToken);
    return token != null;
  }

  Future<void> saveCustomCredentials(String id, String secret) async {
    await _storage.write(key: _keyClientId, value: id);
    await _storage.write(key: _keyClientSecret, value: secret);
  }

  Future<ClientId?> getClientId() async {
    final id = await _storage.read(key: _keyClientId);
    final secret = await _storage.read(key: _keyClientSecret);

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

    final accessToken = await _storage.read(key: _keyAccessToken);
    final refreshToken = await _storage.read(key: _keyRefreshToken);
    final expiryStr = await _storage.read(key: _keyExpiry);

    if (accessToken == null) return null;

    final expiry = expiryStr != null ? DateTime.parse(expiryStr) : DateTime.now();

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
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyExpiry);
  }

  Future<void> _saveCredentials(AccessCredentials credentials) async {
    await _storage.write(key: _keyAccessToken, value: credentials.accessToken.data);
    if (credentials.refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: credentials.refreshToken);
    }
    await _storage.write(key: _keyExpiry, value: credentials.accessToken.expiry.toIso8601String());
  }
}