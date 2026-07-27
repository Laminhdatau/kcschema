import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/data_folder_service.dart';
import '../../../features/schematics/providers/schematic_providers.dart';
import '../../../core/database/app_database.dart';

/// Panel kanan — PDF viewer terintegrasi dengan pdfrx.
/// Mendukung:
/// - Exact Page Matching & Smooth Auto-Pan Navigation ke koordinat titik komponen
/// - Stabilo Highlighter Neon (Yellow/Green) transparan presisi 100%
/// - Auto-Highlight semua teks/komponen yang sama saat di-blok atau di-double-click
/// - Ctrl + Mouse Wheel Scroll Zoom In / Out
/// - Internal link navigation
class ViewerPanel extends ConsumerStatefulWidget {
  const ViewerPanel({super.key});

  @override
  ConsumerState<ViewerPanel> createState() => _ViewerPanelState();
}

class _ViewerPanelState extends ConsumerState<ViewerPanel> {
  PdfViewerController? _pdfController;
  PdfTextSearcher? _textSearcher;
  PdfDocument? _document;

  final TextEditingController _pdfSearchController = TextEditingController();
  bool _isSearchVisible = false;
  int _currentPage = 1;
  int _totalPages = 0;
  double _currentZoom = 1.0;
  int _rotation = 0; // 0, 90, 180, 270

  int _matchCount = 0;
  int _currentMatchIndex = 0;
  String? _selectedText;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfSearchController.dispose();
    _textSearcher?.dispose();
    super.dispose();
  }

  void _onViewerReady(PdfDocument document, PdfViewerController controller) {
    _document = document;
    _textSearcher = PdfTextSearcher(controller)
      ..addListener(() {
        if (mounted) {
          setState(() {
            _matchCount = _textSearcher?.matches.length ?? 0;
            if (_matchCount > 0 && _currentMatchIndex >= _matchCount) {
              _currentMatchIndex = 0;
            }
          });
        }
      });

    setState(() {
      _totalPages = document.pages.length;
      _currentPage = 1;
    });
  }

  Future<void> _goToMatch(int index) async {
    if (_textSearcher == null || _textSearcher!.matches.isEmpty) return;
    final matches = _textSearcher!.matches;
    _currentMatchIndex = (index + matches.length) % matches.length;
    final match = matches[_currentMatchIndex];

    final targetPage = match.pageNumber;

    // 1. Go to exact page number first
    await _pdfController?.goToPage(pageNumber: targetPage);
    setState(() {
      _currentPage = targetPage;
    });

    // 2. Pan/Scroll matrix directly to the exact match coordinates on that page
    if (_document != null && targetPage >= 1 && targetPage <= _document!.pages.length) {
      final page = _document!.pages[targetPage - 1];
      final pageRect = match.bounds.toRect(page: page);
      final matrix = _pdfController?.calcMatrixForRect(pageRect);
      if (matrix != null) {
        await _pdfController?.goTo(matrix);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final schematic = ref.watch(currentSchematicProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgDarkest,
        border: Border(
          left: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildToolbar(context, schematic),
          if (schematic != null && _isSearchVisible)
            _buildInPdfSearchBar(context),
          const Divider(height: 1),
          Expanded(
            child: schematic == null
                ? _buildPlaceholder(context)
                : Stack(
                    children: [
                      _buildViewerWithScrollZoom(schematic),
                      if (_selectedText != null && _selectedText!.isNotEmpty)
                        _buildTextSelectionQuickSearch(context),
                    ],
                  ),
          ),
          if (schematic != null && _totalPages > 1)
            _buildPageNavigator(context),
        ],
      ),
    );
  }

  Widget _buildViewerWithScrollZoom(Schematic schematic) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (HardwareKeyboard.instance.isControlPressed) {
            final dy = pointerSignal.scrollDelta.dy;
            setState(() {
              if (dy < 0) {
                _currentZoom = (_currentZoom + 0.15).clamp(0.5, 4.0);
              } else if (dy > 0) {
                _currentZoom = (_currentZoom - 0.15).clamp(0.5, 4.0);
              }
              _pdfController?.setZoom(
                  _pdfController!.centerPosition, _currentZoom);
            });
          }
        }
      },
      child: _buildViewer(schematic),
    );
  }

  Widget _buildViewer(Schematic schematic) {
    final folderService = ref.read(dataFolderServiceProvider);
    final filePath = folderService.getAbsolutePath(schematic.filePath);
    final file = File(filePath);

    if (!file.existsSync()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text('File tidak ditemukan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.errorColor,
                    )),
            const SizedBox(height: 8),
            SelectableText(filePath,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    }

    return RotatedBox(
      quarterTurns: _rotation ~/ 90,
      child: PdfViewer.file(
        filePath,
        controller: _pdfController,
        params: PdfViewerParams(
          backgroundColor: AppTheme.bgDarkest,
          enableTextSelection: true,
          pageDropShadow: const BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
          onViewerReady: _onViewerReady,
          onTextSelectionChange: (selection) {
            if (selection.isNotEmpty) {
              final text = selection.map((s) => s.text).join(' ').trim();
              if (text.isNotEmpty && text.length < 50) {
                setState(() {
                  _selectedText = text;
                  _isSearchVisible = true;
                  _pdfSearchController.text = text;
                });
                _textSearcher?.startTextSearch(text);
              }
            }
          },
          pagePaintCallbacks: [
            (Canvas canvas, Rect pageRect, PdfPage page) {
              if (_textSearcher == null || _textSearcher!.matches.isEmpty) return;

              // Strictly filter matches for current page.pageNumber
              final pageMatches = _textSearcher!.matches
                  .where((m) => m.pageNumber == page.pageNumber)
                  .toList();

              if (pageMatches.isEmpty) return;

              // Soft Translucent Yellow for inactive duplicate text layers
              final defaultPaint = Paint()
                ..color = const Color(0x25FFE600)
                ..style = PaintingStyle.fill;

              final defaultBorderPaint = Paint()
                ..color = const Color(0x66FFD700)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0.8;

              // Vibrant Neon Green for Active Focused Match Text
              final activePaint = Paint()
                ..color = const Color(0x6600FF41)
                ..style = PaintingStyle.fill;

              final activeBorderPaint = Paint()
                ..color = const Color(0xFF00FF41)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.2;

              final activeMatch = (_textSearcher != null &&
                      _textSearcher!.matches.isNotEmpty &&
                      _currentMatchIndex < _textSearcher!.matches.length)
                  ? _textSearcher!.matches[_currentMatchIndex]
                  : null;

              for (int i = 0; i < pageMatches.length; i++) {
                final match = pageMatches[i];
                final isCurrent = identical(match, activeMatch);
                final fillPaint = isCurrent ? activePaint : defaultPaint;
                final borderPaint = isCurrent ? activeBorderPaint : defaultBorderPaint;

                // Highlight strictly the exact text character bounds
                final fragments = match.fragments;

                if (fragments.isNotEmpty) {
                  for (final fragment in fragments) {
                    final rect = fragment.bounds;
                    final r = rect.toRect(page: page);
                    final scaleX = pageRect.width / page.width;
                    final scaleY = pageRect.height / page.height;

                    final screenRect = Rect.fromLTRB(
                      r.left * scaleX,
                      r.top * scaleY,
                      r.right * scaleX,
                      r.bottom * scaleY,
                    );

                    final rrect = RRect.fromRectAndRadius(
                      screenRect, // Exact text bounds without inflation
                      const Radius.circular(1.5),
                    );

                    canvas.drawRRect(rrect, fillPaint);
                    canvas.drawRRect(rrect, borderPaint);
                  }
                } else {
                  final rect = match.bounds;
                  final r = rect.toRect(page: page);
                  final scaleX = pageRect.width / page.width;
                  final scaleY = pageRect.height / page.height;

                  final screenRect = Rect.fromLTRB(
                    r.left * scaleX,
                    r.top * scaleY,
                    r.right * scaleX,
                    r.bottom * scaleY,
                  );

                  final rrect = RRect.fromRectAndRadius(
                    screenRect,
                    const Radius.circular(1.5),
                  );

                  canvas.drawRRect(rrect, fillPaint);
                  canvas.drawRRect(rrect, borderPaint);
                }
              }
            },
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, Schematic? schematic) {
    final hasFile = schematic != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(color: AppTheme.bgDark),
      child: Row(
        children: [
          // File info
          Icon(Icons.picture_as_pdf_rounded,
              size: 16,
              color: hasFile ? AppTheme.errorColor : AppTheme.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasFile ? schematic.fileName : 'Tidak ada file terbuka',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: hasFile
                        ? AppTheme.textPrimary
                        : AppTheme.textTertiary,
                    fontStyle:
                        hasFile ? FontStyle.normal : FontStyle.italic,
                    fontWeight: hasFile ? FontWeight.w500 : null,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (hasFile) ...[
            _toolbarButton(
              icon: Icons.find_in_page_rounded,
              tooltip: 'Cari Teks / Komponen (Stabilo Highlight)',
              iconColor: _isSearchVisible ? AppTheme.neonGreen : null,
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                  if (!_isSearchVisible) {
                    _textSearcher?.resetTextSearch();
                  }
                });
              },
            ),
            _divider(),
            _toolbarButton(
              icon: Icons.zoom_out_rounded,
              tooltip: 'Zoom Out (atau Ctrl + Scroll Down)',
              onPressed: () {
                _currentZoom = (_currentZoom - 0.25).clamp(0.5, 4.0);
                _pdfController?.setZoom(
                    _pdfController!.centerPosition, _currentZoom);
                setState(() {});
              },
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('${(_currentZoom * 100).toInt()}%',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary)),
            ),
            _toolbarButton(
              icon: Icons.zoom_in_rounded,
              tooltip: 'Zoom In (atau Ctrl + Scroll Up)',
              onPressed: () {
                _currentZoom = (_currentZoom + 0.25).clamp(0.5, 4.0);
                _pdfController?.setZoom(
                    _pdfController!.centerPosition, _currentZoom);
                setState(() {});
              },
            ),
            _divider(),
            _toolbarButton(
              icon: Icons.rotate_right_rounded,
              tooltip: 'Putar 90°',
              onPressed: () {
                setState(() {
                  _rotation = (_rotation + 90) % 360;
                });
              },
            ),
            _toolbarButton(
              icon: Icons.fit_screen_rounded,
              tooltip: 'Fit to Page',
              onPressed: () {
                _currentZoom = 1.0;
                _pdfController?.setZoom(
                    _pdfController!.centerPosition, _currentZoom);
                setState(() {});
              },
            ),
            _divider(),
            _toolbarButton(
              icon: Icons.open_in_new_rounded,
              tooltip: 'Buka di App Eksternal',
              onPressed: () => _openExternal(schematic),
            ),
            _toolbarButton(
              icon: Icons.close_rounded,
              tooltip: 'Tutup',
              onPressed: () {
                ref.read(currentSchematicProvider.notifier).state = null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInPdfSearchBar(BuildContext context) {
    final currentMatchPage = (_textSearcher != null &&
            _textSearcher!.matches.isNotEmpty &&
            _currentMatchIndex < _textSearcher!.matches.length)
        ? _textSearcher!.matches[_currentMatchIndex].pageNumber
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 16, color: AppTheme.neonGreen),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _pdfSearchController,
              autofocus: true,
              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Cari kode komponen / jalur (contoh: U1001, VPH_PWR)...',
                hintStyle: TextStyle(fontSize: 11),
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  _textSearcher?.startTextSearch(query.trim());
                  _goToMatch(0);
                }
              },
            ),
          ),
          if (_matchCount > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.bgHover,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Match ${_currentMatchIndex + 1}/$_matchCount ${currentMatchPage != null ? "(Hal. $currentMatchPage)" : ""}',
                style: const TextStyle(fontSize: 10, color: AppTheme.neonGreen),
              ),
            ),
            const SizedBox(width: 6),
            _toolbarButton(
              icon: Icons.keyboard_arrow_up_rounded,
              tooltip: 'Sebelumnya',
              onPressed: () => _goToMatch(_currentMatchIndex - 1),
            ),
            _toolbarButton(
              icon: Icons.keyboard_arrow_down_rounded,
              tooltip: 'Selanjutnya',
              onPressed: () => _goToMatch(_currentMatchIndex + 1),
            ),
          ],
          _divider(),
          Tooltip(
            message: 'Cari komponen ini di Seluruh Skematik Aplikasi',
            child: InkWell(
              onTap: () {
                final query = _pdfSearchController.text.trim();
                if (query.isNotEmpty) {
                  ref.read(searchQueryProvider.notifier).state = query;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mencari "$query" di seluruh database skematik...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.travel_explore_rounded,
                        size: 14, color: AppTheme.neonGreen),
                    SizedBox(width: 4),
                    Text('Cari Global',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.neonGreen,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSelectionQuickSearch(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          color: AppTheme.bgCard,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: AppTheme.neonGreen.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonGreen.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.highlight_rounded,
                    color: AppTheme.warningColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Stabilo Highlight: "$_selectedText"',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_selectedText != null) {
                      setState(() {
                        _isSearchVisible = true;
                        _pdfSearchController.text = _selectedText!;
                      });
                      _textSearcher?.startTextSearch(_selectedText!);
                      _goToMatch(0);
                    }
                  },
                  icon: const Icon(Icons.search_rounded, size: 14),
                  label: const Text('Sorot di PDF', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (_selectedText != null) {
                      ref.read(searchQueryProvider.notifier).state =
                          _selectedText!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Mencari "$_selectedText" di seluruh database...'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.travel_explore_rounded, size: 14),
                  label: const Text('Cari Global', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    side: const BorderSide(color: AppTheme.neonGreen),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedText = null;
                      _textSearcher?.resetTextSearch();
                    });
                  },
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: AppTheme.textTertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageNavigator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.bgDark,
        border: Border(
          top: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () {
                    _pdfController?.goToPage(pageNumber: _currentPage - 1);
                    setState(() => _currentPage--);
                  }
                : null,
            icon: const Icon(Icons.chevron_left_rounded, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Text(
              'Halaman $_currentPage / $_totalPages',
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _currentPage < _totalPages
                ? () {
                    _pdfController?.goToPage(pageNumber: _currentPage + 1);
                    setState(() => _currentPage++);
                  }
                : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.scale(
                  scale: 0.8 + (0.2 * value), child: child),
            ),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.neonGreen.withValues(alpha: 0.08),
                  Colors.transparent,
                ]),
                border: Border.all(
                  color: AppTheme.neonGreen.withValues(alpha: 0.15),
                ),
              ),
              child: Icon(Icons.picture_as_pdf_rounded,
                  size: 64,
                  color: AppTheme.textTertiary.withValues(alpha: 0.3)),
            ),
          ),
          const SizedBox(height: 24),
          Text('PDF Viewer & Precision Navigation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w300,
                  )),
          const SizedBox(height: 8),
          Text(
            'Klik file di panel sebelah kiri untuk membuka skematik.\nTekan Next (▼) / Prev (▲) untuk berpindah langsung ke tiap lokasi titik komponen!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textTertiary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shortcutHint(context, '▲ / ▼', 'Match Nav', 'Lompat ke Komponen'),
              const SizedBox(width: 12),
              _shortcutHint(context, 'Ctrl+', 'Mouse Wheel', 'Zoom In / Out'),
              const SizedBox(width: 12),
              _shortcutHint(context, 'Double-Click', 'Teks', 'Auto Stabilo Markup'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon,
                size: 18, color: iconColor ?? AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppTheme.borderColor,
    );
  }

  Widget _shortcutHint(
      BuildContext context, String prefix, String key, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          _keyBadge(prefix),
          const SizedBox(width: 2),
          _keyBadge(key),
        ]),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: AppTheme.textTertiary.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _keyBadge(String key) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.bgHover,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: AppTheme.borderColor.withValues(alpha: 0.5)),
      ),
      child: Text(key,
          style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w500)),
    );
  }

  Future<void> _openExternal(Schematic schematic) async {
    final folderService = ref.read(dataFolderServiceProvider);
    final filePath = folderService.getAbsolutePath(schematic.filePath);
    final uri = Uri.file(filePath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
