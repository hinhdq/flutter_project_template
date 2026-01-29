import 'package:flutter/material.dart';

class MiniReadingBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const MiniReadingBar({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF9E1E1E),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.article, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subtitle ?? 'Đang đọc',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {}, // Play/Pause placeholder
              icon: const Icon(Icons.play_arrow_rounded),
              color: Colors.black87,
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: Colors.grey,
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
