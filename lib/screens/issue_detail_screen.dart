import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../models/article_model.dart';
import '../repositories/issue_repository.dart';
import 'article_reader_screen.dart';
import 'article_detail_screen.dart';

import '../state/reading_state_manager.dart';
import '../widgets/mini_reading_bar.dart';

class IssueDetailScreen extends StatefulWidget {
  final IssueModel issue;

  const IssueDetailScreen({super.key, required this.issue});

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  final IssueRepository _repository = globalIssueRepository;
  List<ArticleModel> _articles = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    final articles = await _repository.getArticlesByIssueId(widget.issue.id);
    if (mounted) {
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          widget.issue.fullTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Thông tin số báo
                SliverToBoxAdapter(child: _buildHeader()),

                // Tiêu đề mục lục
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'MỤC LỤC',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF9E1E1E),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                // Danh sách các bài viết
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildArticleItem(_articles[index], index);
                  }, childCount: _articles.length),
                ),

                // Khoảng trống cho Mini Player
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
      bottomSheet: AnimatedBuilder(
        animation: ReadingStateManager(),
        builder: (context, _) {
          final manager = ReadingStateManager();
          if (!manager.isVisible || manager.currentArticle == null) {
            return const SizedBox.shrink();
          }
          return MiniReadingBar(
            title: manager.currentArticle!.title,
            onTap: () {
              if (manager.currentArticle != null &&
                  manager.currentArticle!.pdfUrl != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArticleReaderScreen(
                      pdfUrl: manager.currentArticle!.pdfUrl!,
                      title: manager.currentArticle!.title,
                    ),
                  ),
                );
              } else if (manager.currentArticle != null) {
                // IssueDetail -> ArticleDetail.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArticleDetailScreen(
                      article: manager.currentArticle!,
                      issue: widget.issue,
                    ),
                  ),
                );
              }
            },
            onClose: () => manager.hide(),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa tạp chí
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.issue.isSpecial
                    ? [const Color(0xFF9E1E1E), const Color(0xFF700000)]
                    : [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 8,
                  child: Container(color: Colors.white10),
                ),
                Center(
                  child: Text(
                    'TẠP CHÍ\nGIÁO DỤC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Thông tin bên phải
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.issue.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Xuất bản: ${widget.issue.dateDisplay}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng số bài: ${_articles.length}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_articles.isNotEmpty) {
                            ReadingStateManager().show(
                              _articles.first,
                              widget.issue,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đang đọc số báo này...'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.playlist_add, size: 18),
                        label: const Text('Đọc số báo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9E1E1E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        // Mô phỏng tính năng lưu
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Đã lưu')));
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          color: Color(0xFF9E1E1E),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleItem(ArticleModel article, int index) {
    return InkWell(
      onTap: () {
        ReadingStateManager().show(article, widget.issue);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ArticleDetailScreen(article: article, issue: widget.issue),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9E1E1E),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Trang ${article.pageRange}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              article.author,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 'Chi tiết' button removed as the whole card is clickable
                if (article.pdfUrl != null)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleReaderScreen(
                            pdfUrl: article.pdfUrl!,
                            title: article.title,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 16,
                      color: Color(0xFF9E1E1E),
                    ),
                    label: const Text(
                      'PDF',
                      style: TextStyle(color: Color(0xFF9E1E1E)),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(60, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
