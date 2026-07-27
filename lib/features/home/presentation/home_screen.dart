import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/data_folder_service.dart';
import '../../sidebar/presentation/sidebar_panel.dart';
import '../../file_list/presentation/file_list_panel.dart';
import '../../viewer/presentation/viewer_panel.dart';
import '../../backup/presentation/backup_restore_dialog.dart';
import '../../stats/presentation/stats_dialog.dart';
import '../../schematics/presentation/import_dialog.dart';
import '../../models/providers/model_providers.dart';
import '../../schematics/providers/schematic_providers.dart';

/// Layar utama KYASCHEMA — layout 3 panel resizable dengan menu bar.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final MultiSplitViewController _splitController;

  @override
  void initState() {
    super.initState();
    _splitController = MultiSplitViewController(
      areas: [
        Area(size: 280, min: 220),
        Area(flex: 1, min: 250),
        Area(flex: 1.5, min: 350),
      ],
    );
    // Initialize data folder service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataFolderServiceProvider).initialize();
    });
  }

  @override
  void dispose() {
    _splitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): () {
            // Focus search — akan diimplementasi nanti
          },
          const SingleActivator(LogicalKeyboardKey.keyI, control: true): () {
            ImportDialog.show(
              context,
              initialBrandId: ref.read(selectedBrandIdProvider),
              initialModelId: ref.read(selectedModelIdProvider),
            );
          },
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              // Menu bar
              _buildMenuBar(context),
              // Main content
              Expanded(
                child: MultiSplitViewTheme(
                  data: MultiSplitViewThemeData(
                    dividerThickness: 4,
                    dividerPainter: DividerPainters.grooved1(
                      color: AppTheme.borderColor,
                      highlightedColor:
                          AppTheme.neonGreen.withValues(alpha: 0.7),
                      size: 28,
                      highlightedSize: 40,
                    ),
                  ),
                  child: MultiSplitView(
                    controller: _splitController,
                    builder: (context, area) {
                      switch (area.index) {
                        case 0:
                          return const SidebarPanel();
                        case 1:
                          return const FileListPanel();
                        case 2:
                          return const ViewerPanel();
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppTheme.bgDarkest,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          _menuButton('File', [
            PopupMenuItem(
              child: const ListTile(
                dense: true,
                leading: Icon(Icons.upload_file_rounded, size: 16),
                title: Text('Import Skematik',
                    style: TextStyle(fontSize: 12)),
                trailing: Text('Ctrl+I',
                    style:
                        TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
              ),
              onTap: () => ImportDialog.show(
                context,
                initialBrandId: ref.read(selectedBrandIdProvider),
                initialModelId: ref.read(selectedModelIdProvider),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: const ListTile(
                dense: true,
                leading: Icon(Icons.backup_rounded, size: 16),
                title:
                    Text('Backup / Restore', style: TextStyle(fontSize: 12)),
              ),
              onTap: () => BackupRestoreDialog.show(context),
            ),
          ]),
          _menuButton('View', [
            PopupMenuItem(
              child: const ListTile(
                dense: true,
                leading: Icon(Icons.bar_chart_rounded, size: 16),
                title: Text('Statistik', style: TextStyle(fontSize: 12)),
              ),
              onTap: () => StatsDialog.show(context),
            ),
          ]),
          _menuButton('Help', [
            PopupMenuItem(
              child: const ListTile(
                dense: true,
                leading: Icon(Icons.info_outline_rounded, size: 16),
                title: Text('Tentang KYASCHEMA',
                    style: TextStyle(fontSize: 12)),
              ),
              onTap: () => _showAbout(context),
            ),
          ]),
          const Spacer(),
          // App title in menu bar
          Text('KYASCHEMA v1.0.0',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textTertiary,
                    fontSize: 10,
                  )),
        ],
      ),
    );
  }

  Widget _menuButton(String label, List<PopupMenuEntry> items) {
    return PopupMenuButton(
      offset: const Offset(0, 32),
      itemBuilder: (_) => items,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(32),
          decoration:
              AppTheme.glassDecoration(borderRadius: AppTheme.radiusLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.neonGlowDecoration(
                  borderRadius: AppTheme.radiusMd,
                  glowIntensity: 0.2,
                ),
                child: const Icon(Icons.memory_rounded,
                    color: AppTheme.neonGreen, size: 48),
              ),
              const SizedBox(height: 20),
              Text('KYASCHEMA',
                  style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.neonGreen,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      )),
              const SizedBox(height: 4),
              Text('Schematic Management & Viewer',
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      )),
              const SizedBox(height: 4),
              Text('v1.0.0',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      )),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  'Dibuat oleh KYACODETECH SOLUTION\nTool manajemen skematik HP untuk teknisi service',
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
