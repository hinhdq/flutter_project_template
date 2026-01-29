import '../models/issue_model.dart';
import '../models/article_model.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'dart:async';

abstract class IssueRepository {
  Future<List<int>> getAvailableYears();
  Future<List<IssueModel>> getIssuesByYear(int year);
  Future<List<ArticleModel>> getArticlesByIssueId(String issueId);
  Future<ArticleModel> getArticleDetail(String articleUrl);
}

class MockIssueRepository implements IssueRepository {
  @override
  Future<List<int>> getAvailableYears() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [2025, 2024, 2023];
  }

  @override
  Future<List<IssueModel>> getIssuesByYear(int year) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (year == 2025) {
      return [
        IssueModel(
          id: '2025_special_10',
          title: 'Tập 25, số đặc biệt 10 (tháng 11/2025)',
          volume: '25',
          number: 10,
          month: 11,
          year: 2025,
          articleCount: 15,
          isSpecial: true,
          imageUrl:
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png',
        ),
        IssueModel(
          id: '2025_24',
          title: 'Tập 25, số 24 (tháng 12/2025)',
          volume: '25',
          number: 24,
          month: 12,
          year: 2025,
          articleCount: 12,
          imageUrl:
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png',
        ),
        IssueModel(
          id: '2025_23',
          title: 'Tập 25, số 23 (tháng 12/2025)',
          volume: '25',
          number: 23,
          month: 12,
          year: 2025,
          articleCount: 12,
          imageUrl:
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png',
        ),
        IssueModel(
          id: '2025_special_9',
          title: 'Tập 25, số đặc biệt 9 (tháng 10/2025)',
          volume: '25',
          number: 9,
          month: 10,
          year: 2025,
          articleCount: 14,
          isSpecial: true,
          imageUrl:
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png',
        ),
      ];
    } else if (year == 2024) {
      return List.generate(
        12,
        (index) => IssueModel(
          id: '2024_${12 - index}',
          title: 'Tập 24, số ${12 - index} (tháng ${12 - index}/2024)',
          volume: '24',
          number: 12 - index,
          month: 12 - index,
          year: 2024,
          articleCount: 10,
          imageUrl:
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png',
        ),
      );
    } else if (year == 2023) {
      return List.generate(
        10,
        (index) => IssueModel(
          id: '2023_${10 - index}',
          title: 'Tập 23, số ${10 - index} (tháng ${10 - index}/2023)',
          volume: '23',
          number: 10 - index,
          month: 10 - index,
          year: 2023,
          articleCount: 8,
          imageUrl:
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png',
        ),
      );
    }

    return [];
  }

  @override
  Future<List<ArticleModel>> getArticlesByIssueId(String issueId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Sample PDF URL
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

    return [
      ArticleModel(
        id: '${issueId}_1',
        category: 'LÝ LUẬN',
        title:
            'Đề xuất cách thức đánh giá năng lực sáng tạo trong dạy học Ngữ Văn',
        author: 'Nguyễn Văn An, Trần Thị B',
        pageRange: '03-10',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_01.pdf',
      ),
      ArticleModel(
        id: '${issueId}_2',
        category: 'LÝ LUẬN',
        title:
            'Đề xuất một số giải pháp xây dựng nền giáo dục Việt Nam hiện đại',
        author: 'Lê Hoàng C',
        pageRange: '11-18',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_02.pdf',
      ),
      ArticleModel(
        id: '${issueId}_3',
        category: 'ĐÁNH GIÁ',
        title:
            'Bộ tiêu chí đánh giá học phần tại trường ĐH Ngoại Thương: So sánh độ tin cậy',
        author: 'Phạm Thị D',
        pageRange: '19-25',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_03.pdf',
      ),
      ArticleModel(
        id: '${issueId}_4',
        category: 'DẠY HỌC',
        title:
            'Cấu trúc đề thi tuyển sinh vào lớp 10 công lập môn Ngữ Văn năm 2024-2025',
        author: 'Đỗ Văn E',
        pageRange: '26-32',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_04.pdf',
      ),
      ArticleModel(
        id: '${issueId}_5',
        category: 'QUẢN LÝ',
        title:
            'Khám phá trải nghiệm học tập với trò chơi học tập trong giảng dạy QTKD',
        author: 'Ngô Thị F',
        pageRange: '33-40',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_05.pdf',
      ),
      ArticleModel(
        id: '${issueId}_6',
        category: 'QUỐC TẾ',
        title:
            'Kinh nghiệm phát triển giáo dục STEM tại một số quốc gia Đông Nam Á',
        author: 'John Smith, Nguyen Van G',
        pageRange: '41-48',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_06.pdf',
      ),
    ];
  }

  @override
  @override
  Future<ArticleModel> getArticleDetail(String articleUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (articleUrl.endsWith('_1')) {
      return const ArticleModel(
        id: 'mock_detail_1',
        category: 'LÝ LUẬN',
        title:
            'Đề xuất cách thức đánh giá năng lực sáng tạo trong dạy học Ngữ Văn',
        author: 'Nguyễn Văn An, Trần Thị B',
        pageRange: '03-10',
        abstract:
            'Bài viết phân tích thực trạng và đề xuất quy trình đánh giá năng lực sáng tạo...',
        keywords: ['Sáng tạo', 'Ngữ văn', 'Đánh giá'],
        references: ['Tài liệu 1', 'Tài liệu 2'],
        publishedDate: '2025-01-15',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_01.pdf',
      );
    }
    if (articleUrl.endsWith('_2')) {
      return const ArticleModel(
        id: 'mock_detail_2',
        category: 'LÝ LUẬN',
        title:
            'Đề xuất một số giải pháp xây dựng nền giáo dục Việt Nam hiện đại',
        author: 'Lê Hoàng C',
        pageRange: '11-18',
        abstract: 'Nghiên cứu đề xuất các giải pháp chiến lược cho giáo dục...',
        keywords: ['Giáo dục hiện đại', 'Giải pháp', 'Chiến lược'],
        references: ['Tài liệu A', 'Tài liệu B'],
        publishedDate: '2025-01-15',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_02.pdf',
      );
    }
    if (articleUrl.endsWith('_3')) {
      return const ArticleModel(
        id: 'mock_detail_3',
        category: 'ĐÁNH GIÁ',
        title:
            'Bộ tiêu chí đánh giá học phần tại trường ĐH Ngoại Thương: So sánh độ tin cậy',
        author: 'Phạm Thị D',
        pageRange: '19-25',
        abstract: 'So sánh độ tin cậy của bộ tiêu chí đánh giá...',
        keywords: ['Đánh giá', 'ĐH Ngoại Thương', 'Tin cậy'],
        references: ['Tài liệu X', 'Tài liệu Y'],
        publishedDate: '2025-01-15',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_03.pdf',
      );
    }
    if (articleUrl.endsWith('_4')) {
      return const ArticleModel(
        id: 'mock_detail_4',
        category: 'DẠY HỌC',
        title:
            'Cấu trúc đề thi tuyển sinh vào lớp 10 công lập môn Ngữ Văn năm 2024-2025',
        author: 'Đỗ Văn E',
        pageRange: '26-32',
        abstract: 'Phân tích cấu trúc đề thi tuyển sinh lớp 10...',
        keywords: ['Tuyển sinh', 'Lớp 10', 'Ngữ Văn'],
        references: ['Đề thi 2024', 'Đề thi 2023'],
        publishedDate: '2025-01-15',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_04.pdf',
      );
    }
    if (articleUrl.endsWith('_5')) {
      return const ArticleModel(
        id: 'mock_detail_5',
        category: 'QUẢN LÝ',
        title:
            'Khám phá trải nghiệm học tập với trò chơi học tập trong giảng dạy QTKD',
        author: 'Ngô Thị F',
        pageRange: '33-40',
        abstract:
            'Nghiên cứu về Gamification trong giảng dạy Quản trị kinh doanh...',
        keywords: ['Gamification', 'QTKD', 'Trò chơi học tập'],
        references: ['Game-based learning', 'Edu tech'],
        publishedDate: '2025-01-15',
        pdfUrl: 'asset:///assets/pdfs/tap25_so24/article_05.pdf',
      );
    }

    // Default sample for others
    return const ArticleModel(
      id: 'mock_detail',
      category: 'NGHIÊN CỨU',
      title:
          'Chuyển đổi số trong quản lý giáo dục đại học: Xu thế tất yếu và định hướng giải pháp',
      author: 'Nguyễn Văn An, Trần Thị B',
      pageRange: '03-10',
      abstract:
          'Bài viết phân tích thực trạng chuyển đổi số tại các cơ sở giáo dục đại học Việt Nam, từ đó đề xuất các giải pháp mang tính chiến lược nhằm nâng cao hiệu quả quản lý và chất lượng đào tạo trong bối cảnh cuộc Cách mạng công nghiệp 4.0.',
      keywords: ['Chuyển đổi số', 'Quản lý giáo dục', 'Đại học', 'Chiến lược'],
      references: [
        'Bộ Giáo dục và Đào tạo (2020). Đề án chuyển đổi số ngành Giáo dục.',
        'Nguyễn Hữu Độ (2019). Giáo dục 4.0: Cơ hội và thách thức.',
        'Smith, J. (2018). Digital Transformation in Higher Education.',
      ],
      publishedDate: '2025-01-15',
      pdfUrl:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    );
  }
}

class CachedIssueRepository implements IssueRepository {
  final IssueRepository _inner;

  // ignore: unused_field
  static final Map<int, List<IssueModel>> _issuesCache = {};
  // ignore: unused_field
  static final Map<String, List<ArticleModel>> _articlesCache = {};
  // ignore: unused_field
  static final Map<String, ArticleModel> _articleDetailCache = {};

  CachedIssueRepository(this._inner);

  @override
  Future<List<int>> getAvailableYears() {
    // Usually fast enough, but can verify if needed
    return _inner.getAvailableYears();
  }

  @override
  Future<List<IssueModel>> getIssuesByYear(int year) async {
    if (_issuesCache.containsKey(year)) {
      debugPrint('Fetching issues for $year from CACHE');
      return _issuesCache[year]!;
    }
    final result = await _inner.getIssuesByYear(year);
    _issuesCache[year] = result;
    return result;
  }

  @override
  Future<List<ArticleModel>> getArticlesByIssueId(String issueId) async {
    if (_articlesCache.containsKey(issueId)) {
      debugPrint('Fetching articles for $issueId from CACHE');
      return _articlesCache[issueId]!;
    }
    final result = await _inner.getArticlesByIssueId(issueId);
    _articlesCache[issueId] = result;
    return result;
  }

  @override
  Future<ArticleModel> getArticleDetail(String articleUrl) async {
    if (_articleDetailCache.containsKey(articleUrl)) {
      return _articleDetailCache[articleUrl]!;
    }
    final result = await _inner.getArticleDetail(articleUrl);
    _articleDetailCache[articleUrl] = result;
    return result;
  }
}

final IssueRepository globalIssueRepository = CachedIssueRepository(
  MockIssueRepository(),
);
