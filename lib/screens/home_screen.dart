import 'package:flutter/material.dart';
import '../data/global_data.dart'; // <--- QUAN TRỌNG: Dùng dữ liệu chung mới
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Tất cả';
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['Tất cả', 'Lý luận', 'Dạy học', 'Quản lý', 'Tâm lý'];

  @override
  Widget build(BuildContext context) {
    // LOGIC LỌC DỮ LIỆU (Dùng allArticles từ global_data.dart)
    final displayArticles = allArticles.where((article) {
      final matchCategory = _selectedCategory == 'Tất cả' || 
                            article.category.toUpperCase() == _selectedCategory.toUpperCase();
      final matchSearch = _searchText.isEmpty || 
                          article.title.toLowerCase().contains(_searchText.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildCategoryTabs(),
              const SizedBox(height: 24),
              
              if (_searchText.isEmpty) ...[
                _buildSectionTitle('Số mới phát hành', showViewAll: true),
                const SizedBox(height: 12),
                _buildFeaturedCard(),
                const SizedBox(height: 24),
              ],

              _buildSectionTitle('Bài báo Khoa học', showViewAll: true, viewAllText: 'Mới nhất'),
              const SizedBox(height: 12),

              // DANH SÁCH BÀI VIẾT
              if (displayArticles.isEmpty)
                 Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 50, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text("Không tìm thấy bài viết nào", style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                )
              else
                ...displayArticles.map((article) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Truyền đúng đối tượng Article mới
                          builder: (context) => ArticleDetailScreen(article: article),
                        ),
                      ).then((_) {
                        // Khi quay lại từ màn hình chi tiết, cập nhật lại giao diện (để nhỡ có lưu bài thì nó refresh)
                        setState(() {});
                      });
                    },
                    child: _buildArticleItem(
                      category: article.category,
                      title: article.title,
                      author: article.author,
                    ),
                  );
                }),

              const SizedBox(height: 30),
              _buildPartnerSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _searchText = '';
            _searchController.clear();
            _selectedCategory = 'Tất cả';
          });
        },
        backgroundColor: const Color(0xFF9E1E1E),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  // --- CÁC WIDGET CON (Giữ nguyên giao diện đẹp cũ) ---

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchText = value),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm bài viết...', hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 24),
            suffixIcon: _searchText.isNotEmpty 
              ? IconButton(icon: const Icon(Icons.clear, size: 20, color: Colors.grey), onPressed: () => setState(() { _searchText = ''; _searchController.clear(); })) 
              : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFF9E1E1E), width: 1)),
            fillColor: Colors.white, filled: true,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF9E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF9E1E1E).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
              ),
              child: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArticleItem({required String category, required String title, required String author}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(category.toUpperCase(), style: const TextStyle(color: Color(0xFF9E1E1E), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)), Icon(Icons.bookmark_border, size: 20, color: Colors.grey.shade400)]), const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333), height: 1.4)), const SizedBox(height: 12), Row(children: [Icon(Icons.person_outline, size: 16, color: Colors.grey.shade500), const SizedBox(width: 6), Text(author, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500))])]),
    );
  }

  // --- Header & Featured & Partner (Giữ nguyên) ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: [Container(width: 48, height: 48, padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: Image.asset('assets/images/logo.png', fit: BoxFit.contain)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [const Text('TẠP CHÍ GIÁO DỤC', style: TextStyle(color: Color(0xFF9E1E1E), fontWeight: FontWeight.w800, fontSize: 18, fontFamily: 'Serif', letterSpacing: 0.5)), const SizedBox(height: 2), Text('TẠP CHÍ LÍ LUẬN - KHOA HỌC GIÁO DỤC • BỘ GIÁO DỤC VÀ ĐÀO TẠO', style: TextStyle(color: Colors.blue[900], fontSize: 8.5, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis)])), const SizedBox(width: 8), const Icon(Icons.notifications_outlined, size: 28, color: Colors.black87)]),
    );
  }
  Widget _buildSectionTitle(String title, {bool showViewAll = false, String viewAllText = 'Xem tất cả'}) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Row(children: [Container(width: 4, height: 24, decoration: BoxDecoration(color: const Color(0xFF9E1E1E), borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF222222))), const Spacer(), if (showViewAll) Text(viewAllText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF9E1E1E)))]));
  }
  Widget _buildFeaturedCard() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Container(height: 200, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF9E9E9E), Color(0xFF212121)]), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]), child: Stack(children: [Positioned(top: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFD32F2F), borderRadius: BorderRadius.circular(4)), child: const Text('NỔI BẬT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)))), const Positioned(bottom: 20, left: 16, right: 16, child: Text('Quy trình đào tạo gắn lí thuyết với thực hành trong kỷ nguyên số', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis))])));
  }
  Widget _buildPartnerSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('ĐỐI TÁC ĐỒNG HÀNH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0))), const SizedBox(height: 12), SizedBox(height: 50, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [_buildPartnerLogo('Bộ GD&ĐT', Colors.blue.shade50), _buildPartnerLogo('NXB Giáo Dục', Colors.green.shade50), _buildPartnerLogo('VJE', Colors.red.shade50), _buildPartnerLogo('UNESCO', Colors.indigo.shade50), _buildPartnerLogo('UNICEF', Colors.cyan.shade50)]))]);
  }
  Widget _buildPartnerLogo(String name, Color bgColor) {
    return Container(width: 100, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), alignment: Alignment.center, child: Text(name, textAlign: TextAlign.center, style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 11)));
  }
}