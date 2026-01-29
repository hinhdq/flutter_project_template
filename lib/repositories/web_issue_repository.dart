import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import '../models/issue_model.dart';
import '../models/article_model.dart';
import 'issue_repository.dart';

class WebIssueRepository implements IssueRepository {
  final String _baseUrl = 'https://tcgd.tapchigiaoduc.edu.vn/index.php/tapchi';

  @override
  Future<List<int>> getAvailableYears() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/issue/archive'));
      if (response.statusCode != 200) return [2025, 2024, 2023, 2022];

      var document = parser.parse(response.body);
      List<int> years = [];
      var headers = document.querySelectorAll('h2, h3, h4');

      for (var header in headers) {
        final text = header.text.trim();
        if (text.length == 4 && int.tryParse(text) != null) {
          years.add(int.parse(text));
        }
      }

      if (years.isEmpty) {
        return [2025, 2024, 2023, 2022];
      }

      // Sort descending
      years.sort((a, b) => b.compareTo(a));
      return years.toSet().toList(); // Unique
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing years: $e');
      }
      return [2025, 2024, 2023, 2022];
    }
  }

  @override
  Future<List<IssueModel>> getIssuesByYear(int year) async {
    List<IssueModel> issues = [];
    int page = 1;
    bool keepFetching = true;

    // Lặp để lấy nhiều trang (sai)
    while (keepFetching && page <= 5) {
      try {
        String url = '$_baseUrl/issue/archive';
        if (page > 1) {
          url += '?issuesPage=$page';
        }

        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          keepFetching = false;
          break;
        }

        var document = parser.parse(response.body);

        // Selector cho tóm tắt số báo
        var issueElements = document.querySelectorAll('.obj_issue_summary');

        if (issueElements.isEmpty) {
          // Selector dự phòng cho giao diện cũ
          issueElements = document.querySelectorAll('ul.issues_archive li');
        }

        if (issueElements.isEmpty) {
          keepFetching = false;
          break;
        }

        // bool foundAnyInThisYear = false; // Removed unused variable

        for (var element in issueElements) {
          var titleLink =
              element.querySelector('.title') ??
              element.querySelector('a.title');

          if (titleLink != null && !titleLink.attributes.containsKey('href')) {
            titleLink = titleLink.querySelector('a');
          }

          if (titleLink == null) continue;

          String rawTitle = titleLink.text.trim();
          String href = titleLink.attributes['href'] ?? '';
          String id = href.split('/').last;

          // Lọc theo năm
          bool matchYear = rawTitle.contains(year.toString());

          if (!matchYear) {
            continue;
          }

          // foundAnyInThisYear = true; // Removed unused

          // Parse Metadata
          String volume = 'NA';
          int number = 0;
          int month = 1;

          final volMatch = RegExp(
            r'(?:Vol\.|Tập)\s*(\d+)',
          ).firstMatch(rawTitle);
          if (volMatch != null) volume = volMatch.group(1)!;

          final numMatch = RegExp(
            r'(?:No\.|Số)(?:[^0-9]*?)(\d+)',
            caseSensitive: false,
          ).firstMatch(rawTitle);
          if (numMatch != null) number = int.tryParse(numMatch.group(1)!) ?? 0;

          // Month parsing
          final monthMatch = RegExp(
            r'(?:tháng|month)\s*(\d+)',
            caseSensitive: false,
          ).firstMatch(rawTitle);
          if (monthMatch != null) {
            month = int.tryParse(monthMatch.group(1)!) ?? 1;
          }

          bool isSpecial =
              rawTitle.toLowerCase().contains('đặc biệt') ||
              rawTitle.toLowerCase().contains('special');

          String imageUrl =
              'https://tcgd.tapchigiaoduc.edu.vn/public/site/images/admin/tcgd_logo.png';

          var coverImg = element.querySelector('.obj_cover_image img');
          if (coverImg != null) {
            imageUrl = coverImg.attributes['src'] ?? imageUrl;
          }

          if (!issues.any((i) => i.id == id)) {
            issues.add(
              IssueModel(
                id: id,
                title: rawTitle,
                volume: volume,
                number: number,
                month: month,
                year: year,
                imageUrl: imageUrl,
                articleCount: 10,
                isSpecial: isSpecial,
              ),
            );
          }
        }
        page++;
      } catch (e) {
        if (kDebugMode) {
          print('Error scraping issues page $page: $e');
        }
        keepFetching = false;
      }
    }

    return issues;
  }

  @override
  Future<List<ArticleModel>> getArticlesByIssueId(String issueId) async {
    try {
      final url = '$_baseUrl/issue/view/$issueId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return [];

      var document = parser.parse(response.body);
      List<ArticleModel> articles = [];

      var articleElements = document.querySelectorAll('.obj_article_summary');

      for (var element in articleElements) {
        var titleEl =
            element.querySelector('h3.title a') ??
            element.querySelector('.title a');
        String title = titleEl?.text.trim() ?? 'No Title';
        String link = titleEl?.attributes['href'] ?? '';
        String articleId = link.isNotEmpty ? link : UniqueKey().toString();

        var authorEl = element.querySelector('.authors');
        String author = authorEl?.text.trim() ?? '';
        author = author.replaceAll(RegExp(r'\s+'), ' ');

        var pageEl = element.querySelector('.pages');
        String pageRange = pageEl?.text.trim() ?? '';

        var pdfEl =
            element.querySelector('a.obj_galley_link.pdf') ??
            element.querySelector('a.pdf') ??
            element.querySelector('a.file'); // Fallback
        if (pdfEl == null) {
          var links = element.querySelectorAll('a');
          for (var link in links) {
            if (link.text.toLowerCase().contains('pdf')) {
              pdfEl = link;
              break;
            }
          }
        }

        String? pdfUrl = pdfEl?.attributes['href'];
        String category = "Nghiên cứu";
        articles.add(
          ArticleModel(
            id: articleId,
            title: title,
            author: author,
            pageRange: pageRange,
            pdfUrl: pdfUrl,
            category: category,
          ),
        );
      }

      return articles;
    } catch (e) {
      if (kDebugMode) {
        print('Error scraping articles: $e');
      }
      return [];
    }
  }

  @override
  Future<ArticleModel> getArticleDetail(String articleUrl) async {
    try {
      String url = articleUrl;
      if (!url.startsWith('http')) {
        if (RegExp(r'^\d+$').hasMatch(url)) {
          url = '$_baseUrl/article/view/$url';
        } else {}
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load article');
      }
      var document = parser.parse(response.body);
      String title =
          document.querySelector('h1.page_title')?.text.trim() ?? 'No Title';
      String author = document.querySelector('ul.authors')?.text.trim() ?? '';
      if (author.isEmpty) {
        author = document.querySelector('.authors')?.text.trim() ?? '';
      }
      author = author.replaceAll(RegExp(r'\s+'), ' ');
      String? abstractText = document
          .querySelector('.item.abstract')
          ?.text
          .trim();
      //  <section class="item abstract"> <h2 class="label">Tóm tắt</h2> <p>...</p> </section>
      if (abstractText != null) {
        abstractText = abstractText.replaceAll(
          RegExp(r'^Tóm tắt\s*', caseSensitive: false),
          '',
        );
      }
      // <section class="item keywords"> <span class="value">...</span>
      List<String> keywords = [];
      var keywordEl = document.querySelector('.item.keywords .value');
      if (keywordEl != null) {
        keywords = keywordEl.text.split(',').map((e) => e.trim()).toList();
      }
      // <section class="item references">
      List<String> references = [];
      var refEl = document.querySelector('.item.references .value');
      if (refEl != null) {
        references = refEl.text
            .split(RegExp(r'\n+'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      // <div class="date-published"> ... </div>
      String? publishedDate = document
          .querySelector('.published .value')
          ?.text
          .trim();

      // PDF Url
      String? pdfUrl;
      var pdfLink =
          document.querySelector('a.obj_galley_link.pdf') ??
          document.querySelector('a.pdf') ??
          document.querySelector('a.file');
      if (pdfLink == null) {
        var links = document.querySelectorAll('a');
        for (var link in links) {
          String linkText = link.text.toLowerCase();
          if (linkText.contains('pdf') || linkText.contains('toàn văn')) {
            pdfLink = link;
            break;
          }
        }
      }

      if (pdfLink != null) {
        pdfUrl = pdfLink.attributes['href'];
      }
      //metadata
      return ArticleModel(
        id: articleUrl,
        title: title,
        author: author,
        pageRange: '',
        abstract: abstractText,
        keywords: keywords,
        references: references,
        publishedDate: publishedDate,
        pdfUrl: pdfUrl,
        category: 'Nghiên cứu', // Placeholder
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing article detail: $e');
      }
      return ArticleModel(
        id: articleUrl,
        title: 'Lỗi tải dữ liệu',
        author: '',
        pageRange: '',
        abstract: 'Không thể tải nội dung chi tiết. $e',
      );
    }
  }
}
