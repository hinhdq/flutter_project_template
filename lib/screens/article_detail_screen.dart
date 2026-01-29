import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng ngày tháng
import '../data/global_data.dart'; // Import kho dữ liệu để dùng danh sách 'savedArticles'

// Chuyển sang StatefulWidget để giao diện có thể thay đổi (đổi màu icon Bookmark)
class ArticleDetailScreen extends StatefulWidget {
  final Article article; // Nhận dữ liệu bài báo từ màn hình trước

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  // Biến trạng thái: Bài này đã lưu chưa?
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    // Khi màn hình vừa mở, kiểm tra ngay xem bài này có trong danh sách đã lưu chưa
    // Nếu tìm thấy id của bài này trong savedArticles -> isSaved = true
    isSaved = savedArticles.any((element) => element.id == widget.article.id);
  }

  // Hàm xử lý khi bấm nút Bookmark
  void _toggleSave() {
    setState(() {
      if (isSaved) {
        // Nếu đang lưu -> Xóa khỏi danh sách
        savedArticles.removeWhere((element) => element.id == widget.article.id);
        isSaved = false;
        
        // Hiện thông báo nhỏ bên dưới
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã bỏ lưu bài viết'), duration: Duration(seconds: 1)),
        );
      } else {
        // Nếu chưa lưu -> Thêm vào danh sách
        savedArticles.add(widget.article);
        isSaved = true;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu vào danh sách cá nhân'), duration: Duration(seconds: 1)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF9E1E1E);

    return Scaffold(
      backgroundColor: Colors.white,
      
      // 1. AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chi tiết bài viết',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // NÚT BOOKMARK ĐỘNG
          IconButton(
            onPressed: _toggleSave,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border, // Đổi icon: Đặc hoặc Rỗng
              color: isSaved ? brandColor : Colors.black87,     // Đổi màu: Đỏ hoặc Đen
              size: 26,
            ),
          ),
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black87), onPressed: () {}),
        ],
      ),
      
      // 2. Bottom Bar (Nút đọc PDF)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tải file PDF...')));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: brandColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Đọc toàn văn (PDF)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),

      // 3. Nội dung chính
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF757575), Color(0xFF424242)], 
                ),
              ),
              child: const Center(child: Icon(Icons.image, color: Colors.white54, size: 60)),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.article.category, // Dữ liệu từ model
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    widget.article.title, // Dữ liệu từ model
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.3),
                  ),
                  const SizedBox(height: 16),

                  // Metadata
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 18,
                        child: Icon(Icons.person, size: 20, color: Colors.grey.shade500),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.article.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          // Định dạng ngày tháng
                          Text(
                            'Ngày đăng: ${DateFormat('dd/MM/yyyy').format(widget.article.date)}', 
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tóm tắt
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: const Border(left: BorderSide(color: brandColor, width: 4)),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Tóm tắt:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                         SizedBox(height: 8),
                         Text('Bài viết phân tích thực trạng và xu hướng...', style: TextStyle(fontStyle: FontStyle.italic, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nội dung chi tiết
                  Text(
                    widget.article.content, // Dữ liệu từ model
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF333333)),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}