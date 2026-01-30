import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';

class VariableFontPlayground extends ConsumerStatefulWidget {
  final Font font;

  const VariableFontPlayground({super.key, required this.font});

  @override
  ConsumerState<VariableFontPlayground> createState() =>
      _VariableFontPlaygroundState();
}

class _VariableFontPlaygroundState
    extends ConsumerState<VariableFontPlayground> {
  late final TextEditingController _textController;

  // State variables
  double _weight = 400;
  double _fontSize = 32;
  double _height = 1.2;
  double _letterSpacing = 0.0;
  double _wordSpacing = 0.0;
  bool _isUnderlined = false;
  bool _isItalic = false;

  Future<void>? _loadFuture;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'The quick brown fox');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final logger = ref.watch(loggerProvider);
    _loadFuture = loadFontIntoFlutter(widget.font, logger);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  FontWeight _getFontWeight(double value) {
    final index = ((value - 100) / 100).round().clamp(0, 8);
    return FontWeight.values[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: _loadFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !globallyLoadedFonts.contains(widget.font.id)) {
                return const Center(child: CircularProgressIndicator());
              }

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _textController.text.isEmpty
                        ? 'The quick brown fox'
                        : _textController.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: widget.font.id,
                      fontSize: _fontSize,
                      fontWeight: _getFontWeight(_weight),
                      fontStyle: _isItalic
                          ? FontStyle.italic
                          : FontStyle.normal,
                      decoration: _isUnderlined
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      height: _height,
                      letterSpacing: _letterSpacing,
                      wordSpacing: _wordSpacing,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Container(
          height: 320,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Preview Text',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Toggles
              Row(
                children: [
                  Expanded(
                    child: FilterChip(
                      label: const Text('Italic'),
                      selected: _isItalic,
                      onSelected: (val) => setState(() => _isItalic = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilterChip(
                      label: const Text('Underline'),
                      selected: _isUnderlined,
                      onSelected: (val) => setState(() => _isUnderlined = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _buildSlider(
                'Weight',
                _weight,
                100,
                900,
                100,
                (val) => setState(() => _weight = val),
              ),

              _buildSlider(
                'Size',
                _fontSize,
                12,
                120,
                1,
                (val) => setState(() => _fontSize = val),
              ),

              _buildSlider(
                'Line Height',
                _height,
                0.5,
                3.0,
                0.1,
                (val) => setState(() => _height = val),
              ),

              _buildSlider(
                'Letter Spacing',
                _letterSpacing,
                -5,
                20,
                0.5,
                (val) => setState(() => _letterSpacing = val),
              ),

              _buildSlider(
                'Word Spacing',
                _wordSpacing,
                -5,
                40,
                0.5,
                (val) => setState(() => _wordSpacing = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    double divisions,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text(
              value.toStringAsFixed(label == 'Weight' ? 0 : 1),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: ((max - min) / divisions).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
