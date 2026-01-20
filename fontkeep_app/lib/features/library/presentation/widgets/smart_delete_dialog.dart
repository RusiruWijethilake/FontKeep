import 'package:flutter/material.dart';
import 'package:fontkeep_app/data/local/database.dart';

class SmartDeleteDialog extends StatelessWidget {
  final List<Font> fonts;
  final VoidCallback onConfirm;

  const SmartDeleteDialog({
    super.key,
    required this.fonts,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final builtIn = fonts.where((f) => f.isBuiltIn).toList();
    final systemUser = fonts.where((f) => f.isSystem && !f.isBuiltIn).toList();
    final local = fonts.where((f) => !f.isSystem).toList();

    if (builtIn.isNotEmpty && systemUser.isEmpty && local.isEmpty) {
      return AlertDialog(
        title: const Text("Cannot Delete"),
        content: const Text("System built-in fonts cannot be deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text("Delete ${fonts.length} Font${fonts.length > 1 ? 's' : ''}?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (builtIn.isNotEmpty)
            _buildWarning(
              context,
              "${builtIn.length} built-in fonts will be skipped.",
              Colors.orange,
            ),
          if (systemUser.isNotEmpty)
            _buildWarning(
              context,
              "⚠️ ${systemUser.length} installed font(s) will be uninstalled from the system.",
              Colors.red,
            ),
          if (local.isNotEmpty)
            Text(
              "${local.length} local font(s) will be deleted from your library.",
            ),
          const SizedBox(height: 16),
          const Text(
            "This action cannot be undone.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }

  Widget _buildWarning(BuildContext context, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}
