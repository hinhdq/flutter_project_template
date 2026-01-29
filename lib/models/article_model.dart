class ArticleModel {
  final String id;
  final String title;
  final String author;
  final String pageRange; // Ví dụ: "15-22"
  final String? abstract; // Tóm tắt
  final String? pdfUrl;
  final String category; // Chuyên mục: LÝ LUẬN, DẠY HỌC...
  final List<String> keywords;
  final List<String> references;
  final String? publishedDate;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.pageRange,
    this.category = 'Nghiên cứu chung',
    this.abstract,
    this.pdfUrl,
    this.keywords = const [],
    this.references = const [],
    this.publishedDate,
  });
}
