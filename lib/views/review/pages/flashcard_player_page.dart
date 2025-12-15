import 'package:flutter/material.dart';
import '../widgets/study_progress_bar.dart'; // Import thanh tiến độ
import 'review_result_page.dart'; // Import trang kết quả

class FlashcardPlayerPage extends StatefulWidget {
  final String mode; // Để biết đang học chế độ gì
  const FlashcardPlayerPage({super.key, required this.mode});

  @override
  State<FlashcardPlayerPage> createState() => _FlashcardPlayerPageState();
}

class _FlashcardPlayerPageState extends State<FlashcardPlayerPage> {
  bool _isFlipped = false; // Trạng thái: false = mặt trước, true = mặt sau

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Nền hơi xám để nổi bật thẻ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.mode,
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // SỬ DỤNG WIDGET TIẾN ĐỘ TÁCH RIÊNG
            const SizedBox(
              width: 200, // Giới hạn chiều rộng thanh tiến độ cho đẹp
              child: StudyProgressBar(current: 12, total: 50),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // KHU VỰC THẺ FLASHCARD
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Logic: Chưa lật thì lật ra sau
                  if (!_isFlipped) {
                    setState(() {
                      _isFlipped = true;
                    });
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.55,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  // Logic hiển thị mặt trước hoặc sau
                  child: _isFlipped ? _buildBackFace() : _buildFrontFace(),
                ),
              ),
            ),
          ),

          // KHU VỰC NÚT BẤM ĐÁNH GIÁ
          Container(
            padding: const EdgeInsets.all(24),
            height: 120,
            // Chỉ hiện nút khi đã lật ra mặt sau
            child: _isFlipped 
                ? _buildRatingButtons() 
                : const SizedBox.shrink(), 
          ),
        ],
      ),
    );
  }

  // --- UI MẶT TRƯỚC (CÂU HỎI) ---
  Widget _buildFrontFace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text("Tác giả", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 32),
        const Text(
          "Tác giả của \"Đắc Nhân Tâm\" là ai?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Text("Từ sách: Đắc Nhân Tâm", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 32),
        
        // Nút gợi ý bấm
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text("Chạm để xem", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --- UI MẶT SAU (ĐÁP ÁN) ---
  Widget _buildBackFace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text("Đáp án", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 32),
        const Text(
          "Dale Carnegie",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const Spacer(),
        const Text("Từ sách: Đắc Nhân Tâm", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // --- CÁC NÚT ĐÁNH GIÁ ---
  Widget _buildRatingButtons() {
    return Row(
      children: [
        Expanded(child: _ratingButton("Khó", Colors.grey.shade200, Colors.black)),
        const SizedBox(width: 12),
        Expanded(child: _ratingButton("Tốt", const Color(0xFF4CAF50), Colors.white)),
        const SizedBox(width: 12),
        Expanded(child: _ratingButton("Dễ", Colors.white, Colors.black, border: true)),
      ],
    );
  }

  Widget _ratingButton(String text, Color bg, Color textCol, {bool border = false}) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Xử lý khi bấm đánh giá -> Chuyển sang thẻ tiếp hoặc trang kết quả
          // Ở đây giả lập là học xong -> Sang trang kết quả
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReviewResultPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: textCol,
          elevation: 0,
          side: border ? BorderSide(color: Colors.grey.shade300) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}