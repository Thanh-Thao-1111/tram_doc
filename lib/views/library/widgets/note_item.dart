import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String page;
  final String date;
  final String content;
  final VoidCallback? onTap;

  const NoteItem({
    super.key,
    required this.page,
    required this.date,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bookmark, size: 16, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 4),
                    Text(
                      page, // Ví dụ: "Trang 150"
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
                Text(
                  date, 
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(color: Colors.black87, height: 1.4),
              maxLines: 3, // Giới hạn 3 dòng
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}