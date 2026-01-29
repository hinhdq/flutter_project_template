import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Thư viện giọng nói
import '../data/global_data.dart'; // Dữ liệu bài báo chung

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  // 1. Khởi tạo trình đọc giọng nói
  final FlutterTts flutterTts = FlutterTts();
  
  // Biến lưu vị trí bài đang đọc (-1 là không đọc bài nào)
  int _playingIndex = -1;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  // Cấu hình giọng đọc
  Future<void> _initTts() async {
    await flutterTts.setLanguage("vi-VN"); // Đặt tiếng Việt
    await flutterTts.setSpeechRate(0.5);   // Tốc độ đọc (0.0 - 1.0)
    await flutterTts.setVolume(1.0);       // Âm lượng
    await flutterTts.setPitch(1.0);        // Tông giọng

    // Khi đọc xong thì tự động tắt trạng thái Play
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _playingIndex = -1;
        });
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // Tắt giọng đọc khi thoát màn hình
    super.dispose();
  }

  // Hàm xử lý Bật/Tắt đọc
  Future<void> _togglePlay(int index) async {
    // Nếu đang đọc đúng bài này -> Dừng lại
    if (_playingIndex == index) {
      await flutterTts.stop();
      setState(() => _playingIndex = -1);
    } 
    // Nếu đang tắt hoặc đọc bài khác -> Đọc bài mới
    else {
      setState(() => _playingIndex = index);
      
      // Lấy dữ liệu bài báo tương ứng
      final article = allArticles[index];
      
      // Ghép Tiêu đề + Nội dung để đọc
      String textToRead = "Đang phát bài: ${article.title}. \n\n ${article.content}";
      
      await flutterTts.stop(); // Dừng bài cũ (nếu có)
      await flutterTts.speak(textToRead); // Đọc ngay
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildHeader(),
            const SizedBox(height: 10),
            
            // Danh sách bài báo (Lấy từ allArticles)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: allArticles.length,
                itemBuilder: (context, index) {
                  final article = allArticles[index];
                  final isPlaying = _playingIndex == index;

                  return _buildPodcastItem(
                    index: index,
                    title: article.title,
                    author: article.author,
                    isPlaying: isPlaying,
                  );
                },
              ),
            ),
            
            // Mini Player (Chỉ hiện khi đang đọc)
            if (_playingIndex != -1) _buildMiniPlayer(),
          ],
        ),
      ),
    );
  }

  // Widget Item: Một dòng bài báo
  Widget _buildPodcastItem({required int index, required String title, required String author, required bool isPlaying}) {
    return GestureDetector(
      onTap: () => _togglePlay(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPlaying ? const Color(0xFFFBE9E7) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: isPlaying ? const Color(0xFF9E1E1E) : Colors.grey.shade100, width: isPlaying ? 1.5 : 1),
        ),
        child: Row(
          children: [
            // Icon trạng thái (Sóng âm hoặc Tai nghe)
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: isPlaying ? Colors.white : const Color(0xFFFBE9E7), borderRadius: BorderRadius.circular(12)),
              child: Icon(
                isPlaying ? Icons.graphic_eq : Icons.headphones, 
                color: const Color(0xFF9E1E1E), 
                size: 28
              ),
            ),
            const SizedBox(width: 14),
            
            // Thông tin bài viết
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isPlaying ? const Color(0xFF9E1E1E) : Colors.black87, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.person, size: 14, color: Colors.grey.shade400), 
                    const SizedBox(width: 4), 
                    Expanded(child: Text(author, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis))
                  ])
                ],
              ),
            ),
            
            // Nút Play nhỏ
            Container(
              width: 36, height: 36, 
              decoration: const BoxDecoration(color: Color(0xFF9E1E1E), shape: BoxShape.circle), 
              child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 22)
            ),
          ],
        ),
      ),
    );
  }

  // Widget Mini Player: Thanh điều khiển dưới cùng
  Widget _buildMiniPlayer() {
    final currentArticle = allArticles[_playingIndex];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.mic, color: Colors.white, size: 20)), 
        const SizedBox(width: 12), 
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Đang đọc:', style: TextStyle(color: Colors.grey, fontSize: 10)), Text(currentArticle.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)])), 
        IconButton(icon: const Icon(Icons.pause_circle_filled, color: Colors.white, size: 32), onPressed: () => _togglePlay(_playingIndex)),
      ]),
    );
  }

  // Header chuẩn đồng bộ
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: [Container(width: 48, height: 48, padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [const Text('TẠP CHÍ GIÁO DỤC', style: TextStyle(color: Color(0xFF9E1E1E), fontWeight: FontWeight.w800, fontSize: 18, fontFamily: 'Serif', letterSpacing: 0.5)), const SizedBox(height: 2), Text('TẠP CHÍ LÍ LUẬN - KHOA HỌC GIÁO DỤC • BỘ GIÁO DỤC VÀ ĐÀO TẠO', style: TextStyle(color: Colors.blue[900], fontSize: 8.5, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis)])), const SizedBox(width: 8), const Icon(Icons.notifications_outlined, size: 28, color: Colors.black87)]),
    );
  }
}