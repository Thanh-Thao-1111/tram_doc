import 'package:flutter/material.dart';
import 'ocr_capture_page.dart'; 
import 'create_flashcard_page.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Huỷ",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Tạo Ghi chú Mới",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Lưu",
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần hiển thị sách đang chọn (Read-only)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[50],
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ghi chú cho:",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "Tâm lý học về tiền",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Vùng nhập liệu nội dung
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Nhập ghi chú của bạn...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    style: TextStyle(fontSize: 18),
                    maxLines: null, // Cho phép xuống dòng thoải mái
                    keyboardType: TextInputType.multiline,
                  ),
                  const Spacer(),
                  // Input số trang
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Trang 150",
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.bookmarks_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Toolbar các nút chức năng bên dưới
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // Nút OCR lớn màu xanh
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OcrCapturePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Chụp & trích xuất chữ (OCR)",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Các nút phụ
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.format_size,
                          size: 18,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          "Ý chính",
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateFlashcardPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.style,
                          size: 18,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          "Tạo Flashcard",
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
