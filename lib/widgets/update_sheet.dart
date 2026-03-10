import 'package:flutter/material.dart';
import '../services/update_service.dart';

class UpdateSheet extends StatefulWidget {
  final UpdateCheckResult initialResult;

  const UpdateSheet({super.key, required this.initialResult});

  static Future<void> show(BuildContext context, UpdateCheckResult result) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => UpdateSheet(initialResult: result),
    );
  }

  @override
  State<UpdateSheet> createState() => _UpdateSheetState();
}

class _UpdateSheetState extends State<UpdateSheet> {
  late UpdateCheckResult _result;
  bool _checking = false;
  final UpdateService _updateService = UpdateService();

  @override
  void initState() {
    super.initState();
    _result = widget.initialResult;
  }

  Future<void> _checkForUpdates() async {
    setState(() => _checking = true);
    try {
      final result = await _updateService.checkForUpdate();
      if (mounted) setState(() => _result = result);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  void _performUpdate() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final hasUpdate = _result.updateAvailable;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Version badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Text(
              'v${_result.currentVersion}',
              style: TextStyle(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Updates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Status row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: hasUpdate ? Colors.orangeAccent : Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasUpdate
                      ? 'New version available: v${_result.remoteVersion}'
                      : 'You are up to date',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Check for updates button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _checking ? null : _checkForUpdates,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _checking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Check for updates',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
            ),
          ),

          if (hasUpdate) ...[
            const SizedBox(height: 12),

            // Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Update now',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
