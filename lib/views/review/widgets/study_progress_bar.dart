import 'package:flutter/material.dart';

class StudyProgressBar extends StatelessWidget {
  final int current; // Số thẻ đã học (ví dụ: 15)
  final int total;   // Tổng số thẻ (ví dụ: 50)

  const StudyProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // Tính toán tỷ lệ % (0.0 -> 1.0)
    final double progress = total == 0 ? 0 : current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thanh màu xanh/xám
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF4CAF50), // Màu xanh chủ đạo
          ),
        ),
        const SizedBox(height: 6),
        
        // Dòng chữ "15/50 đã hoàn thành"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$current/$total đã hoàn thành",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Có thể thêm % bên phải nếu thích
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}