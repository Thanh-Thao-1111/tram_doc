import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'review_book_page.dart';
import '../widgets/note_item.dart';
import '../widgets/rating_star.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4CAF50);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Chi tiết Sách',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // --- HEADER SÁCH ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tâm lý học về tiền', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Morgan Housel', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.book, size: 16, color: primaryColor),
                            const SizedBox(width: 4),
                            const Text('Đang đọc', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: primaryColor),
                            const SizedBox(width: 4),
                            const Text('Kệ sách phòng khách', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- TAB BAR ---
            const TabBar(
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Thông tin'),
                Tab(text: 'Ghi chú'),
                Tab(text: 'Cộng đồng'),
              ],
            ),

            // --- TAB CONTENT ---
            Expanded(
              child: TabBarView(
                children: [
                  _buildInfoTab(context, primaryColor),
                  _buildNotesTab(context),
                  _buildCommunityTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: THÔNG TIN ---
  Widget _buildInfoTab(BuildContext context, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Làm tốt với tiền không nhất thiết là về những gì bạn biết. Đó là về cách bạn cư xử. Và hành vi rất khó để dạy, ngay cả với những người thực sự thông minh.",
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Đã đọc 50%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              Text("Trang 150 / 300", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey[200],
            color: primaryColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.green),
              label: const Text("Cập nhật tiến độ", style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8F5E9),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: GHI CHÚ ---
  Widget _buildNotesTab(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNotePage()),
                );
              },
              icon: const Icon(Icons.edit_note, color: Colors.white),
              label: const Text(
                "Viết ghi chú mới",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // Code đã gọn gàng hơn nhờ NoteItem
              return NoteItem(
                page: "Trang ${25 * (index + 1)}",
                date: "2${index} tháng 10, 2025",
                content: "Đây là nội dung ghi chú số ${index + 1}. Một bài học quan trọng về cách quản lý tài chính cá nhân mà tôi rút ra được...",
                onTap: () {
                   // Xử lý xem chi tiết ghi chú
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // --- TAB 3: CỘNG ĐỒNG (Sử dụng RatingStar) ---
  Widget _buildCommunityTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("4.8", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sử dụng RatingStar (Read-only)
                const RatingStar(rating: 5, size: 20), 
                const SizedBox(height: 4),
                const Text("1,234 đánh giá", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewBookPage()),
              );
            },
            icon: const Icon(Icons.rate_review, color: Color(0xFF4CAF50)),
            label: const Text("Viết đánh giá", style: TextStyle(color: Color(0xFF4CAF50))),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF4CAF50)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const Divider(height: 32),
        
        _buildReviewItem("Minh Hưng", 5, "Cuốn sách tuyệt vời về hành trình theo đuổi ước mơ."),
        _buildReviewItem("Lan Anh", 4, "Nội dung hay nhưng bản dịch đôi chỗ hơi khó hiểu."),
        _buildReviewItem("Quốc Tuấn", 5, "Ngôn ngữ giản dị nhưng sâu sắc. Rất đáng đọc!"),
        _buildReviewItem("Hoàng Nam", 3, "Hơi dài dòng so với mong đợi của mình."),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text(name[0], style: const TextStyle(color: Colors.black87)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                // Sử dụng RatingStar
                RatingStar(rating: rating, size: 14), 
                const SizedBox(height: 6),
                Text(comment, style: const TextStyle(color: Colors.black87, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}