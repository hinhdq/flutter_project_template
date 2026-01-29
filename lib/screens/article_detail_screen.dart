import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../repositories/issue_repository.dart';
import 'article_reader_screen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final ArticleModel article;
  final dynamic issue; // truyền thông tin số báo để điều hướng ngược lại

  const ArticleDetailScreen({super.key, required this.article, this.issue});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final IssueRepository _repository = globalIssueRepository;
  late Future<ArticleModel> _detailFuture;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    super.initState();
    // id chi tiết bài báo
    _detailFuture = _repository.getArticleDetail(widget.article.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Chi tiết bài báo',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<ArticleModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final article = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // card danh mục
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    article.category.toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // title
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // tác giả
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        article.author,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                if (article.publishedDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        article.publishedDate!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],

                const Divider(height: 32),

                const Divider(height: 32),

                // tóm tắt
                _buildSectionTitle('Tóm tắt'),
                const SizedBox(height: 8),
                Text(
                  article.abstract ?? 'Đang cập nhật...',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 24),

                // từ khóa
                if (article.keywords.isNotEmpty) ...[
                  _buildSectionTitle('Từ khóa'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: article.keywords
                        .map(
                          (k) => Chip(
                            label: Text(k),
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(color: Colors.grey.shade800),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // tài liệu tham khảo
                if (article.references.isNotEmpty) ...[
                  _buildSectionTitle('Tài liệu tham khảo'),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _isExpanded
                        ? article.references.length
                        : (article.references.length > 3
                              ? 3
                              : article.references.length),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '[${index + 1}] ${article.references[index]}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                  if (article.references.length > 3)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(_isExpanded ? 'Thu gọn' : 'Xem thêm'),
                    ),
                ],

                const SizedBox(height: 24),

                // Inline PDF Button removed as requested
                const SizedBox(height: 80), // Bottom padding for FAB
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<ArticleModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.pdfUrl == null) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleReaderScreen(
                        pdfUrl: snapshot.data!.pdfUrl!,
                        title: snapshot.data!.title,
                        issue: widget.issue,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.description_outlined),
                label: const Text('ĐỌC TÀI LIỆU'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9E1E1E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF9E1E1E),
      ),
    );
  }
}
