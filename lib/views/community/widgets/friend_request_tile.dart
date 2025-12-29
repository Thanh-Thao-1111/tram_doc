import 'package:flutter/material.dart';
import 'community_tokens.dart';

class FriendRequestTile extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarAsset;
  final String? avatarUrl; // Network image URL
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestTile({
    super.key,
    required this.name,
    required this.email,
    this.avatarAsset,
    this.avatarUrl,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: CommunityTokens.card, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE5E7EB),
          backgroundImage: _getAvatarImage(),
          child: _shouldShowDefaultAvatar() ? const Icon(Icons.person, color: Colors.white) : null,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(email, style: const TextStyle(fontSize: 12, color: CommunityTokens.subText)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleBtn(
              bg: const Color(0xFF16A34A),
              icon: Icons.check,
              onTap: onAccept,
            ),
            const SizedBox(width: 10),
            _CircleBtn(
              bg: const Color(0xFFE5E7EB),
              icon: Icons.close,
              iconColor: const Color(0xFF6B7280),
              onTap: onReject,
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _getAvatarImage() {
    if (avatarUrl != null) return NetworkImage(avatarUrl!);
    if (avatarAsset != null) return AssetImage(avatarAsset!);
    return null;
  }

  bool _shouldShowDefaultAvatar() => avatarUrl == null && avatarAsset == null;
}

class _CircleBtn extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.bg,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
