import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fontkeep_app/data/local/database.dart';

class GlyphInspectorView extends StatelessWidget {
  final Font font;

  const GlyphInspectorView({super.key, required this.font});

  static final List<int> _glyphCodePoints = [
    // Basic Latin (32–126)
    ...Iterable<int>.generate(126 - 32 + 1, (i) => i + 32),
    // Latin-1 Supplement (160–255)
    ...Iterable<int>.generate(255 - 160 + 1, (i) => i + 160),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 80,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _glyphCodePoints.length,
      itemBuilder: (context, index) {
        final codePoint = _glyphCodePoints[index];
        final char = String.fromCharCode(codePoint);

        return Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showGlyphDetails(context, codePoint),
            child: Center(
              child: Text(
                char,
                style: TextStyle(fontFamily: font.id, fontSize: 32),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showGlyphDetails(BuildContext context, int codePoint) {
    final char = String.fromCharCode(codePoint);
    final unicode =
        'U+${codePoint.toRadixString(16).toUpperCase().padLeft(4, '0')}';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Glyph Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  char,
                  style: TextStyle(fontFamily: font.id, fontSize: 72),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                unicode,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Character: $char',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: char));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied $char to clipboard'),
                    duration: const Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Character'),
            ),
          ],
        );
      },
    );
  }
}
