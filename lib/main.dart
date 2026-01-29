import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/issues_screen.dart';
import 'screens/podcast_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/article_detail_screen.dart';

import 'screens/article_reader_screen.dart';
import 'widgets/mini_reading_bar.dart';
import 'state/reading_state_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const MainApp(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _index = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const IssuesScreen(),
    const PodcastScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nội dung chính
          Padding(padding: EdgeInsets.only(bottom: 0), child: _screens[_index]),

          // Thanh phát thu nhỏ
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: ReadingStateManager(),
              builder: (context, _) {
                final manager = ReadingStateManager();
                if (!manager.isVisible || manager.currentArticle == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MiniReadingBar(
                      title: manager.currentArticle!.title,
                      subtitle: 'Trang ${manager.currentPage + 1}',
                      onTap: () {
                        final article = manager.currentArticle;
                        final issue = manager.currentIssue;

                        if (article != null) {
                          // Quay lại: Đóng trình đọc và về trang trước
                          if (article.pdfUrl != null) {
                            navigatorKey.currentState?.push(
                              MaterialPageRoute(
                                builder: (_) => ArticleReaderScreen(
                                  pdfUrl: article.pdfUrl!,
                                  title: article.title,
                                  issue:
                                      issue, // Truyền thông tin số báo mục lục
                                ),
                              ),
                            );
                          } else {
                            navigatorKey.currentState?.push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArticleDetailScreen(article: article),
                              ),
                            );
                          }
                        }
                      },
                      onClose: () => manager.hide(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color(0xFF9E1E1E),
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
