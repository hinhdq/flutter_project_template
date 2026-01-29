import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../repositories/issue_repository.dart';
import '../widgets/issue_card.dart';
import 'issue_detail_screen.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final IssueRepository _repository = globalIssueRepository;

  // State
  List<int> _years = [];
  int _selectedYear = 2025;
  List<IssueModel> _issues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final years = await _repository.getAvailableYears();

    if (years.isNotEmpty) {
      // mặc định chọn năm mới nhất
      final firstYear = years.first;

      final issues = await _repository.getIssuesByYear(firstYear);

      if (mounted) {
        setState(() {
          _years = years;
          _selectedYear = firstYear;
          _issues = issues;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onYearSelected(int year) async {
    if (year == _selectedYear) return;

    setState(() {
      _selectedYear = year;
      _isLoading = true; // Hiện loading nhẹ khi chuyển tab
    });

    final issues = await _repository.getIssuesByYear(year);

    if (mounted) {
      setState(() {
        _issues = issues;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'SỐ BÁO ĐÃ XUẤT BẢN',
          style: TextStyle(
            color: Color(0xFF9E1E1E),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading && _years.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Thanh chọn năm
                Container(
                  height: 60,
                  color: Colors.white,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _years.length,
                    separatorBuilder: (ctx, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final year = _years[index];
                      final isSelected = year == _selectedYear;

                      return Center(
                        child: InkWell(
                          onTap: () => _onYearSelected(year),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF9E1E1E)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected
                                  ? null
                                  : Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'Năm $year',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Divider nhẹ
                const Divider(height: 1, color: Colors.grey),

                // Grid hiển thị các số báo
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _issues.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 cột
                                childAspectRatio:
                                    0.7, // Tỉ lệ cao/rộng để giống bìa sách
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 24,
                              ),
                          itemCount: _issues.length,
                          itemBuilder: (context, index) {
                            return IssueCard(
                              issue: _issues[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => IssueDetailScreen(
                                      issue: _issues[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có dữ liệu cho năm $_selectedYear',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
