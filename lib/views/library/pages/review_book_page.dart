import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../widgets/rating_star.dart'; // Đảm bảo widget này đã tồn tại

class ReviewBookPage extends StatefulWidget {
  const ReviewBookPage({super.key});

  @override
  State<ReviewBookPage> createState() => _ReviewBookPageState();
}

class _ReviewBookPageState extends State<ReviewBookPage> {
  final _formKey = GlobalKey<FormState>();

  int _selectedRating = 0; // Biến lưu số sao đang chọn (0-5)
  String _reviewContent = ''; // Biến lưu nội dung review

  @override
  Widget build(BuildContext context) {
    // 1. Lấy dữ liệu sách từ ViewModel
    final viewModel = context.watch<LibraryViewModel>();
    final book = viewModel.currentBook;

    // Check an toàn
    if (book == null) return const Scaffold(body: Center(child: Text("Lỗi: Không tìm thấy sách")));

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
            // 1. THÔNG TIN SÁCH (ĐÃ SỬA DYNAMIC)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(
                        book.imageUrl.isNotEmpty ? book.imageUrl : 'https://via.placeholder.com/150',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title, // Tên sách thật
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author, // Tên tác giả thật
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 2. CHỌN SAO (RATING)
            Center(
              child: Column(
                children: [
                  RatingStar(
                    rating: _selectedRating,
                    size: 40,
                    activeColor: Colors.amber,
                    onRatingChanged: (newRating) {
                      setState(() {
                        _selectedRating = newRating;
                      });
                    },
                  ),
                  if (_selectedRating == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Hãy chạm vào sao để chấm điểm",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. Ô NHẬP NỘI DUNG
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  maxLines: 8,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Chia sẻ cảm nghĩ của bạn về cuốn sách này...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                    errorStyle: TextStyle(color: Colors.redAccent),
                  ),
                  // Dùng hàm validate của ViewModel (nếu có) hoặc tự viết
                  validator: (value) {
                    if (value == null || value.trim().length < 5) {
                      return "Nội dung đánh giá quá ngắn (tối thiểu 5 ký tự)";
                    }
                    return null;
                  },
                  onSaved: (value) => _reviewContent = value!.trim(),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 4. NÚT GỬI ĐÁNH GIÁ
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Validate Số sao
                  if (_selectedRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bạn quên chấm điểm sao rồi!"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // Validate Nội dung
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // 🔥 GỌI HÀM LƯU TỪ VIEWMODEL (Lưu lên Firebase)
                    await viewModel.addUserReview(_reviewContent, _selectedRating);
                    
                    if (mounted) {
                      Navigator.pop(context); // Đóng trang
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cảm ơn đánh giá của bạn!")),
                      );
                    }
                  }
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