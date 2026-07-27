import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/data_folder_service.dart';
import '../../../features/schematics/providers/schematic_providers.dart';
import '../../../features/schematics/presentation/import_dialog.dart';
import '../../../features/models/providers/model_providers.dart';
import '../../../shared/widgets/confirm_delete_dialog.dart';

/// Panel tengah — daftar file skematik sesuai filter aktif di sidebar.
class FileListPanel extends ConsumerStatefulWidget {
  const FileListPanel({super.key});

  @override
  ConsumerState<FileListPanel> createState() => _FileListPanelState();
}

class _FileListPanelState extends ConsumerState<FileListPanel> {
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(sidebarViewModeProvider);
    final modelId = ref.watch(selectedModelIdProvider);

    return Container(
      color: AppTheme.bgDarkest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToolbar(context, viewMode),
          const Divider(height: 1),
          Expanded(child: _buildContent(viewMode, modelId)),
        ],
      ),
    );
  }

  Widget _buildContent(SidebarViewMode viewMode, int? modelId) {
    switch (viewMode) {
      case SidebarViewMode.favorites:
        return _buildFavoritesList();
      case SidebarViewMode.recent:
        return _buildRecentList();
      case SidebarViewMode.browse:
        if (modelId == null) return _buildEmptyState();
        return _buildSchematicList();
    }
  }

  Widget _buildSchematicList() {
    final schematics = ref.watch(schematicListProvider);
    return schematics.when(
      data: (list) =>
          list.isEmpty ? _buildEmptyModelState() : _buildFileItems(list),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildFavoritesList() {
    final favorites = ref.watch(favoriteSchematicsProvider);
    return favorites.when(
      data: (list) => list.isEmpty
          ? _buildEmptyMessage(
              Icons.star_outline_rounded, 'Belum ada favorit',
              'Tandai bintang pada file untuk akses cepat')
          : _buildFileItems(list),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildRecentList() {
    final recent = ref.watch(recentSchematicsProvider);
    return recent.when(
      data: (list) => list.isEmpty
          ? _buildEmptyMessage(
              Icons.access_time_rounded, 'Belum ada file terbuka',
              'File yang terakhir dibuka akan muncul di sini')
          : _buildFileItems(list),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildFileItems(List<Schematic> schematics) {
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: schematics.length,
        itemBuilder: (context, index) =>
            _buildGridItem(schematics[index]),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: schematics.length,
      itemBuilder: (context, index) => _buildListItem(schematics[index]),
    );
  }

  Widget _buildListItem(Schematic schematic) {
    final isSelected =
        ref.watch(currentSchematicProvider)?.id == schematic.id;
    final categories = ref.watch(schematicCategoriesProvider(schematic.id));
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          onTap: () => _openSchematic(schematic),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.bgSelected : AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: isSelected
                    ? AppTheme.neonGreen.withValues(alpha: 0.4)
                    : AppTheme.borderColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                // PDF icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      size: 22, color: AppTheme.errorColor),
                ),
                const SizedBox(width: 12),

                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(schematic.fileName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppTheme.neonGreen
                                : AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            dateFormat.format(schematic.importedAt),
                            style: const TextStyle(
                                fontSize: 10, color: AppTheme.textTertiary),
                          ),
                          const SizedBox(width: 8),
                          // Category chips
                          categories.when(
                            data: (cats) => Expanded(
                              child: Row(
                                children: cats
                                    .take(2)
                                    .map((c) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppTheme.bgHover,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(c.name,
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    color:
                                                        AppTheme.textTertiary),
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            loading: () => const SizedBox(),
                            error: (_, _) => const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _toggleFavorite(schematic),
                      icon: Icon(
                        schematic.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 18,
                        color: schematic.isFavorite
                            ? AppTheme.warningColor
                            : AppTheme.textTertiary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      tooltip: schematic.isFavorite
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
                    ),
                    IconButton(
                      onPressed: () => _deleteSchematic(schematic),
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 18, color: AppTheme.textTertiary),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      tooltip: 'Hapus',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(Schematic schematic) {
    final isSelected =
        ref.watch(currentSchematicProvider)?.id == schematic.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: () => _openSchematic(schematic),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.bgSelected : AppTheme.bgCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSelected
                  ? AppTheme.neonGreen.withValues(alpha: 0.4)
                  : AppTheme.borderColor.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              // PDF preview area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.bgDarkest,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusMd)),
                  ),
                  child: const Center(
                    child: Icon(Icons.picture_as_pdf_rounded,
                        size: 40, color: AppTheme.errorColor),
                  ),
                ),
              ),
              // File info
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(schematic.fileName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('dd/MM/yy')
                                .format(schematic.importedAt),
                            style: const TextStyle(
                                fontSize: 9, color: AppTheme.textTertiary),
                          ),
                        ),
                        InkWell(
                          onTap: () => _toggleFavorite(schematic),
                          child: Icon(
                            schematic.isFavorite
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 14,
                            color: schematic.isFavorite
                                ? AppTheme.warningColor
                                : AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, SidebarViewMode viewMode) {
    final modelId = ref.watch(selectedModelIdProvider);
    final schematics = ref.watch(schematicListProvider);
    final count = schematics.value?.length ?? 0;

    String title;
    switch (viewMode) {
      case SidebarViewMode.favorites:
        title = '⭐ Favorit';
        break;
      case SidebarViewMode.recent:
        title = '🕓 Terakhir Dibuka';
        break;
      case SidebarViewMode.browse:
        title = modelId != null ? 'File Skematik' : 'Semua File';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(color: AppTheme.bgDark),
      child: Row(
        children: [
          const Icon(Icons.folder_rounded,
              size: 16, color: AppTheme.textTertiary),
          const SizedBox(width: 8),
          Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
          const SizedBox(width: 8),
          if (viewMode == SidebarViewMode.browse && modelId != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.bgHover,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$count',
                  style: const TextStyle(
                      fontSize: 10, color: AppTheme.textTertiary)),
            ),
          const Spacer(),

          // Toggle view
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(
              _isGridView
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
              size: 18,
            ),
            tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 4),

          // Import button
          Material(
            color: AppTheme.neonGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              onTap: () => ImportDialog.show(
                context,
                initialBrandId: ref.read(selectedBrandIdProvider),
                initialModelId: ref.read(selectedModelIdProvider),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded,
                        size: 16, color: AppTheme.neonGreen),
                    const SizedBox(width: 4),
                    Text('Import',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                              color: AppTheme.neonGreen,
                              fontWeight: FontWeight.w600,
                            )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.neonGreen.withValues(alpha: 0.08),
                  Colors.transparent,
                ]),
              ),
              child: Icon(Icons.description_outlined,
                  size: 56,
                  color: AppTheme.textTertiary.withValues(alpha: 0.4)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Pilih merk & tipe di sidebar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  )),
          const SizedBox(height: 8),
          Text('File skematik akan ditampilkan di sini',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildEmptyModelState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add_outlined,
              size: 48,
              color: AppTheme.textTertiary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Belum ada skematik di tipe ini',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ImportDialog.show(
              context,
              initialBrandId: ref.read(selectedBrandIdProvider),
              initialModelId: ref.read(selectedModelIdProvider),
            ),
            icon: const Icon(Icons.upload_file_rounded, size: 18),
            label: const Text('Import Skematik'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessage(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 48,
              color: AppTheme.textTertiary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  )),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  // ── Actions ──

  void _openSchematic(Schematic schematic) {
    ref.read(currentSchematicProvider.notifier).state = schematic;
    ref.read(markSchematicOpenedProvider)(schematic.id);
  }

  Future<void> _toggleFavorite(Schematic schematic) async {
    await ref.read(toggleSchematicFavoriteProvider)(
        schematic.id, !schematic.isFavorite);
  }

  Future<void> _deleteSchematic(Schematic schematic) async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Hapus "${schematic.fileName}"?',
      message: 'File akan dipindahkan ke folder trash.',
    );
    if (confirmed == true) {
      // 1. Close viewer FIRST if this file is currently open to release Windows file lock
      if (ref.read(currentSchematicProvider)?.id == schematic.id) {
        ref.read(currentSchematicProvider.notifier).state = null;
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // 2. Perform soft delete with friendly error notification
      try {
        final folderService = ref.read(dataFolderServiceProvider);
        await folderService.initialize();
        await folderService.softDelete(schematic.filePath);
        await ref.read(deleteSchematicProvider)(schematic.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File "${schematic.fileName}" dipindahkan ke trash.'),
              backgroundColor: AppTheme.neonGreenDark,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tidak bisa menghapus "${schematic.fileName}". File sedang dikunci oleh sistem/viewer. Silakan coba lagi.',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.errorColor,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
}
