import 'package:flutter/material.dart';
import '../widgets/community_tokens.dart';
import '../widgets/stat_tile.dart';
import '../widgets/user_book_grid.dart';

class FriendProfilePage extends StatelessWidget {
  const FriendProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final books = const [
      UserBook(title: 'Đảo Mộng Mơ', author: 'Nguyễn Nhật Ánh',coverAsset: 'assets/images/books/9.png',),
      UserBook(title: 'Sapiens Lược sử...', author: 'Yuval Noah',coverAsset: 'assets/images/books/10.png',),
      UserBook(title: 'Nhà Của Kim', author: 'Kim',coverAsset: 'assets/images/books/11.png',),
      UserBook(title: 'Đắc Nhân Tâm', author: 'Dale Carnegie',coverAsset: 'assets/images/books/12.png',),
      UserBook(title: 'Tư Duy Nhanh Và Chậm', author: 'Daniel Kahneman',coverAsset: 'assets/images/books/3.png',),
      UserBook(title: 'Kỷ Án Hồ Sơ X', author: 'Trần Xuân',coverAsset: 'assets/images/books/5.png',),
    ];

    return Scaffold(
      backgroundColor: CommunityTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: CommunityTokens.text),
        title: const Text(
          'Cộng đồng',
          style: TextStyle(fontWeight: FontWeight.w900, color: CommunityTokens.text),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          // Header user
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CommunityTokens.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/avatars/lan_chi.png'),
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lan Chi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('50 cuốn sách', style: TextStyle(color: CommunityTokens.subText, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Center(
                    child: Text(
                      'Đang theo dõi',
                      style: TextStyle(fontWeight: FontWeight.w800, color: CommunityTokens.subText),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: StatTile(
                  value: '50',
                  label: 'Sách đã đọc',
                  valueColor: CommunityTokens.primary,
                  bg: CommunityTokens.primarySoft,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  value: '12',
                  label: 'Chuỗi đọc (ngày)',
                  valueColor: CommunityTokens.orange,
                  bg: CommunityTokens.orangeSoft,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Text(
            'Tủ sách của Lan Chi',
            style: TextStyle(fontWeight: FontWeight.w900, color: CommunityTokens.text),
          ),
          const SizedBox(height: 12),

          UserBookGrid(books: books),
        ],
      ),
    );
  }
}
