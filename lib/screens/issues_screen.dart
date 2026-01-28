import 'package:flutter/material.dart';

class IssuesScreen extends StatelessWidget {
  const IssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Số báo (Đang phát triển)")),
      body: const Center(
        child: Text("Danh sách các số báo sẽ hiển thị ở đây"),
      ),
    );
  }
}
