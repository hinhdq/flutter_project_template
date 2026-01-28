import 'package:flutter/material.dart';

class IssuesScreen extends StatelessWidget {
  const IssuesScreen({super.key});

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
                "Các Số Báo",
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
                (context, index) => _buildIssueCard(
                  context,
                  _issues[index],
                  index,
                ),
                childCount: _issues.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(BuildContext context, Issue issue, int index) {
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
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF9E1E1E).withOpacity(0.1),
                border: Border(
                  left: BorderSide(
                    color: Color(0xFF9E1E1E),
                    width: 4,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  issue.issueNumber,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9E1E1E),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ngày phát hành: ${issue.publishDate}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${issue.articleCount} bài viết",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Xem Chi Tiết",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final List<Issue> _issues = [
    Issue(
      issueNumber: "Số 5/2025",
      title: "Phát triển kỹ năng tư duy phê phán trong giáo dục",
      publishDate: "15/01/2025",
      articleCount: 8,
    ),
    Issue(
      issueNumber: "Số 4/2024",
      title: "Ứng dụng công nghệ AI trong học tập và giảng dạy",
      publishDate: "01/12/2024",
      articleCount: 10,
    ),
    Issue(
      issueNumber: "Số 3/2024",
      title: "Giáo dục bền vững và phát triển con người",
      publishDate: "15/09/2024",
      articleCount: 7,
    ),
    Issue(
      issueNumber: "Số 2/2024",
      title: "Đổi mới phương pháp giảng dạy ở bậc đại học",
      publishDate: "01/06/2024",
      articleCount: 9,
    ),
    Issue(
      issueNumber: "Số 1/2024",
      title: "Định hướng chính sách giáo dục 2024-2025",
      publishDate: "15/03/2024",
      articleCount: 11,
    ),
  ];
}

class Issue {
  final String issueNumber;
  final String title;
  final String publishDate;
  final int articleCount;

  Issue({
    required this.issueNumber,
    required this.title,
    required this.publishDate,
    required this.articleCount,
  });
}
