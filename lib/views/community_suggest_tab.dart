import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CommunitySuggestTab extends StatelessWidget {
  const CommunitySuggestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: const [
        _SuggestCard(
          cover: 'assets/images/books/Screenshot 2025-12-15 003314.png',
          title: 'Đắc Nhân Tâm',
          author: 'Dale Carnegie',
          hint: '3 người bạn trong Vòng tròn đã đọc',
        ),
        SizedBox(height: 12),
        _SuggestCard(
          cover: 'assets/images/books/Screenshot 2025-12-15 003248.png',
          title: 'Nhà Giả Kim',
          author: 'Paulo Coelho',
          hint: 'Hà, An và 2 người khác đã đọc',
        ),
        SizedBox(height: 12),
        _SuggestCard(
          cover: 'assets/images/books/Screenshot 2025-12-15 002720.png',
          title: 'Muôn Kiếp Nhân Sinh',
          author: 'Nguyên Phong',
          hint: 'Được yêu thích trong Vòng tròn của bạn',
        ),
        SizedBox(height: 12),
        _SuggestCard(
          cover: 'assets/images/books/Screenshot 2025-12-15 003320.png',
          title: 'Cây Cam Ngọt Của Tôi',
          author: 'José Mauro de Vasconcelos',
          hint: 'Thành viên mới của Vòng tròn đã đọc',
        ),
      ],
    );
  }
}

class _SuggestCard extends StatelessWidget {
  final String cover;
  final String title;
  final String author;
  final String hint;

  const _SuggestCard({required this.cover, required this.title, required this.author, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(cover, width: 64, height: 86, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hint, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(author, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySoft,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text('Xem chi tiết', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
