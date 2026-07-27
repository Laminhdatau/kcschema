import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/data_folder_service.dart';
import '../../../features/brands/providers/brand_providers.dart';
import '../../../features/models/providers/model_providers.dart';
import '../../../features/schematics/providers/schematic_providers.dart';
import '../../../features/categories/providers/category_providers.dart';
import '../../../shared/utils/category_icons.dart';
import '../../../shared/widgets/confirm_delete_dialog.dart';

/// Dialog import file PDF skematik.
///
/// Flow pintar:
/// - Jika dipanggil dari Tipe HP tertentu -> Merk & Tipe langsung terisi otomatis!
/// - Jika dipanggil dari Merk -> Merk terisi otomatis, tampilkan pilihan Tipe HP existing.
/// - Menampilkan Tipe HP existing (ChoiceChips) + Opsi "+ Tipe Baru" agar tidak perlu nulis ulang.
/// - Menyediakan opsi "+ Kategori Custom" agar input kategori tidak kaku.
class ImportDialog extends ConsumerStatefulWidget {
  final List<File>? preselectedFiles;
  final int? initialBrandId;
  final int? initialModelId;

  const ImportDialog({
    super.key,
    this.preselectedFiles,
    this.initialBrandId,
    this.initialModelId,
  });

  static Future<bool?> show(
    BuildContext context, {
    List<File>? files,
    int? initialBrandId,
    int? initialModelId,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ImportDialog(
        preselectedFiles: files,
        initialBrandId: initialBrandId,
        initialModelId: initialModelId,
      ),
    );
  }

  @override
  ConsumerState<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<ImportDialog> {
  List<File> _selectedFiles = [];
  int? _selectedBrandId;
  String? _newBrandName;

  int? _selectedModelId;
  String? _selectedModelName;
  String? _newModelName;

  final Set<int> _selectedCategoryIds = {};
  bool _isImporting = false;
  double _progress = 0;

  List<Model> _existingModels = [];
  bool _isLoadingModels = false;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedFiles != null) {
      _selectedFiles = widget.preselectedFiles!;
    }

    // Auto-detect or use initial selection
    _selectedBrandId = widget.initialBrandId ?? ref.read(selectedBrandIdProvider);
    _selectedModelId = widget.initialModelId ?? ref.read(selectedModelIdProvider);

    if (_selectedBrandId != null) {
      _loadModelsForBrand(_selectedBrandId!);
    }
  }

  Future<void> _loadModelsForBrand(int brandId) async {
    setState(() => _isLoadingModels = true);
    try {
      final db = ref.read(databaseProvider);
      final models = await db.modelDao.getModelsByBrand(brandId);
      if (mounted) {
        setState(() {
          _existingModels = models;
          _isLoadingModels = false;
          // If initialModelId was set, verify and set name
          if (_selectedModelId != null) {
            final match = models.where((m) => m.id == _selectedModelId).firstOrNull;
            if (match != null) {
              _selectedModelName = match.name;
            }
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingModels = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brands = ref.watch(brandListProvider);
    final categories = ref.watch(categoryListProvider);

    return Dialog(
      child: Container(
        width: 580,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(borderRadius: AppTheme.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.upload_file_rounded,
                      color: AppTheme.neonGreen, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Import Skematik',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. File selection
                    _buildSectionLabel('1. Pilih File PDF'),
                    const SizedBox(height: 8),
                    _buildFileSelector(),
                    const SizedBox(height: 20),

                    // 2. Brand selection
                    _buildSectionLabel('2. Merk HP'),
                    const SizedBox(height: 8),
                    brands.when(
                      data: (brandList) => _buildBrandSelector(brandList),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    const SizedBox(height: 20),

                    // 3. Model selection
                    _buildSectionLabel('3. Tipe HP'),
                    const SizedBox(height: 8),
                    _buildModelSelector(),
                    const SizedBox(height: 20),

                    // 4. Category multi-select
                    _buildSectionLabel('4. Kategori Blok (Bisa Pilih > 1)'),
                    const SizedBox(height: 8),
                    categories.when(
                      data: (catList) => _buildCategorySelector(catList),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    ),
                  ],
                ),
              ),
            ),

            // Progress bar
            if (_isImporting) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppTheme.bgHover,
                valueColor: const AlwaysStoppedAnimation(AppTheme.neonGreen),
              ),
              const SizedBox(height: 8),
              Text(
                'Mengimport... ${(_progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],

            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isImporting ? null : () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _canImport() && !_isImporting ? _doImport : null,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text(
                      'Import ${_selectedFiles.length} File${_selectedFiles.length > 1 ? 's' : ''}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.neonGreen,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
    );
  }

  Widget _buildFileSelector() {
    return Column(
      children: [
        if (_selectedFiles.isEmpty)
          InkWell(
            onTap: _pickFiles,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.borderColor,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                color: AppTheme.bgCard,
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_rounded,
                      size: 36,
                      color: AppTheme.textTertiary.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text('Klik untuk memilih file PDF',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text('Bisa pilih banyak file sekaligus',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          )
        else ...[
          Container(
            constraints: const BoxConstraints(maxHeight: 100),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedFiles.length,
              itemBuilder: (context, index) {
                final file = _selectedFiles[index];
                final name = file.path.split(Platform.pathSeparator).last;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded,
                          size: 16, color: AppTheme.errorColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(name,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => _selectedFiles.removeAt(index)),
                        icon: const Icon(Icons.close, size: 14),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Tambah File'),
          ),
        ],
      ],
    );
  }

  Widget _buildBrandSelector(List<Brand> brandList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...brandList.map((brand) => ChoiceChip(
                  label: Text(brand.name),
                  selected: _selectedBrandId == brand.id && _newBrandName == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedBrandId = selected ? brand.id : null;
                      _newBrandName = null;
                      _selectedModelId = null;
                      _selectedModelName = null;
                      _newModelName = null;
                      _existingModels = [];
                    });
                    if (selected) {
                      _loadModelsForBrand(brand.id);
                    }
                  },
                  selectedColor: AppTheme.bgSelected,
                  side: BorderSide(
                    color: _selectedBrandId == brand.id && _newBrandName == null
                        ? AppTheme.neonGreen
                        : AppTheme.borderColor,
                  ),
                )),
            ActionChip(
              label: const Text('+ Merk Baru'),
              onPressed: _addNewBrand,
              side: BorderSide(
                color: _newBrandName != null
                    ? AppTheme.neonGreen
                    : AppTheme.borderColor,
              ),
              backgroundColor:
                  _newBrandName != null ? AppTheme.bgSelected : null,
            ),
          ],
        ),
        if (_newBrandName != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.bgSelected,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppTheme.neonGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_circle_rounded,
                    size: 14, color: AppTheme.neonGreen),
                const SizedBox(width: 6),
                Text('Merk baru: $_newBrandName',
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.neonGreen)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModelSelector() {
    if (_selectedBrandId == null && _newBrandName == null) {
      return Text('Pilih merk terlebih dahulu',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
              ));
    }

    if (_isLoadingModels) {
      return const LinearProgressIndicator(minHeight: 2);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing models chips if any
        if (_existingModels.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._existingModels.map((model) => InputChip(
                    label: Text(model.name),
                    selected: _selectedModelId == model.id && _newModelName == null,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedModelId = model.id;
                          _selectedModelName = model.name;
                          _newModelName = null;
                        } else {
                          _selectedModelId = null;
                          _selectedModelName = null;
                        }
                      });
                    },
                    onDeleted: () => _deleteModelFromImport(model),
                    deleteIcon: const Icon(Icons.delete_outline_rounded, size: 14),
                    deleteIconColor: AppTheme.errorColor,
                    selectedColor: AppTheme.bgSelected,
                    checkmarkColor: AppTheme.neonGreen,
                    side: BorderSide(
                      color: _selectedModelId == model.id && _newModelName == null
                          ? AppTheme.neonGreen
                          : AppTheme.borderColor,
                    ),
                  )),
              ActionChip(
                label: const Text('+ Tipe Baru'),
                onPressed: _addNewModel,
                side: BorderSide(
                  color: _newModelName != null
                      ? AppTheme.neonGreen
                      : AppTheme.borderColor,
                ),
                backgroundColor:
                    _newModelName != null ? AppTheme.bgSelected : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Input field if no existing models or when entering new model
        if (_existingModels.isEmpty || _newModelName != null) ...[
          TextField(
            style: const TextStyle(fontSize: 13),
            controller: TextEditingController(text: _newModelName ?? '')
              ..selection = TextSelection.collapsed(offset: (_newModelName ?? '').length),
            decoration: InputDecoration(
              hintText: 'Masukkan nama tipe HP (contoh: Redmi Note 8)',
              isDense: true,
              suffixIcon: _newModelName != null && _existingModels.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        setState(() => _newModelName = null);
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _newModelName = value.trim().isEmpty ? null : value.trim();
                _selectedModelId = null;
                _selectedModelName = null;
              });
            },
          ),
        ],

        if (_selectedModelName != null && _newModelName == null) ...[
          const SizedBox(height: 4),
          Text('Tipe terpilih: $_selectedModelName',
              style: const TextStyle(fontSize: 11, color: AppTheme.neonGreen)),
        ],
      ],
    );
  }

  Widget _buildCategorySelector(List<Category> catList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...catList.map((cat) {
              final isSelected = _selectedCategoryIds.contains(cat.id);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CategoryIcons.getIcon(cat.iconKey),
                        size: 14,
                        color: isSelected ? AppTheme.neonGreen : AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text(cat.name),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategoryIds.add(cat.id);
                    } else {
                      _selectedCategoryIds.remove(cat.id);
                    }
                  });
                },
                selectedColor: AppTheme.bgSelected,
                checkmarkColor: AppTheme.neonGreen,
                side: BorderSide(
                  color: isSelected ? AppTheme.neonGreen : AppTheme.borderColor,
                ),
              );
            }),
            ActionChip(
              label: const Text('+ Kategori Custom / Other'),
              onPressed: _addCustomCategory,
              side: const BorderSide(color: AppTheme.borderColor),
            ),
          ],
        ),
      ],
    );
  }

  bool _canImport() {
    final hasBrand = _selectedBrandId != null || _newBrandName != null;
    final hasModel = _selectedModelId != null || _newModelName != null;
    return _selectedFiles.isNotEmpty &&
        hasBrand &&
        hasModel &&
        _selectedCategoryIds.isNotEmpty;
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(
          result.files
              .where((f) => f.path != null)
              .map((f) => File(f.path!)),
        );
      });
    }
  }

  Future<void> _addNewBrand() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Merk Baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nama merk HP'),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Tambah')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      setState(() {
        _newBrandName = name;
        _selectedBrandId = null;
        _selectedModelId = null;
        _selectedModelName = null;
        _existingModels = [];
      });
    }
  }

  Future<void> _addNewModel() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tipe HP Baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nama tipe HP (contoh: Redmi Note 8)'),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Tambah')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      setState(() {
        _newModelName = name;
        _selectedModelId = null;
        _selectedModelName = null;
      });
    }
  }

  Future<void> _deleteModelFromImport(Model model) async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Hapus Tipe "${model.name}"?',
      message: 'Tipe HP ini dan semua skematik di dalamnya akan dipindahkan ke trash.',
    );

    if (confirmed == true) {
      final currentSchematic = ref.read(currentSchematicProvider);
      final db = ref.read(databaseProvider);
      final folderService = ref.read(dataFolderServiceProvider);
      await folderService.initialize();

      final schematics = await db.schematicDao.getSchematicsByModel(model.id);

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

        if (_selectedModelId == model.id) {
          setState(() {
            _selectedModelId = null;
            _selectedModelName = null;
          });
        }

        if (_selectedBrandId != null) {
          _loadModelsForBrand(_selectedBrandId!);
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
  }

  Future<void> _addCustomCategory() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kategori Custom Baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Nama kategori/blok (contoh: Boardview, Diagram)'),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Tambah')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      final db = ref.read(databaseProvider);
      final allCategories = await db.categoryDao.getAllCategories();
      final existing = allCategories
          .where((c) => c.name.toLowerCase() == name.toLowerCase())
          .firstOrNull;

      int catId;
      if (existing != null) {
        catId = existing.id;
      } else {
        catId = await db.categoryDao.insertCategory(
          CategoriesCompanion(
            name: Value(name),
            isDefault: const Value(false),
            iconKey: const Value('other'),
          ),
        );
      }

      setState(() {
        _selectedCategoryIds.add(catId);
      });
    }
  }

  Future<void> _doImport() async {
    setState(() => _isImporting = true);

    try {
      final db = ref.read(databaseProvider);
      final folderService = ref.read(dataFolderServiceProvider);
      await folderService.initialize();

      // 1. Create/get brand (safeguard existing)
      int brandId;
      String brandName;
      if (_newBrandName != null) {
        final existingBrand = await db.brandDao.getBrandByName(_newBrandName!);
        if (existingBrand != null) {
          brandId = existingBrand.id;
          brandName = existingBrand.name;
        } else {
          brandId = await db.brandDao.insertBrand(
            BrandsCompanion(name: Value(_newBrandName!)),
          );
          brandName = _newBrandName!;
        }
      } else {
        brandId = _selectedBrandId!;
        final brands = await db.brandDao.getAllBrands();
        brandName = brands.firstWhere((b) => b.id == brandId).name;
      }

      // 2. Create/get model (safeguard existing)
      int modelId;
      String modelName;
      if (_newModelName != null) {
        final existingModels = await db.modelDao.getModelsByBrand(brandId);
        final matchModel = existingModels
            .where((m) => m.name.toLowerCase() == _newModelName!.toLowerCase())
            .firstOrNull;
        if (matchModel != null) {
          modelId = matchModel.id;
          modelName = matchModel.name;
        } else {
          modelId = await db.modelDao.insertModel(
            ModelsCompanion(
              brandId: Value(brandId),
              name: Value(_newModelName!),
            ),
          );
          modelName = _newModelName!;
        }
      } else {
        modelId = _selectedModelId!;
        modelName = _selectedModelName ?? 'Model';
      }

      // 3. Get category names for folder creation
      final allCategories = await db.categoryDao.getAllCategories();
      final selectedCategories = allCategories
          .where((c) => _selectedCategoryIds.contains(c.id))
          .toList();

      final primaryCategory =
          selectedCategories.isNotEmpty ? selectedCategories.first.name : 'Other';

      // 4. Import each file
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final relativePath = await folderService.importFile(
          file,
          brandName,
          modelName,
          primaryCategory,
        );

        final fileName = file.path.split(Platform.pathSeparator).last;
        await db.schematicDao.insertSchematic(
          SchematicsCompanion(
            modelId: Value(modelId),
            fileName: Value(fileName),
            filePath: Value(relativePath),
            originalFileName: Value(fileName),
          ),
          _selectedCategoryIds.toList(),
        );

        setState(() {
          _progress = (i + 1) / _selectedFiles.length;
        });
      }

      // Auto select the imported brand and model so UI updates immediately!
      ref.read(selectedBrandIdProvider.notifier).state = brandId;
      ref.read(selectedModelIdProvider.notifier).state = modelId;
      ref.read(sidebarViewModeProvider.notifier).state = SidebarViewMode.browse;

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${_selectedFiles.length} file berhasil diimport!'),
            backgroundColor: AppTheme.neonGreenDark,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal import: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}
