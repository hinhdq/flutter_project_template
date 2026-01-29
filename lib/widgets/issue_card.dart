import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;
  final VoidCallback? onTap;

  const IssueCard({super.key, required this.issue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Layout dạng cột: Hình ảnh ở trên, Thông tin ở dưới
        decoration: BoxDecoration(
          color: Colors
              .transparent, // Nền trong suốt để shadow của card con nổi bật
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Phần Bìa Tạp Chí (Giả lập 3D)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(
                        4,
                        4,
                      ), // Bóng đổ lệch sang phải tạo độ dày
                    ),
                  ],
                  // Gradient giả lập bìa sách bóng bẩy
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: issue.isSpecial
                        ? [
                            const Color(0xFF9E1E1E),
                            const Color(0xFF700000),
                          ] // Màu đỏ số đặc biệt
                        : [
                            Colors.blueGrey.shade700,
                            Colors.blueGrey.shade900,
                          ], // Màu mặc định
                  ),
                ),
                // Nội dung trên bìa
                child: Stack(
                  children: [
                    // Gáy sách (Bên trái)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border(
                            right: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Text trên bìa (Tạm thời vì chưa có ảnh thật)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TẠP CHÍ\nGIÁO DỤC',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Serif',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 1,
                              width: 40,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              issue.dateDisplay,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Badge "Số đặc biệt"
                    if (issue.isSpecial)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade700,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SỐ ĐẶC BIỆT',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 2. Thông tin phía dưới
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.fullTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${issue.articleCount} bài viết',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
