import 'package:flutter/material.dart';
import 'widgets/streak_bar.dart';
import 'widgets/review_menu_item.dart';
import 'pages/select_book_page.dart';
import 'pages/flashcard_player_page.dart';
import '../../viewmodels/review_viewmodel.dart'; 

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Khởi tạo ViewModel
  final ReviewDashboardViewModel _viewModel = ReviewDashboardViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // Hàm xử lý logic chuyển trang
  void _handleNavigation(BuildContext context, String mode) {
    String? error = _viewModel.validateBeforeNavigating(mode);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FlashcardPlayerPage(
            mode: mode == "DAILY_REVIEW" ? "Ôn tập" : "Ôn sai",
          ),
        ),
      ).then((_) => _viewModel.refreshCounts()); // Tự động cập nhật lại số liệu khi quay về
    }
  }

  // HÀM MỚI: Tự động tạo banner ngày hiện tại
  Widget _buildTodayBanner(DateTime now) {
    // Chuyển đổi số thứ tự sang tên Thứ tiếng Việt
    String weekday = "";
    switch (now.weekday) {
      case 1: weekday = "T2"; break;
      case 2: weekday = "T3"; break;
      case 3: weekday = "T4"; break;
      case 4: weekday = "T5"; break;
      case 5: weekday = "T6"; break;
      case 6: weekday = "T7"; break;
      case 7: weekday = "CN"; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // Màu cam nhạt
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text("🔥", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Hôm nay ($weekday, ${now.day}/${now.month}): Tổng ${_viewModel.cardsToReview} thẻ để ôn mới",
              style: const TextStyle(
                fontSize: 13, 
                color: Color(0xFFE65100), 
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Ôn tập ghi nhớ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: () => _viewModel.refreshCounts(),
            color: const Color(0xFF4CAF50),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh Streak Bar thực tế
                  StreakBar(
                    streakCount: _viewModel.completedDates.length,
                    completedDates: _viewModel.completedDates,
                  ),
                  
                  const SizedBox(height: 24),

                  // Banner thông báo tự động
                  _buildTodayBanner(DateTime.now()),

                  const SizedBox(height: 32),

                  Row(
                    children: const [
                      Icon(Icons.book_outlined, size: 20, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        "Hôm nay học gì",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Item 1: Ôn thẻ cần ôn
                  ReviewMenuItem(
                    title: "Ôn thẻ cần ôn",
                    subtitle: "${_viewModel.cardsToReview} thẻ cần học ngay", 
                    icon: Icons.check_circle_outline,
                    iconColor: const Color(0xFF4CAF50),
                    iconBgColor: const Color(0xFFE8F5E9),
                    onTap: () => _handleNavigation(context, "DAILY_REVIEW"),
                  ),

                  // Item 2: Ôn ngẫu nhiên
                  ReviewMenuItem(
                    title: "Ôn ngẫu nhiên",
                    subtitle: "Ôn tập bộ thẻ flashcard bất kỳ.",
                    icon: Icons.casino_outlined,
                    iconColor: const Color(0xFF2196F3),
                    iconBgColor: const Color(0xFFE3F2FD),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => const FlashcardPlayerPage(mode: "Ngẫu nhiên"))
                      );
                    },
                  ),

                  // Item 3: Ôn theo sách
                  ReviewMenuItem(
                    title: "Ôn theo sách",
                    subtitle: "Chọn 1 cuốn sách để ôn.",
                    icon: Icons.menu_book,
                    iconColor: const Color(0xFF9C27B0),
                    iconBgColor: const Color(0xFFF3E5F5),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBookPage()));
                    },
                  ),

                  // Item 4: Ôn lại thẻ sai
                  ReviewMenuItem(
                    title: "Ôn lại thẻ sai",
                    subtitle: "${_viewModel.cardsMistake} thẻ làm sai trước đó.",
                    icon: Icons.cancel_outlined,
                    iconColor: const Color(0xFFF44336),
                    iconBgColor: const Color(0xFFFFEBEE),
                    onTap: () => _handleNavigation(context, "MISTAKE_REVIEW"),
                  ),

                  const SizedBox(height: 24),

                  // Nút Bắt đầu chính
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _handleNavigation(context, "DAILY_REVIEW"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Bắt đầu ôn tập →",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}