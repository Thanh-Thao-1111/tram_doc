
import 'package:flutter/material.dart';
import '../widgets/community_tokens.dart';
import '../widgets/post_card.dart';

class CommunityFeedTab extends StatelessWidget {
  const CommunityFeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: const [
        PostCard(
          name: 'An Nguyễn',
          actionText: 'đã ghi chú về Muôn Kiếp Nhân Sinh',
          time: '2 giờ trước',
          bookTitle: 'Muôn Kiếp Nhân Sinh',
          bookAuthor: 'Nguyên Phong',
          note: 'Luật nhân quả đừng đợi thấy mới tin. Nhân quả là một thực tại, một chân lý...',
          avatarAsset: 'assets/images/avatars/an_nguyen.png',
          bookCoverAsset: 'assets/images/books/3.png',
          // bookCoverAsset: 'assets/images/books/book1.png',
        ),
        PostCard(
          name: 'Minh Trần',
          actionText: 'vừa hoàn thành đọc',
          time: '8 giờ trước',
          bookTitle: 'Nhà Giả Kim',
          bookAuthor: 'Paulo Coelho',
          avatarAsset: 'assets/images/avatars/minh_tran.png',
          bookCoverAsset: 'assets/images/books/2.png',
          // bookCoverAsset: 'assets/images/books/book2.png',
        ),
        PostCard(
          name: 'Lan Anh',
          actionText: 'đã thêm vào kệ "Muốn đọc"',
          time: 'Hôm qua',
          bookTitle: 'Đắc Nhân Tâm',
          bookAuthor: 'Dale Carnegie',
          avatarAsset: 'assets/images/avatars/lan_anh.png',
          bookCoverAsset: 'assets/images/books/3.png',
          // bookCoverAsset: 'assets/images/books/book3.png',
        ),
      ],
    );
  }
}
