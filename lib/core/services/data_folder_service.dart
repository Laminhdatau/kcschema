import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service untuk mengelola folder data KyaSchemaData.
///
/// Bertanggung jawab untuk:
/// - Membuat struktur folder (Merk/Tipe/Kategori)
/// - Copy file PDF ke folder terstruktur
/// - Soft delete ke folder _trash
/// - Menentukan path relatif untuk database
class DataFolderService {
  late final Directory _rootDir;
  late final Directory _trashDir;
  bool _initialized = false;

  /// Inisialisasi root folder data
  Future<void> initialize() async {
    if (_initialized) return;
    final appDocDir = await getApplicationDocumentsDirectory();
    _rootDir = Directory(p.join(appDocDir.path, 'KyaSchemaData'));
    _trashDir = Directory(p.join(_rootDir.path, '_trash'));

    if (!await _rootDir.exists()) {
      await _rootDir.create(recursive: true);
    }
    if (!await _trashDir.exists()) {
      await _trashDir.create(recursive: true);
    }
    _initialized = true;
  }

  /// Path root folder data
  String get rootPath => _rootDir.path;

  /// Path folder trash
  String get trashPath => _trashDir.path;

  /// Buat folder untuk merk/tipe/kategori
  Future<Directory> ensureFolder(
      String brandName, String modelName, String categoryName) async {
    await initialize();
    final dir = Directory(
      p.join(_rootDir.path, _sanitize(brandName), _sanitize(modelName),
          _sanitize(categoryName)),
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copy file PDF ke folder terstruktur, return path relatif
  Future<String> importFile(
    File sourceFile,
    String brandName,
    String modelName,
    String categoryName,
  ) async {
    final targetDir = await ensureFolder(brandName, modelName, categoryName);
    final fileName = p.basename(sourceFile.path);
    final targetPath = p.join(targetDir.path, fileName);

    // Cek duplikat, tambah suffix jika perlu
    File targetFile = File(targetPath);
    int counter = 1;
    while (await targetFile.exists()) {
      final nameWithoutExt = p.basenameWithoutExtension(fileName);
      final ext = p.extension(fileName);
      targetFile =
          File(p.join(targetDir.path, '${nameWithoutExt}_($counter)$ext'));
      counter++;
    }

    await sourceFile.copy(targetFile.path);

    // Return path relatif terhadap root
    return p.relative(targetFile.path, from: _rootDir.path);
  }

  /// Soft delete: pindahkan file ke _trash
  Future<void> softDelete(String relativePath) async {
    await initialize();
    final sourceFile = File(p.join(_rootDir.path, relativePath));
    if (await sourceFile.exists()) {
      final trashTarget = File(
        p.join(_trashDir.path,
            '${DateTime.now().millisecondsSinceEpoch}_${p.basename(relativePath)}'),
      );
      await sourceFile.rename(trashTarget.path);
    }
  }

  /// Get absolute path dari path relatif
  String getAbsolutePath(String relativePath) {
    return p.join(_rootDir.path, relativePath);
  }

  /// Sanitize nama folder (hapus karakter illegal)
  String _sanitize(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
  }

  /// Hapus folder merk
  Future<void> deleteBrandFolder(String brandName) async {
    await initialize();
    final dir = Directory(p.join(_rootDir.path, _sanitize(brandName)));
    if (await dir.exists()) {
      // Move ke trash dulu
      final trashTarget = Directory(p.join(
          _trashDir.path, '${DateTime.now().millisecondsSinceEpoch}_$brandName'));
      await dir.rename(trashTarget.path);
    }
  }

  /// Daftar semua file di trash
  Future<List<FileSystemEntity>> listTrash() async {
    await initialize();
    if (!await _trashDir.exists()) return [];
    return _trashDir.listSync();
  }

  /// Kosongkan trash (hapus permanen)
  Future<void> emptyTrash() async {
    await initialize();
    if (await _trashDir.exists()) {
      await _trashDir.delete(recursive: true);
      await _trashDir.create();
    }
  }
}

/// Provider untuk DataFolderService
final dataFolderServiceProvider = Provider<DataFolderService>((ref) {
  return DataFolderService();
});
