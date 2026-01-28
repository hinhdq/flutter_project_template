import 'package:flutter/material.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Nghe Podcast",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPodcastCard(
                  context,
                  _podcasts[index],
                  index,
                ),
                childCount: _podcasts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastCard(BuildContext context, Podcast podcast, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9E1E1E).withOpacity(0.1),
                    Color(0xFF9E1E1E).withOpacity(0.05),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.podcasts,
                  size: 80,
                  color: Color(0xFF9E1E1E),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF9E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      podcast.category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    podcast.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    podcast.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          podcast.author[0],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              podcast.author,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${podcast.duration} phút",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF9E1E1E),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                          splashRadius: 20,
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

  static final List<Podcast> _podcasts = [
    Podcast(
      title: "Phát triển kỹ năng giao tiếp cho học sinh thế kỷ 21",
      description:
          "Phân tích các phương pháp hiệu quả để phát triển kỹ năng giao tiếp của học sinh",
      author: "TS. Nguyễn Văn A",
      duration: 28,
      category: "Giáo dục",
    ),
    Podcast(
      title: "Ứng dụng công nghệ VR trong bài giảng Lịch Sử",
      description:
          "Cách sử dụng công nghệ thực tế ảo để tạo bài giảng lịch sử sinh động",
      author: "PGS. Trần Thị B",
      duration: 35,
      category: "Công nghệ",
    ),
    Podcast(
      title: "Tâm lý học ứng dụng trong quản lý lớp học",
      description:
          "Hiểu rõ tâm lý của học sinh để quản lý lớp học hiệu quả hơn",
      author: "TS. Phạm Minh C",
      duration: 32,
      category: "Tâm lý học",
    ),
    Podcast(
      title: "Đánh giá năng lực học sinh bằng phương pháp mới",
      description:
          "Khám phá các phương pháp đánh giá năng lực thay thế bài kiểm tra truyền thống",
      author: "PGS. Lê Hoàng D",
      duration: 40,
      category: "Đánh giá",
    ),
    Podcast(
      title: "Giáo dục thể chất cho sự phát triển toàn diện",
      description:
          "Tầm quan trọng của giáo dục thể chất trong sự phát triển toàn diện của học sinh",
      author: "TS. Vũ Nam E",
      duration: 26,
      category: "Thể dục",
    ),
  ];
}

class Podcast {
  final String title;
  final String description;
  final String author;
  final int duration; // in minutes
  final String category;

  Podcast({
    required this.title,
    required this.description,
    required this.author,
    required this.duration,
    required this.category,
  });
}
