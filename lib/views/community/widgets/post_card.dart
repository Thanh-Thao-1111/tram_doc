import 'package:flutter/material.dart';
import 'community_tokens.dart';

class PostCard extends StatelessWidget {
  final String name;
  final String time;
  final String actionText; // "đã ghi chú..." / "vừa hoàn thành..."
  final String? avatarAsset;

  final String? bookTitle;
  final String? bookAuthor;
  final String? bookCoverAsset;

  final String? note; // đoạn quote (post 1)

  const PostCard({
    super.key,
    required this.name,
    required this.time,
    required this.actionText,
    this.avatarAsset,
    this.bookTitle,
    this.bookAuthor,
    this.bookCoverAsset,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CommunityTokens.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE5E7EB),
                backgroundImage: avatarAsset == null ? null : AssetImage(avatarAsset!),
                child: avatarAsset == null ? const Icon(Icons.person, color: Colors.white) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: CommunityTokens.text, fontSize: 12),
                    children: [
                      TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: ' $actionText'),
                    ],
                  ),
                ),
              ),
              Text(time, style: const TextStyle(fontSize: 11, color: CommunityTokens.subText)),
            ],
          ),

          if (note != null) ...[
            const SizedBox(height: 10),
            Text(
              '“$note”',
              style: const TextStyle(color: CommunityTokens.subText, height: 1.4),
            ),
          ],

          if (bookTitle != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: bookCoverAsset == null
                        ? Container(
                            color: const Color(0xFFE5E7EB),
                            child: const Icon(Icons.menu_book, color: Colors.white),
                          )
                        : Image.asset(bookCoverAsset!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookTitle!, style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(bookAuthor ?? '', style: const TextStyle(color: CommunityTokens.subText, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 34,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommunityTokens.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: const Text('Bình luận', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
