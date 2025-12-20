import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_note_page.dart';
import 'review_book_page.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../widgets/note_item.dart';
import '../widgets/rating_star.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

  class _BookDetailPageState extends State<BookDetailPage> {

  // Hàm hiển thị Dialog cập nhật tiến độ
  void _showUpdateProgressDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final viewModel = context.read<LibraryViewModel>(); // Dùng read để gọi hàm
    
    // Lấy dữ liệu hiện tại từ VM
    int current = viewModel.currentPage;
    int total = viewModel.totalPages;
    int newPage = current;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cập nhật tiến độ"),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: current.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Số trang đang đọc",
              border: OutlineInputBorder(),
              suffixText: "trang",
            ),
            // 3. GỌI VALIDATE TỪ VIEWMODEL
            validator: (value) => viewModel.validatePageNumber(value, maxPage: total),
            onSaved: (value) => newPage = int.parse(value!),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                
                // 4. GỌI HÀM UPDATE CỦA VIEWMODEL
                viewModel.updateReadingProgress(newPage);
                
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã cập nhật tiến độ đọc!")),
                );
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4CAF50);

    final viewModel = context.watch<LibraryViewModel>();

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
                  _buildInfoTab(context,viewModel, primaryColor),
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
  Widget _buildInfoTab(BuildContext context, LibraryViewModel viewModel, Color primaryColor) {

    int current = viewModel.currentPage;
    int total = viewModel.totalPages;
    double progress = (total == 0) ? 0 : (current / total);

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
            children: [
              Text("Đã đọc ${(progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              Text("Trang $current / $total", style: const TextStyle(color: Colors.grey)),
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
              onPressed: () {
                _showUpdateProgressDialog(context);
              },
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