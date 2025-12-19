import 'package:flutter/material.dart';
import '../widgets/rating_star.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart';

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
    final viewModel = context.read<LibraryViewModel>();

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
                    // Hiển thị nhắc nhở nếu chưa chọn sao
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

            // 3. Ô nhập nội dung
            
            
            Form(
              key: _formKey,
              child:Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextFormField(
                maxLines: 8, 
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: "Chia sẻ cảm nghĩ của bạn về cuốn sách này...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  errorStyle: TextStyle(color: Colors.redAccent),
                ),
                  validator: (value) => viewModel.validateContent(
                    value, 
                    minLength: 10, 
                    fieldName: "Nội dung đánh giá"
                  ),
                  onSaved: (value) => _reviewContent = value!.trim(),
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
                  if (_selectedRating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Bạn quên chấm điểm sao rồi!"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                  }
                  if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      viewModel.submitReview(_selectedRating, _reviewContent);
                      
                      // context.read<ReviewViewModel>().submitReview(...)
                  // Xử lý gửi review xong thì đóng màn hình
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cảm ơn đánh giá của bạn!")),
                      );
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
