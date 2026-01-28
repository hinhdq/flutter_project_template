import 'package:flutter/material.dart';
// Import 4 màn hình vừa tạo
import 'screens/home_screen.dart';
import 'screens/issues_screen.dart';
import 'screens/podcast_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _index = 0;
  // Danh sách 4 màn hình
  final List<Widget> _screens = [
    const HomeScreen(),
    const IssuesScreen(),
    const PodcastScreen(),
    const LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Số báo'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Podcast'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}