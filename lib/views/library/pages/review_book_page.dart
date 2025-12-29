import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../viewmodels/community_viewmodel.dart';
import '../widgets/rating_star.dart';

class ReviewBookPage extends StatefulWidget {
  const ReviewBookPage({super.key});

  @override
  State<ReviewBookPage> createState() => _ReviewBookPageState();
}

class _ReviewBookPageState extends State<ReviewBookPage> {
  final _formKey = GlobalKey<FormState>();

  int _selectedRating = 0;
  String _reviewContent = '';
  bool _publishToCommunity = true; // Mặc định bật đăng lên community
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryViewModel>();
    final book = viewModel.currentBook;

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
            // 1. THÔNG TIN SÁCH
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
                        book.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
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

            const SizedBox(height: 16),

            // 4. OPTION ĐĂNG LÊN CỘNG ĐỒNG
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _publishToCommunity ? const Color(0xFFE8F5E9) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: _publishToCommunity 
                    ? Border.all(color: const Color(0xFF4CAF50), width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    _publishToCommunity ? Icons.public : Icons.public_off,
                    color: _publishToCommunity ? const Color(0xFF4CAF50) : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Đăng lên cộng đồng",
                      style: TextStyle(
                        color: _publishToCommunity ? const Color(0xFF4CAF50) : Colors.grey[700],
                        fontWeight: _publishToCommunity ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  Switch(
                    value: _publishToCommunity,
                    onChanged: (value) => setState(() => _publishToCommunity = value),
                    activeColor: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. NÚT GỬI ĐÁNH GIÁ
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () => _submitReview(context, viewModel, book),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
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

  Future<void> _submitReview(BuildContext context, LibraryViewModel viewModel, dynamic book) async {
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
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    // Lưu review local
    await viewModel.addUserReview(_reviewContent, _selectedRating);

    // Đăng lên Community nếu được bật
    if (_publishToCommunity) {
      final communityViewModel = context.read<CommunityViewModel>();
      final ratingText = '⭐' * _selectedRating;
      
      final success = await communityViewModel.createPost(
        actionText: 'đã đánh giá $ratingText',
        bookTitle: book.title,
        bookAuthor: book.author,
        bookCoverUrl: book.imageUrl,
        noteContent: _reviewContent,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đã đăng đánh giá lên cộng đồng!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(communityViewModel.errorMessage ?? 'Lỗi đăng lên cộng đồng'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cảm ơn đánh giá của bạn!")),
      );
    }

    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }
}