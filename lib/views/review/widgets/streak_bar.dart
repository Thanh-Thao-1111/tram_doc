// lib/views/review/widgets/streak_bar.dart
import 'package:flutter/material.dart';

class StreakBar extends StatelessWidget {
  final List<DateTime> completedDates; // Danh sách ngày đã học từ Firebase
  final int streakCount;

  const StreakBar({
    super.key, 
    required this.completedDates, 
    required this.streakCount
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    // Tính toán ngày Thứ 2 của tuần hiện tại
    final DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Text("Chuỗi ngày ôn tập", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Text("$streakCount ngày", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            // Tính toán từng ngày từ Thứ 2 đến Chủ Nhật
            final DateTime dateTarget = DateTime(
              firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day
            ).add(Duration(days: index));

            final bool isToday = DateUtils.isSameDay(dateTarget, now);
            
            // QUAN TRỌNG: Ngày này "Active" khi và chỉ khi nó nằm trong danh sách đã học từ Firebase
            final bool isActive = completedDates.any((d) => DateUtils.isSameDay(d, dateTarget));

            return Column(
              children: [
                Container(
                  width: 40, height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // Đã học thì màu Cam, chưa học thì màu Xám nhạt
                    color: isActive ? const Color(0xFFFF5722) : Colors.grey[100], 
                    shape: BoxShape.circle,
                    // Nếu là hôm nay thì thêm viền đen đậm
                    border: isToday ? Border.all(color: Colors.black, width: 2) : null,
                  ),
                  child: Text(
                    ["T2", "T3", "T4", "T5", "T6", "T7", "CN"][index],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text("${dateTarget.day}/${dateTarget.month}", 
                  style: TextStyle(fontSize: 10, color: isToday ? Colors.black : Colors.grey)),
              ],
            );
          }),
        ),
      ],
    );
  }
}