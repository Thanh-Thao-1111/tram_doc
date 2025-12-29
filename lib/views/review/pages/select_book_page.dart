import 'package:flutter/material.dart';
import 'flashcard_player_page.dart'; 
import '../../../viewmodels/review_viewmodel.dart'; // Import file ViewModel vừa sửa ở trên

class SelectBookPage extends StatefulWidget {
  const SelectBookPage({super.key});

  @override
  State<SelectBookPage> createState() => _SelectBookPageState();
}

class _SelectBookPageState extends State<SelectBookPage> {
  // 1. Khởi tạo ViewModel
  final SelectBookViewModel _viewModel = SelectBookViewModel();

  @override
  void dispose() {
    _viewModel.dispose(); // Hủy khi thoát
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chọn sách ôn tập",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. THANH TÌM KIẾM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                // GỌI HÀM LOGIC TÌM KIẾM TỪ VIEWMODEL
                onChanged: (value) => _viewModel.searchBook(value),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Tìm tên sách...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // 2. DANH SÁCH SÁCH (Lắng nghe thay đổi từ ViewModel)
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                // Lấy danh sách từ ViewModel
                final books = _viewModel.books;

                if (books.isEmpty) {
                  return Center(
                    child: Text("Không tìm thấy sách nào", style: TextStyle(color: Colors.grey[500])),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return _buildBookItem(
                      context,
                      title: book['title'],
                      author: book['author'],
                      cardCount: book['count'],
                      imageUrl: book['image'],
                      color: book['color'],
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

  // Widget hiển thị item sách (Giữ nguyên vẻ đẹp UI cũ)
  Widget _buildBookItem(
    BuildContext context, {
    required String title,
    required String author,
    required int cardCount,
    required String imageUrl,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Chuyển sang màn hình Player
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardPlayerPage(mode: "Ôn: $title"),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh bìa sách
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color.withOpacity(0.2),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (e, s) {}, // Tránh crash nếu link ảnh lỗi
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Thông tin chi tiết
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  
                  // Tag số lượng thẻ
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "$cardCount thẻ",
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      Text("Bấm để ôn", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}