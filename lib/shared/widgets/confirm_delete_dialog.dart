import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Dialog konfirmasi hapus dengan warning visual
class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Hapus',
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Hapus',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(borderRadius: AppTheme.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.errorColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('File akan dipindahkan ke folder trash.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textTertiary,
                      fontStyle: FontStyle.italic,
                    )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                  ),
                  child: Text(confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
