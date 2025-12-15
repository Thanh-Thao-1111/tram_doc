import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'friend_profile_page.dart';

class CommunityFriendsTab extends StatelessWidget {
  const CommunityFriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        _SearchBox(
          hint: 'Tìm kiếm bạn bè...',
          onTap: () {},
        ),
        const SizedBox(height: 12),

        const Text('Lời mời kết bạn (2)', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const _InviteTile(
          avatar: 'assets/images/avatars/minh_anh.png',
          name: 'Minh Anh',
          email: 'minhanh@email.com',
        ),
        const _InviteTile(
          avatar: 'assets/images/avatars/bao_ngoc.png',
          name: 'Bảo Ngọc',
          email: 'baongoc@email.com',
        ),

        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(child: Text('Bạn bè (5)', style: TextStyle(fontWeight: FontWeight.w800))),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1, size: 18, color: AppColors.primary),
              label: const Text('Thêm bạn', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        const SizedBox(height: 6),

        _FriendTile(
          avatar: 'assets/images/avatars/an_nhien.png',
          name: 'An Nhiên',
          email: 'annhien@email.com',
          onTap: () {},
        ),
        _FriendTile(
          avatar: 'assets/images/avatars/gia_han.png',
          name: 'Gia Hân',
          email: 'giahan@email.com',
          onTap: () {},
        ),
        _FriendTile(
          avatar: 'assets/images/avatars/hoang_khoi.png',
          name: 'Hoàng Khôi',
          email: 'hoangkhoi@email.com',
          onTap: () {},
        ),
        _FriendTile(
          avatar: 'assets/images/avatars/tue_minh.png',
          name: 'Tuệ Minh',
          email: 'tueminh@email.com',
          onTap: () {},
        ),
        _FriendTile(
          avatar: 'assets/images/avatars/lan_chi.png',
          name: 'Lan Chi',
          email: 'lanchi@email.com',
          onTap: () {
            // mở trang bạn bè (ví dụ Lan Chi)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FriendProfilePage()),
            );
          },
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;
  const _SearchBox({required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.subText),
          const SizedBox(width: 10),
          Expanded(child: Text(hint, style: const TextStyle(color: AppColors.subText))),
        ],
      ),
    );
  }
}

class _InviteTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String email;

  const _InviteTile({required this.avatar, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(email, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIconButton(
              bg: AppColors.primarySoft,
              icon: Icons.check,
              iconColor: AppColors.primary,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _CircleIconButton(
              bg: const Color(0xFFFEE2E2),
              icon: Icons.close,
              iconColor: AppColors.danger,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String email;
  final VoidCallback onTap;

  const _FriendTile({required this.avatar, required this.name, required this.email, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(email, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
        trailing: const Icon(Icons.more_horiz, color: AppColors.subText),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.bg,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
