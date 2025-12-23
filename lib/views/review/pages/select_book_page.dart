import 'package:flutter/material.dart';
import 'flashcard_player_page.dart'; // Import để chuyển trang khi chọn sách

class SelectBookPage extends StatelessWidget {
  const SelectBookPage({super.key});

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
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Tìm tên sách...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // 2. DANH SÁCH SÁCH
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildBookItem(
                  context,
                  title: "Đắc Nhân Tâm",
                  author: "Dale Carnegie",
                  cardCount: 120,
                  imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1449557635i/4865.jpg",
                  color: Colors.blue,
                ),
                _buildBookItem(
                  context,
                  title: "Nhà Giả Kim",
                  author: "Paulo Coelho",
                  cardCount: 85,
                  imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654371463i/18144590.jpg",
                  color: Colors.purple,
                ),
                _buildBookItem(
                  context,
                  title: "Atomic Habits",
                  author: "James Clear",
                  cardCount: 200,
                  imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1655988385i/40121378.jpg",
                  color: Colors.green,
                ),
                _buildBookItem(
                  context,
                  title: "Tâm lý học về tiền",
                  author: "Morgan Housel",
                  cardCount: 45,
                  imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg",
                  color: Colors.orange,
                ),
                 _buildBookItem(
                  context,
                  title: "Nghĩ Giàu Làm Giàu",
                  author: "Napoleon Hill",
                  cardCount: 110,
                  imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1463241782i/30186948.jpg",
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị từng cuốn sách
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
        // Khi chọn sách -> Chuyển sang màn hình học với mode là tên sách
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
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Thông tin sách
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
                  
                  // Thanh tiến độ nhỏ & Số lượng thẻ
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
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Bấm để ôn",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
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