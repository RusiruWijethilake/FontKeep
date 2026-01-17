import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

final updateRepositoryProvider = Provider<UpdateRepository>((ref) {
  return UpdateRepository();
});

class UpdateRepository {
  final String _owner = "RusiruWijethilake";
  final String _repo = "FontKeep";

  Future<UpdateInfo?> checkForUpdate(LoggerService logger) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final url = Uri.parse(
        "https://api.github.com/repos/$_owner/$_repo/releases/latest",
      );
      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body);
      final String tagName = json['tag_name'];
      final String downloadUrl = json['html_url'];
      final String body = json['body'] ?? "New features available.";
      final cleanTag = tagName.replaceAll('v', '');

      if (_isNewer(cleanTag, currentVersion)) {
        return UpdateInfo(
          latestVersion: cleanTag,
          currentVersion: currentVersion,
          releaseNotes: body,
          downloadUrl: downloadUrl,
        );
      }
      return null;
    } catch (e) {
      logger.error(e);
      return null;
    }
  }

  bool _isNewer(String latest, String current) {
    List<int> l = latest.split('.').map(int.parse).toList();
    List<int> c = current.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      int lVal = i < l.length ? l[i] : 0;
      int cVal = i < c.length ? c[i] : 0;
      if (lVal > cVal) return true;
      if (lVal < cVal) return false;
    }
    return false;
  }
}

class UpdateInfo {
  final String latestVersion;
  final String currentVersion;
  final String releaseNotes;
  final String downloadUrl;

  UpdateInfo({
    required this.latestVersion,
    required this.currentVersion,
    required this.releaseNotes,
    required this.downloadUrl,
  });
}
