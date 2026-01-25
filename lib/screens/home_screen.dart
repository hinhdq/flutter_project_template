import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trang chủ (Đang phát triển)")),
      body: const Center(
        child: Text("Team A sẽ code giao diện Home ở đây"),
      ),
    );
  }
}