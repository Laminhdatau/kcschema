import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../features/brands/providers/brand_providers.dart';
import '../../../features/models/providers/model_providers.dart';
import '../../../features/schematics/providers/schematic_providers.dart';
import '../../../features/schematics/presentation/import_dialog.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/services/data_folder_service.dart';
import '../../../shared/widgets/text_input_dialog.dart';
import '../../../shared/widgets/confirm_delete_dialog.dart';

/// Panel sidebar kiri — navigasi tree: Merk → Tipe HP.
/// Mendukung CRUD merk & tipe, favorit, dan recent files.
class SidebarPanel extends ConsumerStatefulWidget {
  const SidebarPanel({super.key});

  @override
  ConsumerState<SidebarPanel> createState() => _SidebarPanelState();
}

class _SidebarPanelState extends ConsumerState<SidebarPanel> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _expandedBrands = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brands = ref.watch(brandListProvider);
    final count = ref.watch(schematicCountProvider);
    final recentFiles = ref.watch(recentSchematicsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgDark,
        border: Border(
          right: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          _buildSearchBar(context),
          const SizedBox(height: 4),

          // Favorites section
          _buildFavoritesSection(context),

          // Recent section
          _buildRecentSection(context, recentFiles),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 20),
          ),

          // Brand header + add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.phone_android_rounded,
                    size: 16, color: AppTheme.neonGreen),
                const SizedBox(width: 8),
                Text('MERK HP',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.neonGreen,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 11,
                        )),
                const Spacer(),
                _buildSmallIconButton(
                  icon: Icons.add_rounded,
                  tooltip: 'Tambah Merk',
                  onPressed: _addBrand,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Brand tree
          Expanded(
            child: brands.when(
              data: (brandList) => brandList.isEmpty
                  ? _buildEmptyState(context)
                  : _buildBrandTree(brandList),
              loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) =>
                  Center(child: Text('Error: $e', style: const TextStyle(fontSize: 12))),
            ),
          ),

          // Footer
          _buildFooter(context, count),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgDarkest,
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              gradient: LinearGradient(colors: [
                AppTheme.neonGreen.withValues(alpha: 0.2),
                AppTheme.neonGreenDark.withValues(alpha: 0.1),
              ]),
              border: Border.all(
                  color: AppTheme.neonGreen.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.memory_rounded,
                color: AppTheme.neonGreen, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KYASCHEMA',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.neonGreen,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        )),
                Text('Schematic Manager',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textTertiary,
                          fontSize: 10,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cari merk, tipe, atau file...',
          hintStyle: const TextStyle(fontSize: 12),
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        onChanged: (query) {
          ref.read(searchQueryProvider.notifier).state = query;
        },
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.star_rounded,
              size: 18, color: AppTheme.warningColor),
          title: Text('Favorit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  )),
          onTap: () {
            ref.read(sidebarViewModeProvider.notifier).state =
                SidebarViewMode.favorites;
            ref.read(selectedBrandIdProvider.notifier).state = null;
            ref.read(selectedModelIdProvider.notifier).state = null;
          },
        ),
      ),
    );
  }

  Widget _buildRecentSection(
      BuildContext context, AsyncValue<List<Schematic>> recentFiles) {
    final count = recentFiles.value?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.access_time_rounded,
              size: 18, color: AppTheme.infoColor),
          title: Text('Terakhir Dibuka',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  )),
          trailing: count > 0
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.bgHover,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('$count',
                      style: const TextStyle(
                          fontSize: 10, color: AppTheme.textTertiary)),
                )
              : null,
          onTap: () {
            ref.read(sidebarViewModeProvider.notifier).state =
                SidebarViewMode.recent;
            ref.read(selectedBrandIdProvider.notifier).state = null;
            ref.read(selectedModelIdProvider.notifier).state = null;
          },
        ),
      ),
    );
  }

  Widget _buildBrandTree(List<Brand> brands) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        final brand = brands[index];
        final isExpanded = _expandedBrands.contains(brand.id);
        final isSelected = ref.watch(selectedBrandIdProvider) == brand.id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand item
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedBrands.remove(brand.id);
                    } else {
                      _expandedBrands.add(brand.id);
                    }
                  });
                  ref.read(selectedBrandIdProvider.notifier).state = brand.id;
                  ref.read(selectedModelIdProvider.notifier).state = null;
                  ref.read(sidebarViewModeProvider.notifier).state =
                      SidebarViewMode.browse;
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.bgSelected
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.smartphone_rounded,
                          size: 16,
                          color: isSelected
                              ? AppTheme.neonGreen
                              : AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(brand.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.neonGreen
                                  : AppTheme.textPrimary,
                            )),
                      ),
                      // Context menu
                      _buildSmallIconButton(
                        icon: Icons.more_vert_rounded,
                        tooltip: 'Opsi',
                        onPressed: () => _showBrandMenu(context, brand),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Models (expanded)
            if (isExpanded) _buildModelList(brand.id),
          ],
        );
      },
    );
  }

  Widget _buildModelList(int brandId) {
    final models = ref.watch(modelListProvider);

    return models.when(
      data: (modelList) {
        if (modelList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(left: 40, top: 4, bottom: 8),
            child: InkWell(
              onTap: () => _addModel(brandId),
              child: Row(
                children: [
                  Icon(Icons.add_rounded,
                      size: 14,
                      color: AppTheme.textTertiary.withValues(alpha: 0.6)),
                  const SizedBox(width: 6),
                  Text('Tambah tipe...',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textTertiary.withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              ...modelList.map((Model model) {
                final isModelSelected =
                    ref.watch(selectedModelIdProvider) == model.id;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    onTap: () {
                      ref.read(selectedModelIdProvider.notifier).state =
                          model.id;
                      ref.read(sidebarViewModeProvider.notifier).state =
                          SidebarViewMode.browse;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isModelSelected
                            ? AppTheme.bgSelected
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.article_outlined,
                              size: 14,
                              color: isModelSelected
                                  ? AppTheme.neonGreen
                                  : AppTheme.textTertiary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(model.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isModelSelected
                                      ? AppTheme.neonGreen
                                      : AppTheme.textSecondary,
                                )),
                          ),
                          if (model.isFavorite)
                            const Icon(Icons.star_rounded,
                                size: 12, color: AppTheme.warningColor),
                          const SizedBox(width: 4),
                          _buildSmallIconButton(
                            icon: Icons.more_vert_rounded,
                            tooltip: 'Opsi Tipe',
                            onPressed: () => _showModelMenu(context, model),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              // Add model button
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 6),
                child: InkWell(
                  onTap: () => _addModel(brandId),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded,
                            size: 14,
                            color:
                                AppTheme.textTertiary.withValues(alpha: 0.6)),
                        const SizedBox(width: 6),
                        Text('Tambah tipe...',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textTertiary
                                    .withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $e', style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_rounded,
                size: 48,
                color: AppTheme.textTertiary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text('Belum ada data merk',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                    )),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addBrand,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Tambah Merk'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AsyncValue<int> count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.storage_rounded,
              size: 13,
              color: AppTheme.textTertiary.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Text(
            '${count.value ?? 0} skematik tersimpan',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                  fontSize: 11,
                ),
          ),
          const Spacer(),
          _buildSmallIconButton(
            icon: Icons.upload_rounded,
            tooltip: 'Import Skematik',
            onPressed: () => ImportDialog.show(
              context,
              initialBrandId: ref.read(selectedBrandIdProvider),
              initialModelId: ref.read(selectedModelIdProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    double size = 18,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icon, size: size, color: AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }

  // ── CRUD Actions ──

  Future<void> _addBrand() async {
    final name = await TextInputDialog.show(
      context,
      title: 'Tambah Merk Baru',
      hintText: 'Nama merk (contoh: Xiaomi, Samsung)',
      icon: Icons.smartphone_rounded,
    );
    if (name != null) {
      await ref.read(addBrandProvider)(name);
    }
  }

  Future<void> _addModel(int brandId) async {
    final name = await TextInputDialog.show(
      context,
      title: 'Tambah Tipe HP',
      hintText: 'Nama tipe (contoh: Redmi Note 8)',
      icon: Icons.article_outlined,
    );
    if (name != null) {
      await ref.read(addModelProvider)(brandId, name);
    }
  }

  void _showBrandMenu(BuildContext context, Brand brand) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(200, 200, 200, 200),
      items: [
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            leading: Icon(Icons.edit_rounded, size: 18),
            title: Text('Rename', style: TextStyle(fontSize: 13)),
          ),
          onTap: () async {
            final name = await TextInputDialog.show(
              context,
              title: 'Rename Merk',
              hintText: 'Nama baru',
              initialValue: brand.name,
              icon: Icons.edit_rounded,
            );
            if (name != null) {
              await ref.read(updateBrandProvider)(
                brand.copyWith(name: name),
              );
            }
          },
        ),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            leading: Icon(Icons.add_rounded, size: 18),
            title: Text('Tambah Tipe', style: TextStyle(fontSize: 13)),
          ),
          onTap: () => _addModel(brand.id),
        ),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            leading:
                Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.errorColor),
            title: Text('Hapus Merk',
                style: TextStyle(fontSize: 13, color: AppTheme.errorColor)),
          ),
          onTap: () async {
            final confirmed = await ConfirmDeleteDialog.show(
              context,
              title: 'Hapus Merk "${brand.name}"?',
              message: 'Semua tipe HP dan skematik di bawah merk ini akan dipindahkan ke trash.',
            );
            if (confirmed == true) {
              await ref.read(deleteBrandProvider)(brand.id);
            }
          },
        ),
      ],
    );
  }

  void _showModelMenu(BuildContext context, Model model) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(220, 200, 200, 200),
      items: [
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            leading: Icon(Icons.edit_rounded, size: 18),
            title: Text('Rename Tipe', style: TextStyle(fontSize: 13)),
          ),
          onTap: () async {
            final name = await TextInputDialog.show(
              context,
              title: 'Rename Tipe HP',
              hintText: 'Nama baru (contoh: Redmi Note 8)',
              initialValue: model.name,
              icon: Icons.edit_rounded,
            );
            if (name != null && name.trim().isNotEmpty) {
              await ref.read(updateModelProvider)(
                model.copyWith(name: name.trim()),
              );
            }
          },
        ),
        PopupMenuItem(
          child: ListTile(
            dense: true,
            leading: Icon(
              model.isFavorite ? Icons.star_outline_rounded : Icons.star_rounded,
              size: 18,
              color: model.isFavorite ? null : AppTheme.warningColor,
            ),
            title: Text(
              model.isFavorite ? 'Hapus dari Favorit' : 'Jadikan Favorit',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          onTap: () async {
            await ref.read(toggleModelFavoriteProvider)(model.id, !model.isFavorite);
          },
        ),
        PopupMenuItem(
          child: const ListTile(
            dense: true,
            leading:
                Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.errorColor),
            title: Text('Hapus Tipe HP',
                style: TextStyle(fontSize: 13, color: AppTheme.errorColor)),
          ),
          onTap: () async {
            final messenger = ScaffoldMessenger.of(context);
            final confirmed = await ConfirmDeleteDialog.show(
              context,
              title: 'Hapus Tipe "${model.name}"?',
              message: 'Semua skematik di bawah tipe ini akan dipindahkan ke folder trash.',
            );
            if (confirmed == true) {
              final currentSchematic = ref.read(currentSchematicProvider);
              final db = ref.read(databaseProvider);
              final folderService = ref.read(dataFolderServiceProvider);
              await folderService.initialize();

              final schematics =
                  await db.schematicDao.getSchematicsByModel(model.id);

              // Close viewer if any open file is under this model
              if (currentSchematic != null &&
                  schematics.any((s) => s.id == currentSchematic.id)) {
                ref.read(currentSchematicProvider.notifier).state = null;
                await Future.delayed(const Duration(milliseconds: 300));
              }

              try {
                for (final s in schematics) {
                  await folderService.softDelete(s.filePath);
                  await db.schematicDao.deleteSchematic(s.id);
                }

                await ref.read(deleteModelProvider)(model.id);

                if (ref.read(selectedModelIdProvider) == model.id) {
                  ref.read(selectedModelIdProvider.notifier).state = null;
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Gagal menghapus Tipe "${model.name}". Ada file skematik yang sedang dikunci oleh viewer/sistem.',
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
          },
        ),
      ],
    );
  }
}
