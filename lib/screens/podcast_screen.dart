import 'package:flutter/material.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Podcast (Đang phát triển)")),
      body: const Center(
        child: Text("Danh sách podcast sẽ hiển thị ở đây"),
      ),
    );
  }
}
