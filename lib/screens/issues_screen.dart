import 'package:flutter/material.dart';

class IssuesScreen extends StatelessWidget {
  const IssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Header ĐÃ SỬA: Đồng bộ với Home
            _buildHeader(),
            const SizedBox(height: 16),
            
            // Nội dung chính: Lưới tạp chí
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  childAspectRatio: 0.72, 
                  crossAxisSpacing: 16, 
                  mainAxisSpacing: 16,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final int vol = 25 - index; 
                  final int issue = 10 - index; 
                  int month = 12 - index;
                  int year = 2025;
                  if (month <= 0) {
                    month = 12 + month;
                    year = 2024;
                  }
                  
                  return _buildIssueItem(
                    title: 'Tập $vol, Số $issue',
                    subtitle: 'Tháng $month/$year',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueItem({required String title, required String subtitle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- HEADER ĐÃ ĐƯỢC NÂNG CẤP ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo Box
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          
          // Text Box (Sửa dòng text phụ cho dài và đúng mẫu)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TẠP CHÍ GIÁO DỤC',
                  style: TextStyle(
                    color: Color(0xFF9E1E1E), 
                    fontWeight: FontWeight.w800, 
                    fontSize: 18,
                    fontFamily: 'Serif', 
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'TẠP CHÍ LÍ LUẬN - KHOA HỌC GIÁO DỤC • BỘ GIÁO DỤC VÀ ĐÀO TẠO',
                  style: TextStyle(
                    color: Colors.blue[900], 
                    fontSize: 8.5, 
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          const Icon(Icons.notifications_outlined, size: 28, color: Colors.black87),
        ],
      ),
    );
  }
}