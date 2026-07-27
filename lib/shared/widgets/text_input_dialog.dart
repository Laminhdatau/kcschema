import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Dialog generik untuk input teks (tambah/edit merk, tipe, dll)
class TextInputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String? initialValue;
  final String confirmLabel;
  final IconData? icon;

  const TextInputDialog({
    super.key,
    required this.title,
    required this.hintText,
    this.initialValue,
    this.confirmLabel = 'Simpan',
    this.icon,
  });

  /// Show dialog and return input text, or null if cancelled
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String hintText,
    String? initialValue,
    String confirmLabel = 'Simpan',
    IconData? icon,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => TextInputDialog(
        title: title,
        hintText: hintText,
        initialValue: initialValue,
        confirmLabel: confirmLabel,
        icon: icon,
      ),
    );
  }

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(borderRadius: AppTheme.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                if (widget.icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.neonGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(widget.icon, color: AppTheme.neonGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Input field
            TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(hintText: widget.hintText),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pop(context, text);
    }
  }
}
