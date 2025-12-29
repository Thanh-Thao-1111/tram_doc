import 'package:flutter/material.dart';

class LibraryBookItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double progress; 
  final VoidCallback onTap;

  const LibraryBookItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    this.progress = 0.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh bìa sách
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  image: DecorationImage(
                    image: NetworkImage(
                      imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150'
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            // 2. Thông tin sách
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 🔥 3. Logic hiển thị Thanh tiến độ
                  if (progress > 0) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress > 1 ? 1 : progress, // Đảm bảo ko vượt quá 100%
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFF4CAF50), // Màu xanh lá
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(fontSize: 10, color: Colors.green),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}