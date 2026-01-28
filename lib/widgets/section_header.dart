import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool hasViewAll;
  final String viewAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.hasViewAll = false,
    this.viewAllText = 'Xem tất cả',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (hasViewAll)
            Text(
              viewAllText,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
