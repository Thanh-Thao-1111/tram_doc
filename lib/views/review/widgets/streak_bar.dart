import 'package:flutter/material.dart';

class StreakBar extends StatelessWidget {
  const StreakBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dòng tiêu đề
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Text("Chuỗi ngày ôn tập", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Text("12 ngày", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        
        // Dãy các ngày trong tuần
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _DayItem(day: "CN", date: "1/12", isActive: true),
            _DayItem(day: "T2", date: "2/12", isActive: true),
            _DayItem(day: "T3", date: "3/12", isActive: true),
            _DayItem(day: "T4", date: "4/12", isActive: true),
            _DayItem(day: "T5", date: "5/12", isActive: true, isToday: true), // Hôm nay
            _DayItem(day: "T6", date: "6/12", isActive: false),
            _DayItem(day: "T7", date: "7/12", isActive: false),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Banner thông báo nhỏ bên dưới
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0), // Màu cam nhạt
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Text("🔥"),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Hôm nay (T5, 7/12): Tổng 50 thẻ để ôn mới",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

// Widget con nội bộ hiển thị từng ngày tròn
class _DayItem extends StatelessWidget {
  final String day;
  final String date;
  final bool isActive;
  final bool isToday;

  const _DayItem({
    required this.day,
    required this.date,
    this.isActive = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Màu cam nếu active, xám nếu chưa
            color: isActive ? const Color(0xFFFF5722) : Colors.grey[100], 
            shape: BoxShape.circle,
            // Viền đen nếu là hôm nay
            border: isToday ? Border.all(color: Colors.black, width: 2) : null,
          ),
          child: Text(
            day,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          date,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }
}