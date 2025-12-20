import 'package:flutter/material.dart';
import '../widgets/suggestion_card.dart';

class CommunitySuggestTab extends StatelessWidget {
  const CommunitySuggestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        SuggestionCard(
          line1: '3 người bạn trong Vòng tròn đã đọc',
          title: 'Đắc Nhân Tâm',
          coverAsset: 'assets/images/books/4.png',
          author: 'Dale Carnegie',
          onTap: () {},
        ),
        SuggestionCard(
          line1: 'Hà, An và 2 người khác đã đọc',
          title: 'Nhà Giả Kim',
          coverAsset: 'assets/images/books/5.png',
          author: 'Paulo Coelho',
          onTap: () {},
        ),
        SuggestionCard(
          line1: 'Được yêu thích trong Vòng tròn của bạn',
          title: 'Muôn Kiếp Nhân Sinh',
          coverAsset: 'assets/images/books/6.png',
          author: 'Nguyên Phong',
          onTap: () {},
        ),
        SuggestionCard(
          line1: 'Thành viên mới của Vòng tròn đã đọc',
          title: 'Cây Cam Ngọt Của Tôi',
          coverAsset: 'assets/images/books/7.png',
          author: 'José Mauro de Vasconcelos',
          
          onTap: () {},
        ),
      ],
    );
  }
}
