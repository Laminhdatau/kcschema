import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/data_folder_service.dart';

/// Dialog backup & restore data KYASCHEMA.
class BackupRestoreDialog extends ConsumerStatefulWidget {
  const BackupRestoreDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const BackupRestoreDialog(),
    );
  }

  @override
  ConsumerState<BackupRestoreDialog> createState() =>
      _BackupRestoreDialogState();
}

class _BackupRestoreDialogState extends ConsumerState<BackupRestoreDialog> {
  bool _isProcessing = false;
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 460,
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(borderRadius: AppTheme.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.backup_rounded,
                      color: AppTheme.infoColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Backup & Restore',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Backup button
            _buildActionCard(
              icon: Icons.cloud_download_rounded,
              iconColor: AppTheme.neonGreen,
              title: 'Backup Data',
              description:
                  'Export seluruh database + folder skematik ke file .zip',
              buttonLabel: 'Backup Sekarang',
              onPressed: _isProcessing ? null : _doBackup,
            ),
            const SizedBox(height: 16),

            // Restore button
            _buildActionCard(
              icon: Icons.cloud_upload_rounded,
              iconColor: AppTheme.warningColor,
              title: 'Restore Data',
              description:
                  'Import kembali dari file backup .zip\n⚠ Data saat ini akan ditimpa!',
              buttonLabel: 'Pilih File Backup',
              onPressed: _isProcessing ? null : _doRestore,
              isWarning: true,
            ),

            if (_isProcessing) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(
                backgroundColor: AppTheme.bgHover,
                valueColor: AlwaysStoppedAnimation(AppTheme.neonGreen),
              ),
            ],
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(_status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _status.contains('Gagal')
                            ? AppTheme.errorColor
                            : AppTheme.neonGreen,
                      )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String buttonLabel,
    VoidCallback? onPressed,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                const SizedBox(height: 4),
                Text(description,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onPressed,
            style: isWarning
                ? ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warningColor,
                    foregroundColor: Colors.black,
                  )
                : null,
            child: Text(buttonLabel, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Future<void> _doBackup() async {
    setState(() {
      _isProcessing = true;
      _status = 'Mempersiapkan backup...';
    });

    try {
      final folderService = ref.read(dataFolderServiceProvider);
      await folderService.initialize();

      // Choose save location
      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Simpan Backup KYASCHEMA',
        fileName:
            'kyaschema_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (outputPath == null) {
        setState(() {
          _isProcessing = false;
          _status = '';
        });
        return;
      }

      setState(() => _status = 'Membuat arsip...');

      // Create zip archive
      final archive = Archive();
      final rootDir = Directory(folderService.rootPath);

      // Add data files
      if (await rootDir.exists()) {
        await for (final entity in rootDir.list(recursive: true)) {
          if (entity is File) {
            final relativePath = p.relative(entity.path, from: rootDir.path);
            final bytes = await entity.readAsBytes();
            archive.addFile(ArchiveFile(
              'KyaSchemaData/$relativePath',
              bytes.length,
              bytes,
            ));
          }
        }
      }

      // Add database file
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(appDocDir.path, 'kyaschema_db.sqlite3'));
      if (await dbFile.exists()) {
        final dbBytes = await dbFile.readAsBytes();
        archive.addFile(
            ArchiveFile('kyaschema_db.sqlite3', dbBytes.length, dbBytes));
      }

      // Write zip
      final zipData = ZipEncoder().encode(archive);
      await File(outputPath).writeAsBytes(zipData);

      setState(() {
        _isProcessing = false;
        _status = '✅ Backup berhasil disimpan!';
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _status = '❌ Gagal backup: $e';
      });
    }
  }

  Future<void> _doRestore() async {
    // Confirm first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Restore'),
        content: const Text(
            'Semua data saat ini akan ditimpa dengan data dari backup.\nLanjutkan?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningColor),
              child: const Text('Ya, Restore')),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
      _status = 'Memilih file backup...';
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.first.path == null) {
        setState(() {
          _isProcessing = false;
          _status = '';
        });
        return;
      }

      setState(() => _status = 'Mengekstrak backup...');

      final zipFile = File(result.files.first.path!);
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final folderService = ref.read(dataFolderServiceProvider);
      await folderService.initialize();

      final appDocDir = await getApplicationDocumentsDirectory();

      for (final file in archive) {
        if (file.isFile) {
          if (file.name == 'kyaschema_db.sqlite3') {
            // Restore database
            final dbFile = File(p.join(appDocDir.path, file.name));
            await dbFile.writeAsBytes(file.content as List<int>);
          } else if (file.name.startsWith('KyaSchemaData/')) {
            // Restore data files
            final targetPath = p.join(
              folderService.rootPath,
              file.name.replaceFirst('KyaSchemaData/', ''),
            );
            final targetFile = File(targetPath);
            await targetFile.parent.create(recursive: true);
            await targetFile.writeAsBytes(file.content as List<int>);
          }
        }
      }

      setState(() {
        _isProcessing = false;
        _status = '✅ Restore berhasil! Restart aplikasi untuk melihat perubahan.';
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _status = '❌ Gagal restore: $e';
      });
    }
  }
}
