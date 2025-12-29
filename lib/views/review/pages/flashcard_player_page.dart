import 'package:flutter/material.dart';
import '../widgets/study_progress_bar.dart'; 
import 'review_result_page.dart'; 
import '../../../viewmodels/review_viewmodel.dart'; 

class FlashcardPlayerPage extends StatefulWidget {
  final String mode; 
  const FlashcardPlayerPage({super.key, required this.mode});

  @override
  State<FlashcardPlayerPage> createState() => _FlashcardPlayerPageState();
}

class _FlashcardPlayerPageState extends State<FlashcardPlayerPage> {
  // 1. Khởi tạo ViewModel
  final FlashcardPlayerViewModel _viewModel = FlashcardPlayerViewModel();

  @override
  void dispose() {
    _viewModel.dispose(); // Hủy ViewModel khi thoát
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Dùng ListenableBuilder để UI tự vẽ lại khi ViewModel thay đổi
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        
        // --- LOGIC ĐIỀU HƯỚNG: Khi học xong ---
        if (_viewModel.isFinished) {
          Future.microtask(() {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReviewResultPage()),
              );
            }
          });
          // Trả về màn hình chờ tạm thời
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Lấy thẻ hiện tại từ ViewModel
        final currentCard = _viewModel.currentCard;

        return Scaffold(
          backgroundColor: Colors.grey[50],
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
                  widget.mode == "DAILY_REVIEW" ? "Ôn tập hàng ngày" : "Ôn sai",
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  // PROGRESS BAR: Lấy số liệu thực tế từ ViewModel
                  child: StudyProgressBar(
                    current: _viewModel.currentIndex + 1, 
                    total: _viewModel.totalCards,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // --- KHU VỰC THẺ (CARD) ---
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _viewModel.flipCard, // GỌI HÀM VM: Lật thẻ
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
                      // Logic hiển thị mặt trước/sau dựa trên biến isFlipped của VM
                      child: _viewModel.isFlipped 
                          ? _buildBackFace(currentCard) 
                          : _buildFrontFace(currentCard),
                    ),
                  ),
                ),
              ),

              // --- KHU VỰC NÚT BẤM (BUTTONS) ---
              Container(
                padding: const EdgeInsets.all(24),
                height: 120,
                // Chỉ hiện nút khi thẻ đã lật (check isFlipped từ VM)
                child: _viewModel.isFlipped 
                    ? _buildRatingButtons() 
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- CÁC WIDGET CON (UI) ---

  Widget _buildFrontFace(FlashcardData card) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text("Câu hỏi", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 32),
        Text(
          card.question, 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text("Nguồn: ${card.source}", style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text("Chạm để lật", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildBackFace(FlashcardData card) {
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
        Text(
          card.answer,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const Spacer(),
        Text("Nguồn: ${card.source}", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildRatingButtons() {
    return Row(
      children: [
        // Các nút bấm gọi handleRating với text tương ứng
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
        // GỌI HÀM VM: Xử lý đánh giá -> Chuyển câu tiếp theo
        onPressed: () => _viewModel.handleRating(text), 
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