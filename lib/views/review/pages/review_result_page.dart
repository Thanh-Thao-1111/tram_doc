import 'package:flutter/material.dart';

class ReviewResultPage extends StatelessWidget {
  // 1. Thêm các biến để nhận kết quả (đặt giá trị mặc định để test UI)
  final int easyCount;
  final int goodCount;
  final int hardCount;

  const ReviewResultPage({
    super.key,
    this.easyCount = 5,   // Mặc định giả lập = 5
    this.goodCount = 12,  // Mặc định giả lập = 12
    this.hardCount = 3,   // Mặc định giả lập = 3
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // 2. Icon Chúc mừng
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events, 
                  size: 60, 
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Lời chúc
              const Text(
                "Tuyệt vời!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Bạn đã hoàn thành phiên ôn tập hôm nay.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // 4. Thống kê kết quả (Dùng dữ liệu từ biến class)
              Row(
                children: [
                  _buildStatCard("Quên", hardCount.toString(), Colors.red),
                  const SizedBox(width: 16),
                  _buildStatCard("Nhớ", goodCount.toString(), Colors.blue),
                  const SizedBox(width: 16),
                  _buildStatCard("Dễ", easyCount.toString(), Colors.green),
                ],
              ),

              const Spacer(),

              // 5. Nút điều hướng
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Pop về màn hình Menu (ReviewPage)
                    Navigator.pop(context); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Tiếp tục học", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    // Quay về tận trang chủ (Home/MainPage) nếu cần
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pop(context);
                  },
                  child: const Text("Về trang chủ", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con hiển thị thẻ thống kê
  Widget _buildStatCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count, 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)
            ),
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }
}