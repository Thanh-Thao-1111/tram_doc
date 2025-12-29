import 'package:flutter/material.dart';

// Import widget
import 'widgets/streak_bar.dart';
import 'widgets/review_menu_item.dart';

// Import các trang con (Dù là trang rỗng placeholder cũng được)
import 'pages/select_book_page.dart';
import 'pages/flashcard_player_page.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng sạch
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: const [
            Text("", style: TextStyle(fontSize: 24)),
            Text(
              "Ôn tập ghi nhớ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Phần Streak (Widget tách riêng)
            const StreakBar(),
            
            const SizedBox(height: 32),

            // Tiêu đề section
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

            // 2. Các Menu Option (Giống thiết kế)
            
            // Item 1: Ôn thẻ cần ôn
            ReviewMenuItem(
              title: "Ôn thẻ cần ôn",
              subtitle: "0/50 thẻ", // Hardcode số liệu
              icon: Icons.check_circle_outline,
              iconColor: const Color(0xFF4CAF50), // Xanh lá
              iconBgColor: const Color(0xFFE8F5E9),
              onTap: () {
                // Chuyển sang trang học
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardPlayerPage(mode: "Ôn tập")));
              },
            ),

            // Item 2: Ôn ngẫu nhiên
            ReviewMenuItem(
              title: "Ôn ngẫu nhiên",
              subtitle: "Ôn tập bộ thẻ flashcard từ bộ gợi nhớ bạn đang học tập.",
              icon: Icons.calendar_today_outlined,
              iconColor: const Color(0xFF2196F3), // Xanh dương
              iconBgColor: const Color(0xFFE3F2FD),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardPlayerPage(mode: "Ngẫu nhiên")));
              },
            ),

            // Item 3: Ôn theo sách
            ReviewMenuItem(
              title: "Ôn theo sách",
              subtitle: "Chọn 1 cuốn sách để ôn các gợi nhớ trong sách đó.",
              icon: Icons.menu_book,
              iconColor: const Color(0xFF2196F3), // Xanh dương
              iconBgColor: const Color(0xFFE3F2FD),
              onTap: () {
                // Chuyển sang trang chọn sách
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectBookPage()));
              },
            ),

            // Item 4: Ôn lại thẻ sai
            ReviewMenuItem(
              title: "Ôn lại thẻ sai",
              subtitle: "Luyện tập lại các gợi nhớ bạn thường học sai trước đó.",
              icon: Icons.cancel_outlined,
              iconColor: const Color(0xFFF44336), // Đỏ
              iconBgColor: const Color(0xFFFFEBEE),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardPlayerPage(mode: "Ôn sai")));
              },
            ),

            const SizedBox(height: 24),

            // 3. Nút Bắt đầu to đùng
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardPlayerPage(mode: "Bắt đầu")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50), // Màu xanh chủ đạo
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
            
            const SizedBox(height: 24), // Padding bottom cho đẹp
          ],
        ),
      ),
    );
  }
}