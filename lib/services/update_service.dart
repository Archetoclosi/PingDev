import 'dart:convert';
import 'package:http/http.dart' as http;
import 'changelog_service.dart';

class UpdateCheckResult {
  final bool updateAvailable;
  final String currentVersion;
  final String remoteVersion;

  const UpdateCheckResult({
    required this.updateAvailable,
    required this.currentVersion,
    required this.remoteVersion,
  });
}

class UpdateService {
  final ChangelogService _changelogService = ChangelogService();

  Future<UpdateCheckResult> checkForUpdate() async {
    final currentVersion = await _changelogService.getCurrentVersion();

    try {
      // Cache-bust to avoid stale version.json from service worker / browser cache
      final uri = Uri.parse('/version.json?t=${DateTime.now().millisecondsSinceEpoch}');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        return UpdateCheckResult(
          updateAvailable: false,
          currentVersion: currentVersion,
          remoteVersion: currentVersion,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final remoteVersion = (data['version'] as String?)?.split('+').first ?? currentVersion;

      return UpdateCheckResult(
        updateAvailable: remoteVersion != currentVersion,
        currentVersion: currentVersion,
        remoteVersion: remoteVersion,
      );
    } catch (_) {
      return UpdateCheckResult(
        updateAvailable: false,
        currentVersion: currentVersion,
        remoteVersion: currentVersion,
      );
    }
  }
}
