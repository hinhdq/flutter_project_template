// lib/data/global_data.dart

// 1. CLASS MODEL: Định nghĩa cấu trúc một bài báo
class Article {
  final String id;
  final String title;
  final String category;
  final String author;
  final DateTime date;
  final String imageUrl;
  final String content; // Nội dung chi tiết (Dùng để đọc Podcast)

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    this.imageUrl = 'assets/images/placeholder.png', // Ảnh mặc định nếu thiếu
    required this.content,
  });
}

// 2. BIẾN TOÀN CỤC: Danh sách các bài đã lưu (Bookmark)
// Ban đầu danh sách này rỗng. Khi người dùng bấm lưu, ta sẽ thêm bài vào đây.
List<Article> savedArticles = [];

// 3. DỮ LIỆU MẪU (MOCK DATA): Danh sách tất cả bài báo trong App
// Nội dung (content) được viết dài một chút để test tính năng đọc Podcast sau này.
final List<Article> allArticles = [
  Article(
    id: '1',
    category: 'Dạy học',
    title: 'Dạy học tích hợp trong giáo dục hiện đại: Phân tích xu hướng nghiên cứu',
    author: 'TS. Lê Thị Hồng Chi',
    date: DateTime(2025, 12, 05),
    content: 
      'Dạy học tích hợp là một quan điểm sư phạm hiện đại, nhằm hình thành và phát triển năng lực người học thông qua việc vận dụng kiến thức, kỹ năng của nhiều môn học khác nhau để giải quyết các vấn đề thực tiễn. \n\n'
      'Trong bối cảnh chuyển đổi số, dạy học tích hợp không chỉ dừng lại ở việc lồng ghép nội dung mà còn đòi hỏi sự kết hợp nhuần nhuyễn giữa phương pháp sư phạm truyền thống và công nghệ hiện đại. Các nghiên cứu gần đây cho thấy học sinh học theo phương pháp này có khả năng tư duy phản biện tốt hơn 30% so với phương pháp đơn môn truyền thống. \n\n'
      'Tuy nhiên, thách thức lớn nhất hiện nay là năng lực của đội ngũ giáo viên trong việc thiết kế các chủ đề tích hợp sao cho tự nhiên, không gượng ép và đảm bảo chuẩn kiến thức kỹ năng của từng môn học thành phần.',
  ),
  Article(
    id: '2',
    category: 'Quản lý',
    title: 'Nâng cao chất lượng đội ngũ giảng viên tại các trường đại học sư phạm',
    author: 'PGS.TS Nguyễn Văn An',
    date: DateTime(2025, 11, 20),
    content: 
      'Chất lượng đội ngũ giảng viên là yếu tố then chốt quyết định chất lượng đào tạo của các trường đại học sư phạm. Trong kỷ nguyên 4.0, vai trò của giảng viên đã chuyển dịch từ người truyền thụ kiến thức sang người hướng dẫn, định hướng và truyền cảm hứng. \n\n'
      'Bài viết này đề xuất ba giải pháp trọng tâm: Thứ nhất, tăng cường bồi dưỡng năng lực công nghệ thông tin và ngoại ngữ. Thứ hai, đổi mới cơ chế đánh giá giảng viên dựa trên sản phẩm khoa học và phản hồi của người học. Thứ ba, tạo môi trường làm việc cởi mở, khuyến khích sáng tạo và hợp tác quốc tế. \n\n'
      'Thực tế cho thấy, các trường đại học áp dụng mô hình quản trị tiên tiến đã thu hút được nhiều nhân tài và nâng cao đáng kể vị thế trên các bảng xếp hạng giáo dục khu vực.',
  ),
  Article(
    id: '3',
    category: 'Lý luận',
    title: 'Vận dụng tư tưởng Hồ Chí Minh về giáo dục vào đổi mới căn bản toàn diện',
    author: 'ThS. Trần Văn Bình',
    date: DateTime(2025, 10, 15),
    content: 
      'Tư tưởng Hồ Chí Minh về giáo dục là một di sản tinh thần vô giá, là kim chỉ nam cho nền giáo dục cách mạng Việt Nam. Người luôn nhấn mạnh mục tiêu của giáo dục là đào tạo những con người "vừa hồng vừa chuyên", có đức có tài để phụng sự Tổ quốc. \n\n'
      'Vận dụng tư tưởng của Người vào công cuộc đổi mới căn bản, toàn diện giáo dục hiện nay, chúng ta cần chú trọng giáo dục đạo đức, lối sống, lý tưởng cách mạng cho thế hệ trẻ. Giáo dục không chỉ là dạy chữ mà còn là dạy người, dạy nghề. \n\n'
      'Đặc biệt, phương châm "Học đi đôi với hành, lý luận gắn liền với thực tiễn" của Bác vẫn còn nguyên giá trị thời sự, đòi hỏi nhà trường phải gắn kết chặt chẽ với gia đình và xã hội.',
  ),
  Article(
    id: '4',
    category: 'Tâm lý',
    title: 'Sức khỏe tinh thần của học sinh trung học phổ thông sau đại dịch',
    author: 'TS. Phạm Minh Tâm',
    date: DateTime(2025, 09, 10),
    content: 
      'Sau đại dịch COVID-19, vấn đề sức khỏe tinh thần học đường đang trở nên cấp thiết hơn bao giờ hết. Tỷ lệ học sinh gặp các vấn đề về lo âu, căng thẳng và trầm cảm có xu hướng gia tăng. \n\n'
      'Nguyên nhân chủ yếu đến từ áp lực học tập, sự mất kết nối xã hội trong thời gian dài giãn cách và những thay đổi trong thói quen sinh hoạt. Nhiều em cảm thấy cô đơn, lạc lõng và thiếu động lực học tập khi quay trở lại trường học trực tiếp. \n\n'
      'Giải pháp cấp bách là các nhà trường cần thành lập phòng tham vấn tâm lý học đường hoạt động thực chất, đồng thời giáo viên chủ nhiệm cần quan tâm sâu sát hơn đến diễn biến tâm lý của từng học sinh để có biện pháp hỗ trợ kịp thời.',
  ),
  Article(
    id: '5',
    category: 'Dạy học',
    title: 'Ứng dụng AI trong việc soạn bài giảng điện tử: Thực trạng và giải pháp',
    author: 'ThS. Đào Công Nghệ',
    date: DateTime(2025, 12, 01),
    content: 
      'Trí tuệ nhân tạo (AI) đang mở ra những cơ hội chưa từng có trong việc hỗ trợ giáo viên soạn bài giảng. Các công cụ AI có thể giúp tìm kiếm tài liệu, thiết kế slide, tạo câu hỏi trắc nghiệm chỉ trong vài giây. \n\n'
      'Tuy nhiên, việc lạm dụng AI cũng tiềm ẩn nguy cơ khiến bài giảng trở nên khô cứng, thiếu cảm xúc và sự tương tác thực tế. Giáo viên cần coi AI là công cụ hỗ trợ đắc lực chứ không thể thay thế hoàn toàn vai trò của người thầy. \n\n'
      'Bài viết giới thiệu quy trình 5 bước ứng dụng AI hiệu quả để tạo ra bài giảng sinh động, hấp dẫn mà vẫn giữ được "chất" riêng của người giáo viên.',
  ),
];