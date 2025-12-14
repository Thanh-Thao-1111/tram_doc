import 'package:flutter/material.dart';

class CreateFlashcardPage extends StatelessWidget {
  const CreateFlashcardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Tạo Flashcard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Lưu",
              style: TextStyle(color: Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner chọn từ ghi chú có sẵn 
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.book, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Chọn từ ghi chú có sẵn",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Sapiens: Lược sử loài người - Trang 123",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Input Mặt trước
            const Text("Mặt trước", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), 
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300), 
              ),
              child: const TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Nhập câu hỏi, từ khóa...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Input Mặt sau
            const Text("Mặt sau", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Nhập câu trả lời, định nghĩa...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Nút Tạo Flashcard
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Tạo Flashcard",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}