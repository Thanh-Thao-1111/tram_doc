import 'package:flutter/material.dart';
import '../widgets/community_tokens.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_tile.dart';
import 'friend_profile_page.dart';

class CommunityFriendsTab extends StatelessWidget {
  const CommunityFriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        // Search
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: const TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.search),
              hintText: 'Tìm kiếm bạn bè...',
              hintStyle: TextStyle(color: CommunityTokens.subText),
            ),
          ),
        ),

        const SizedBox(height: 14),
        const Text('Lời mời kết bạn (2)', style: TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),

        FriendRequestTile(
          name: 'Minh Anh',
          email: 'minhanh@email.com',
          avatarAsset: 'assets/images/avatars/minh_anh.png',
          onAccept: () {},
          onReject: () {},
        ),
       FriendTile(
  name: 'Lan Chi',
  email: 'lanchi@email.com',
  avatarAsset: 'assets/images/avatars/lan_chi.png',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FriendProfilePage()),
    );
  },
),


        const SizedBox(height: 6),
        Row(
          children: [
            const Expanded(
              child: Text('Bạn bè (5)', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommunityTokens.primarySoft,
                  foregroundColor: CommunityTokens.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Thêm bạn', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        const FriendTile(name: 'An Nhiên', email: 'annhien@email.com',avatarAsset: 'assets/images/avatars/an_nhien.png'),
        const FriendTile(name: 'Gia Hân', email: 'giahan@email.com',avatarAsset: 'assets/images/avatars/gia_han.png'),
        const FriendTile(name: 'Hoàng Khôi', email: 'hoangkhoi@email.com',avatarAsset: 'assets/images/avatars/hoang_khoi.png'),
        const FriendTile(name: 'Tuệ Minh', email: 'tueminh@email.com',avatarAsset: 'assets/images/avatars/tue_minh.png'),
        const FriendTile(name: 'Quốc Trung', email: 'quoctrung@email.com',avatarAsset: 'assets/images/avatars/quoc_trung.png'),
      ],
    );
  }
}
