class IssueModel {
  final String id;
  final String title;
  final String volume; // Tập
  final int number; // Số
  final int month;
  final int year;
  final String? imageUrl;
  final int articleCount;
  final bool isSpecial; // Số đặc biệt nếu có

  const IssueModel({
    required this.id,
    required this.title,
    required this.volume,
    required this.number,
    required this.month,
    required this.year,
    this.imageUrl,
    this.articleCount = 0,
    this.isSpecial = false,
  });

  // Getter để hiển thị tên đầy đủ đẹp mắt
  String get fullTitle => 'Tập $volume, Số $number';
  String get dateDisplay => 'Tháng $month/$year';
}
