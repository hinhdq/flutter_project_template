import 'package:flutter/material.dart';
// Import các widget bạn vừa tạo
import '../widgets/section_header.dart';
import '../widgets/article_card.dart';
import 'issues_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Đặt nền trắng chuẩn
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF9E1E1E),
        shape: const CircleBorder(), // Bo tròn nút Home cho đẹp
        child: const Icon(Icons.home_filled, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. Header (Logo + Tên)
              _buildHeader(),

              const SizedBox(height: 16),

              // 2. Search Bar (Đã tinh chỉnh)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (value) {
                    // Xử lý tìm kiếm sau này
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm bài viết...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),

                    filled: true,
                    fillColor: Colors.grey.shade100, // Màu nền xám nhẹ hiện đại

                    contentPadding: const EdgeInsets.symmetric(vertical: 12),

                    // Viền khi chưa bấm vào
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),

                    // Viền khi bấm vào (Màu đỏ)
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFF9E1E1E)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Danh mục (Tabs)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildChip('Tất cả', isActive: true),
                    _buildChip('Lý luận'),
                    _buildChip('Dạy học'),
                    _buildChip('Quản lý'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4. Mục: Số mới phát hành
              SectionHeader(
                title: 'Số mới phát hành',
                hasViewAll: true,
                onViewAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IssuesScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildFeaturedCard(),

              const SizedBox(height: 24),

              // 5. Mục: Bài báo Khoa học
              const SectionHeader(
                title: 'Bài báo Khoa học',
                hasViewAll: true,
                viewAllText: 'Mới nhất',
              ),

              // Danh sách bài báo
              const ArticleCard(
                category: 'DẠY HỌC',
                title:
                    'Dạy học tích hợp trong giáo dục hiện đại: Phân tích xu hướng nghiên cứu',
                author: 'Lê Thị Hồng Chi',
              ),
              const ArticleCard(
                category: 'QUẢN LÝ',
                title:
                    'Nâng cao chất lượng đội ngũ giảng viên tại các trường đại học sư phạm',
                author: 'Nguyễn Văn An',
              ),
              const ArticleCard(
                category: 'LÝ LUẬN',
                title:
                    'Chuyển đổi số trong quản lý giáo dục đại học: Thực trạng và giải pháp',
                author: 'Trần Văn B',
              ),

              const SizedBox(height: 30),

              // --- 6. PHẦN MỚI THÊM: BANNER ĐỐI TÁC ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'ĐỐI TÁC ĐỒNG HÀNH',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildPartnerLogo('Bộ GD&ĐT', Colors.blue.shade50),
                    _buildPartnerLogo('NXB Giáo Dục', Colors.green.shade50),
                    _buildPartnerLogo('VJE', Colors.red.shade50),
                    _buildPartnerLogo('UNESCO', Colors.indigo.shade50),
                    _buildPartnerLogo('UNICEF', Colors.cyan.shade50),
                  ],
                ),
              ),

              const SizedBox(height: 100), // Khoảng trống cuối cùng
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC WIDGET CON ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TẠP CHÍ GIÁO DỤC',
                  style: TextStyle(
                    color: Color(0xFF9E1E1E),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Serif',
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'BỘ GIÁO DỤC VÀ ĐÀO TẠO',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade50,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 26,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        backgroundColor: isActive ? const Color(0xFF9E1E1E) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isActive
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF505050), Color(0xFF202020)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9E1E1E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'NỔI BẬT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Quy trình đào tạo gắn lí thuyết với thực hành trong kỷ nguyên số',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con mới để hiển thị Logo đối tác
  Widget _buildPartnerLogo(String name, Color bgColor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
