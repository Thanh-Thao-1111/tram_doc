import 'package:flutter/material.dart';
import '../widgets/rating_star.dart';

class ReviewBookPage extends StatefulWidget {
  const ReviewBookPage({super.key});

  @override
  State<ReviewBookPage> createState() => _ReviewBookPageState();
}

class _ReviewBookPageState extends State<ReviewBookPage> {
  int _selectedRating = 0; // Biến lưu số sao đang chọn (0-5)

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
        centerTitle: true,
        title: const Text(
          "Đánh giá",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Hủy",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Thông tin sách
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 90,
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
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nhà Giả Kim", 
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Paulo Coelho",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 2. Chọn Sao (Rating Star)
            Center(
              child: RatingStar(
                rating: _selectedRating,
                size: 40,
                activeColor: Colors.amber,
                onRatingChanged: (newRating) {
                  setState(() {
                    _selectedRating = newRating;
                  });
                },
              ),
            ),

            const SizedBox(height: 32),

            // 3. Ô nhập nội dung
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                maxLines: 8, 
                decoration: InputDecoration(
                  hintText: "Chia sẻ cảm nghĩ của bạn về cuốn sách này...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 4. Nút Gửi đánh giá
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý gửi review xong thì đóng màn hình
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Gửi đánh giá",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
