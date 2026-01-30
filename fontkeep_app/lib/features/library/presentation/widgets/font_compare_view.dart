import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';

class FontCompareView extends ConsumerStatefulWidget {
  final List<Font> fonts;

  const FontCompareView({super.key, required this.fonts});

  @override
  ConsumerState<FontCompareView> createState() => _FontCompareViewState();
}

class _FontCompareViewState extends ConsumerState<FontCompareView> {
  late final TextEditingController _textController;
  double _fontSize = 32;
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'The quick brown fox jumps over the lazy dog',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logger = ref.watch(loggerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_textColor == Colors.black && isDark) {
      _textColor = Colors.white;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_color_text),
            onPressed: () => _pickColor(context),
            tooltip: 'Text Color',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Comparison Text',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      const Icon(Icons.format_size, size: 20),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12,
                          max: 120,
                          onChanged: (val) => setState(() => _fontSize = val),
                        ),
                      ),
                      Text(_fontSize.toStringAsFixed(0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.fonts.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final font = widget.fonts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      font.familyName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder(
                      future: loadFontIntoFlutter(font, logger),
                      builder: (context, snapshot) {
                        return Text(
                          _textController.text.isEmpty
                              ? 'The quick brown fox'
                              : _textController.text,
                          style: TextStyle(
                            fontFamily: font.id,
                            fontSize: _fontSize,
                            color: _textColor,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                    Colors.black,
                    Colors.white,
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.teal,
                  ]
                  .map(
                    (color) => InkWell(
                      onTap: () {
                        setState(() => _textColor = color);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
