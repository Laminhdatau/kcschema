import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/database_provider.dart';

/// Dialog statistik ringan tentang koleksi skematik.
class StatsDialog extends ConsumerWidget {
  const StatsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const StatsDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(borderRadius: AppTheme.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.bar_chart_rounded,
                      color: AppTheme.neonGreen, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Statistik Koleksi',
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

            FutureBuilder(
              future: Future.wait([
                db.brandDao.getAllBrands(),
                db.categoryDao.getAllCategories(),
                db.schematicDao.countSchematics(),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(strokeWidth: 2);
                }

                final brands = snapshot.data![0] as List;
                final categories = snapshot.data![1] as List;
                final totalSchematics = snapshot.data![2] as int;

                return Column(
                  children: [
                    _buildStatRow(context, Icons.memory_rounded,
                        'Total Skematik', '$totalSchematics',
                        color: AppTheme.neonGreen),
                    const SizedBox(height: 12),
                    _buildStatRow(context, Icons.smartphone_rounded,
                        'Jumlah Merk', '${brands.length}',
                        color: AppTheme.infoColor),
                    const SizedBox(height: 12),
                    _buildStatRow(context, Icons.category_rounded,
                        'Jumlah Kategori', '${categories.length}',
                        color: AppTheme.warningColor),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    )),
          ),
          Text(value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  )),
        ],
      ),
    );
  }
}
