import 'package:flutter/material.dart';
import 'saved_articles_screen.dart'; // <--- NHỚ IMPORT FILE MỚI TẠO

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(),
              const SizedBox(height: 30),
              
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Cài đặt giao diện',
                onTap: () {},
              ),
              
              // --- PHẦN ĐÃ SỬA: Bấm vào chuyển sang màn hình Đã lưu ---
              _buildMenuItem(
                icon: Icons.bookmark_border,
                title: 'Bài viết đã lưu',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SavedArticlesScreen()),
                  );
                },
              ),
              // ---------------------------------------------------------

              _buildMenuItem(
                icon: Icons.history,
                title: 'Lịch sử đọc',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.notifications_none,
                title: 'Cài đặt thông báo',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Liên hệ',
                onTap: () {},
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 10),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Về Tạp chí Giáo dục',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.verified_user_outlined,
                title: 'Phiên bản 1.0.0',
                showArrow: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // (Giữ nguyên các hàm con _buildUserInfo và _buildMenuItem bên dưới...)
  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(radius: 32, backgroundColor: Colors.grey.shade200, child: Icon(Icons.person, size: 36, color: Colors.grey.shade500)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Khách', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFFBE9E7), borderRadius: BorderRadius.circular(20)),
              child: const Text('Đăng nhập ngay', style: TextStyle(color: Color(0xFF9E1E1E), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap, bool showArrow = true}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black54),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87))),
            if (showArrow) Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}