import 'package:flutter/material.dart';

class ReviewResultPage extends StatelessWidget {
  final int easyCount;
  final int goodCount;
  final int hardCount;

  // Xóa const mặc định để bắt buộc truyền dữ liệu từ PlayerViewModel
  const ReviewResultPage({
    super.key,
    required this.easyCount,
    required this.goodCount,
    required this.hardCount,
  });

  @override
  Widget build(BuildContext context) {
    // Tổng số thẻ đã ôn
    int totalReviewed = easyCount + goodCount + hardCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Biểu tượng thành tích
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

              const Text(
                "Tuyệt vời!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Bạn đã hoàn thành phiên ôn tập với $totalReviewed thẻ.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // Thống kê kết quả thực tế
              Row(
                children: [
                  _buildStatCard("Khó", hardCount.toString(), Colors.red),
                  const SizedBox(width: 16),
                  _buildStatCard("Tốt", goodCount.toString(), Colors.blue),
                  const SizedBox(width: 16),
                  _buildStatCard("Dễ", easyCount.toString(), Colors.green),
                ],
              ),

              const Spacer(),

              // Nút điều hướng
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Hoàn thành", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

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