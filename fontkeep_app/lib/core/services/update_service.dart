import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fontkeep_app/features/settings/domain/models/github_releases.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();

  factory UpdateService() => _instance;

  UpdateService._internal();

  final String _owner = "RusiruWijethilake";
  final String _repo = "FontKeep";

  final bool _isDownloading = false;

  Future<void> check(BuildContext context, {bool silent = false}) async {
    if (_isDownloading) return;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final localVersion = Version.parse(packageInfo.version);

      final response = await http.get(
        Uri.parse(
          'https://api.github.com/repos/$_owner/$_repo/releases?per_page=1',
        ),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final List<GitHubReleases> releases = gitHubReleasesFromJson(
          response.body,
        );

        if (releases.isEmpty) {
          if (context.mounted) {
            if (!silent) _showSnack(context, 'No releases found.');
          }
          return;
        }

        final GitHubReleases latestRelease = releases.first;
        String tagName = latestRelease.tagName;
        if (tagName.startsWith('v')) tagName = tagName.substring(1);

        Version remoteVersion;
        try {
          remoteVersion = Version.parse(tagName);
        } catch (e) {
          remoteVersion = Version.parse(tagName.split('+')[0].split('-')[0]);
        }

        if (remoteVersion > localVersion) {
          if (context.mounted) {
            _showUpdateDialog(
              context,
              tagName,
              latestRelease.body,
              latestRelease.assets,
            );
          }
        } else {
          if (!silent) {
            if (context.mounted) {
              _showSnack(context, 'You are on the latest version!');
            }
          }
        }
      } else {
        if (!silent) {
          if (context.mounted) {
            _showSnack(
              context,
              'Error checking updates: ${response.statusCode}',
            );
          }
        }
      }
    } catch (e) {
      if (!silent) {
        if (context.mounted) {
          _showSnack(context, 'Failed to check for updates (Network error)');
        }
      }
    }
  }

  void _showSnack(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showUpdateDialog(
    BuildContext context,
    String version,
    String notes,
    List<Asset> assets,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Available: v$version'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A new version is available.'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    notes,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.system_update_alt),
              label: const Text('Update Now'),
              onPressed: () {
                Navigator.pop(context);
                _startUpdateProcess(context, assets);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _startUpdateProcess(
    BuildContext context,
    List<Asset> assets,
  ) async {
    final String? downloadUrl = _getBestAssetUrl(assets);

    if (downloadUrl == null) {
      _showSnack(context, "Could not find a compatible installer.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _DownloadProgressDialog(
          url: downloadUrl,
          onDownloadComplete: (filePath) {
            Navigator.pop(dialogContext);
            _installUpdate(filePath);
          },
          onDownloadError: () {
            Navigator.pop(dialogContext);
            _launchBrowser(downloadUrl);
          },
        );
      },
    );
  }

  Future<void> _installUpdate(String filePath) async {
    try {
      debugPrint("Opening file: $filePath");
      await OpenFilex.open(filePath);
    } catch (e) {
      debugPrint("Error opening file: $e");
    }
  }

  Future<void> _launchBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String? _getBestAssetUrl(List<Asset> assets) {
    if (Platform.isWindows) {
      final currentPath = Platform.resolvedExecutable.toLowerCase();
      final isMsix = currentPath.contains('windowsapps');

      if (isMsix) {
        return _findUrl(assets, ['.msix']) ?? _findUrl(assets, ['.exe']);
      } else {
        return _findUrl(assets, ['.exe']) ??
            _findUrl(assets, ['.zip']) ??
            _findUrl(assets, ['.msix']);
      }
    } else if (Platform.isLinux) {
      return _findUrl(assets, ['.AppImage']) ??
          _findUrl(assets, ['.deb', '.rpm']);
    } else if (Platform.isMacOS) {
      return _findUrl(assets, ['.dmg']) ?? _findUrl(assets, ['.pkg', '.zip']);
    }
    return null;
  }

  String? _findUrl(List<Asset> assets, List<String> extensions) {
    try {
      for (var ext in extensions) {
        final asset = assets.firstWhere(
          (a) => a.name.toLowerCase().endsWith(ext.toLowerCase()),
          orElse: () => Asset(
            url: '',
            id: 0,
            nodeId: '',
            name: '',
            label: '',
            uploader: Author(
              login: '',
              id: 0,
              nodeId: '',
              avatarUrl: '',
              gravatarId: '',
              url: '',
              htmlUrl: '',
              followersUrl: '',
              followingUrl: '',
              gistsUrl: '',
              starredUrl: '',
              subscriptionsUrl: '',
              organizationsUrl: '',
              reposUrl: '',
              eventsUrl: '',
              receivedEventsUrl: '',
              type: '',
              userViewType: '',
              siteAdmin: false,
            ),
            contentType: '',
            state: '',
            size: 0,
            digest: '',
            downloadCount: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            browserDownloadUrl: '',
          ),
        );
        if (asset.browserDownloadUrl.isNotEmpty) {
          return asset.browserDownloadUrl;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String url;
  final Function(String) onDownloadComplete;
  final VoidCallback onDownloadError;

  const _DownloadProgressDialog({
    required this.url,
    required this.onDownloadComplete,
    required this.onDownloadError,
  });

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0.0;
  String _status = "Starting download...";
  final Dio _dio = Dio();
  final CancelToken _cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    try {
      Directory? dir = await getTemporaryDirectory();
      String fileName = widget.url.split('/').last;
      String savePath = "${dir.path}/$fileName";

      await _dio.download(
        widget.url,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
              _status =
                  "Downloading... ${(received / 1024 / 1024).toStringAsFixed(1)} MB / ${(total / 1024 / 1024).toStringAsFixed(1)} MB";
            });
          }
        },
      );

      if (mounted) {
        setState(() => _status = "Verifying...");
        widget.onDownloadComplete(savePath);
      }
    } catch (e) {
      if (mounted) {
        if (!CancelToken.isCancel(e as DioException)) {
          widget.onDownloadError();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Downloading Update"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 20),
          Text(_status, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
