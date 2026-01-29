import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async'; // Added
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../state/reading_state_manager.dart';
import 'issue_detail_screen.dart';


import 'package:flutter/services.dart' show rootBundle;

class ArticleReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final dynamic issue;

  const ArticleReaderScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
    this.issue,
  });

  @override
  State<ArticleReaderScreen> createState() => _ArticleReaderScreenState();
}

class _ArticleReaderScreenState extends State<ArticleReaderScreen>
    with SingleTickerProviderStateMixin {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  String? _localFilePath;
  bool _isLoading = true;
  String? _error;
  bool _nightMode = false;
  bool _swipeHorizontal = true;
  bool _showControls = true;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReadingStateManager().hideBar(); // Ẩn thanh phát thu nhỏ
    });
    // Đồng bộ trang hiện tại
    _currentPage = ReadingStateManager().currentPage;
    _downloadPdf();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReadingStateManager().showBar();
    });
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    try {
      final url = widget.pdfUrl;
      final filename =
          '${url.split('/').last.replaceAll(RegExp(r'\W'), '_')}.pdf';
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');

      if (await file.exists()) {
        if (mounted) {
          setState(() {
            _localFilePath = file.path;
            _isLoading = false;
          });
        }
        return;
      }

      if (url.startsWith('asset:///')) {
        final assetPath = url.replaceFirst('asset:///', '');
        try {
          final data = await rootBundle.load(assetPath);
          final bytes = data.buffer.asUint8List();
          await file.writeAsBytes(bytes);
          if (mounted) {
            setState(() {
              _localFilePath = file.path;
              _isLoading = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _error = 'Asset not found: $assetPath';
              _isLoading = false;
            });
          }
        }
        return;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        if (mounted) {
          setState(() {
            _localFilePath = file.path;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = 'Error ${response.statusCode}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '$e';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  // unused _showSettingsModal

  void _onPageChanged(int? page, int? total) {
    if (page != null) {
      ReadingStateManager().updatePage(page);
      setState(() {
        _currentPage = page;
        if (total != null) _totalPages = total;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _nightMode ? Colors.grey[900] : Colors.grey[100],
      body: Stack(
        children: [
          // PDF View (Full Screen)
          GestureDetector(
            onTap: _toggleControls,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : PDFView(
                    filePath: _localFilePath,
                    enableSwipe: true,
                    swipeHorizontal: _swipeHorizontal,
                    autoSpacing: true,
                    pageFling: true,
                    nightMode: _nightMode,
                    defaultPage: _currentPage,
                    fitPolicy: FitPolicy.WIDTH, // Tự động dãn trang theo chiều ngang
                    onRender: (pages) {
                      setState(() => _totalPages = pages ?? 0);
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    onPageChanged: _onPageChanged,
                    onError: (e) => setState(() => _error = e.toString()),
                  ),
          ),

          // Top Bar (AppBar)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text(widget.title, style: const TextStyle(fontSize: 14)),
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 4,
              actions: [
                IconButton(
                  icon: const Icon(Icons.list),
                  tooltip: 'Mục lục',
                  onPressed: () {
                    // Mở màn hình chi tiết số báo
                    if (widget.issue != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              IssueDetailScreen(issue: widget.issue),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không tìm thấy thông tin mục lục'),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    // Hộp thoại cài đặt nhanh
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Container(
                        height: 150,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Ban đêm'),
                              value: _nightMode,
                              onChanged: (v) => setState(() => _nightMode = v),
                            ),
                            SwitchListTile(
                              title: const Text('Lướt ngang'),
                              value: _swipeHorizontal,
                              onChanged: (v) =>
                                  setState(() => _swipeHorizontal = v),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            bottom: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white.withOpacity(0.95),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Text(
                      '${_currentPage + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Slider(
                        value: (_totalPages > 0)
                            ? _currentPage.toDouble().clamp(
                                0.0,
                                (_totalPages - 1).toDouble(),
                              )
                            : 0.0,
                        min: 0,
                        max: (_totalPages > 0 ? _totalPages - 1 : 0).toDouble(),
                        activeColor: const Color(0xFF9E1E1E),
                        inactiveColor: Colors.grey[300],
                        onChanged: (_totalPages > 0)
                            ? (val) {
                                _controller.future.then((controller) {
                                  controller.setPage(val.toInt());
                                });
                                setState(() => _currentPage = val.toInt());
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$_totalPages',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
