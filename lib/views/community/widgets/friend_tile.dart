import 'package:flutter/material.dart';
import 'community_tokens.dart';

class FriendTile extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarAsset;
  final String? avatarUrl; // Network image URL
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const FriendTile({
    super.key,
    required this.name,
    required this.email,
    this.avatarAsset,
    this.avatarUrl,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: CommunityTokens.card, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE5E7EB),
          backgroundImage: _getAvatarImage(),
          child: _shouldShowDefaultAvatar() ? const Icon(Icons.person, color: Colors.white) : null,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(email, style: const TextStyle(fontSize: 12, color: CommunityTokens.subText)),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz, color: CommunityTokens.subText),
          onPressed: onMore,
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
