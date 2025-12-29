import 'package:flutter/material.dart';
import 'widgets/streak_bar.dart';
import 'widgets/review_menu_item.dart';
import 'pages/select_book_page.dart';
import 'pages/flashcard_player_page.dart';
// Import ViewModel (Nhớ chỉnh đường dẫn cho đúng với thư mục của bạn)
import '../../viewmodels/review_viewmodel.dart'; 

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // 1. Khởi tạo ViewModel cho Dashboard
  final ReviewDashboardViewModel _viewModel = ReviewDashboardViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // 2. Hàm xử lý logic trước khi vào học (Validate)
  void _handleNavigation(BuildContext context, String mode) {
    // Gọi hàm kiểm tra từ ViewModel
    String? error = _viewModel.validateBeforeNavigating(mode);

    if (error != null) {
      // Nếu có lỗi (hết bài/không có bài) -> Hiện thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Nếu OK -> Chuyển trang
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FlashcardPlayerPage(mode: mode == "DAILY_REVIEW" ? "Ôn tập" : "Ôn sai"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Ôn tập ghi nhớ",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
      ),
      // 3. Bọc body bằng ListenableBuilder để cập nhật số liệu
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Phần Streak
                const StreakBar(),

                const SizedBox(height: 32),

                // Tiêu đề
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

                // --- CÁC MENU OPTION ---

                // Item 1: Ôn thẻ cần ôn (Dữ liệu động từ ViewModel)
                ReviewMenuItem(
                  title: "Ôn thẻ cần ôn",
                  // Hiển thị số lượng thực tế
                  subtitle: "${_viewModel.cardsToReview} thẻ cần học ngay", 
                  icon: Icons.check_circle_outline,
                  iconColor: const Color(0xFF4CAF50),
                  iconBgColor: const Color(0xFFE8F5E9),
                  // Gọi hàm xử lý logic thay vì push trực tiếp
                  onTap: () => _handleNavigation(context, "DAILY_REVIEW"),
                ),

                // Item 2: Ôn ngẫu nhiên
                ReviewMenuItem(
                  title: "Ôn ngẫu nhiên",
                  subtitle: "Ôn tập bộ thẻ flashcard bất kỳ.",
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF2196F3),
                  iconBgColor: const Color(0xFFE3F2FD),
                  onTap: () {
                    // Ngẫu nhiên thì cho vào luôn, không cần check số lượng
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardPlayerPage(mode: "Ngẫu nhiên")));
                  },
                ),

                // Item 3: Ôn theo sách
                ReviewMenuItem(
                  title: "Ôn theo sách",
                  subtitle: "Chọn 1 cuốn sách để ôn.",
                  icon: Icons.menu_book,
                  iconColor: const Color(0xFF2196F3),
                  iconBgColor: const Color(0xFFE3F2FD),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBookPage()));
                  },
                ),

                // Item 4: Ôn lại thẻ sai (Dữ liệu động)
                ReviewMenuItem(
                  title: "Ôn lại thẻ sai",
                  // Hiển thị số lượng thực tế
                  subtitle: "${_viewModel.cardsMistake} thẻ làm sai trước đó.",
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFFF44336),
                  iconBgColor: const Color(0xFFFFEBEE),
                  // Gọi hàm xử lý logic
                  onTap: () => _handleNavigation(context, "MISTAKE_REVIEW"),
                ),

                const SizedBox(height: 24),

                // Nút Bắt đầu
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    // Nút to này ưu tiên ôn tập hàng ngày
                    onPressed: () => _handleNavigation(context, "DAILY_REVIEW"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Bắt đầu ôn tập →",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                // Debug Tool (Chỉ hiện khi dev để test logic hết bài/còn bài)
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => _viewModel.debugSetData(reviewCount: 0), 
                    child: const Text("Test: Giả lập Hết bài (Count = 0)", style: TextStyle(color: Colors.grey)),
                  ),
                ),
                 Center(
                  child: TextButton(
                    onPressed: () => _viewModel.debugSetData(reviewCount: 10), 
                    child: const Text("Test: Giả lập Có bài (Count = 10)", style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}