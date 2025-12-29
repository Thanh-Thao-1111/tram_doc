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
  // Khởi tạo ViewModel
  final FlashcardPlayerViewModel _viewModel = FlashcardPlayerViewModel();

  @override
  void dispose() {
    _viewModel.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        
        // 1. XỬ LÝ TRẠNG THÁI LOADING (Khi đang lấy data từ Firebase)
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Đang tải dữ liệu từ Firebase..."),
                ],
              ),
            ),
          );
        }

        // 2. LOGIC ĐIỀU HƯỚNG: Khi học xong hoặc không có bài để học
        if (_viewModel.isFinished) {
          Future.microtask(() {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  ReviewResultPage(
                  easyCount: _viewModel.easyCount,
                  goodCount: _viewModel.goodCount,
                  hardCount: _viewModel.hardCount,
                )),
              );
            }
          });
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 3. KIỂM TRA DANH SÁCH RỖNG (Trường hợp Repository trả về list rỗng)
        if (_viewModel.cards.isEmpty) {
          return Scaffold(
            appBar: AppBar(leading: const CloseButton()),
            body: const Center(child: Text("Hôm nay bạn không có bài cần ôn tập!")),
          );
        }

        // Lấy thẻ hiện tại an toàn
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
                  widget.mode == "DAILY_REVIEW" ? "Ôn tập hàng ngày" : "Ôn tập",
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
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
                    onTap: _viewModel.flipCard,
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
                      child: _viewModel.isFlipped 
                          ? _buildBackFace(currentCard) 
                          : _buildFrontFace(currentCard),
                    ),
                  ),
                ),
              ),

              // --- KHU VỰC NÚT BẤM (Chỉ hiện khi đã lật) ---
              Container(
                padding: const EdgeInsets.all(24),
                height: 120,
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

  // --- UI MẶT TRƯỚC ---
  Widget _buildFrontFace(dynamic card) {
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
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                card.question, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const Spacer(),
        // Chỉnh sửa hiển thị nguồn/note từ Firebase
        Text("Ghi chú: ${card.noteId ?? 'Không có'}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
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

  // --- UI MẶT SAU ---
  Widget _buildBackFace(dynamic card) {
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
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                card.answer,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
        ),
        const Spacer(),
        Text("Ease Factor: ${card.easeFactor}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

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