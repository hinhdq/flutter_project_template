import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool hasViewAll;
  final String viewAllText;
  final VoidCallback? onViewAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.hasViewAll = false,
    this.viewAllText = 'Xem tất cả',
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFF9E1E1E), width: 4)),
            ),
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (hasViewAll)
            GestureDetector(
              onTap: onViewAllTap,
              child: Text(
                viewAllText,
                style: const TextStyle(
                  color: Color(0xFF9E1E1E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}