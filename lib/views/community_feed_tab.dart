import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CommunityFeedTab extends StatelessWidget {
  const CommunityFeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: const [
        _FeedCard(
          avatar: 'assets/images/avatars/an_nguyen.png',
          name: 'An Nguyễn',
          actionText: 'đã ghi chú về',
          highlight: 'Muôn Kiếp Nhân Sinh',
          time: '2 giờ trước',
          quote: '“Luật nhân quả đúng đợi thấy mới tin.\nNhân quả là một thực tại, một chân lý...”',
          bookCover: 'assets/images/books/Screenshot 2025-12-15 002720.png',
          buttonText: 'Bình luận',
        ),
        SizedBox(height: 12),
        _FeedCard(
          avatar: 'assets/images/avatars/minh_tran.png',
          name: 'Minh Trần',
          actionText: 'vừa hoàn thành đọc',
          highlight: 'Nhà Giả Kim',
          time: '8 giờ trước',
          bookCover: 'assets/images/books/Screenshot 2025-12-15 003248.png',
          subtitle: 'Paulo Coelho',
          buttonText: 'Bình luận',
        ),
        SizedBox(height: 12),
        _FeedCard(
          avatar: 'assets/images/avatars/lan_anh.png',
          name: 'Lan Anh',
          actionText: 'đã thêm vào kệ',
          highlight: 'Muốn đọc',
          time: 'Hôm qua',
          bookCover: 'assets/images/books/Screenshot 2025-12-15 003314.png',
          subtitle: 'Đắc Nhân Tâm • Dale Carnegie',
          buttonText: 'Bình luận',
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  final String avatar;
  final String name;
  final String actionText;
  final String highlight;
  final String time;
  final String? quote;
  final String bookCover;
  final String? subtitle;
  final String buttonText;

  const _FeedCard({
    required this.avatar,
    required this.name,
    required this.actionText,
    required this.highlight,
    required this.time,
    this.quote,
    required this.bookCover,
    this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(avatar), radius: 18),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.text, fontSize: 12),
                    children: [
                      TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ' $actionText '),
                      TextSpan(text: highlight, style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
              Text(time, style: const TextStyle(fontSize: 11, color: AppColors.subText)),
            ],
          ),
          if (quote != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(quote!, style: const TextStyle(fontSize: 12, color: AppColors.text, height: 1.35)),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(bookCover, width: 58, height: 78, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: subtitle == null
                    ? const SizedBox.shrink()
                    : Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
              ),
              SizedBox(
                height: 34,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
