import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class FriendProfilePage extends StatelessWidget {
  const FriendProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cộng đồng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/avatars/lan_chi.png'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lan Chi', style: TextStyle(fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('50 cuốn sách', style: TextStyle(fontSize: 12, color: AppColors.subText)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: AppColors.subText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text('Đang theo dõi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: _MiniStat(value: '50', label: 'Sách đã đọc', valueColor: AppColors.primary, bg: AppColors.primarySoft),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(value: '12', label: 'Chuỗi đọc (ngày)', valueColor: Color(0xFFFF7A00), bg: Color(0xFFFFF3E9)),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Text('Tủ sách của Lan Chi', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: const [
                _BookGridItem(cover: 'assets/images/books/Screenshot 2025-12-15 002720.png', title: 'Muôn Kiếp', author: 'Nguyên Phong'),
                _BookGridItem(cover: 'assets/images/books/Screenshot 2025-12-15 003248.png', title: 'Vi Vai', author: 'Viral Nosh'),
                _BookGridItem(cover: 'assets/images/books/Screenshot 2025-12-15 003314.png', title: 'Nhà Giả Kim', author: 'Kim'),
                _BookGridItem(cover: 'assets/images/books/Screenshot 2025-12-15 003320.png', title: 'Đắc Nhân', author: 'Dale Carnegie'),
                _BookGridItem(cover: 'assets/images/books/Screenshot 2025-12-15 003326.png', title: 'Tư Duy', author: 'Daniel Kahneman'),
                _BookGridItem(cover: 'assets/images/books/Screenshot 2025-12-15 003330.png', title: 'Kệ Ảnh', author: 'Trần Xu'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: valueColor)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
        ],
      ),
    );
  }
}

class _BookGridItem extends StatelessWidget {
  final String cover;
  final String title;
  final String author;

  const _BookGridItem({required this.cover, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(cover, width: double.infinity, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(author, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.subText)),
      ],
    );
  }
}
