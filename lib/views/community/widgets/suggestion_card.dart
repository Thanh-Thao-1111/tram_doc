import 'package:flutter/material.dart';
import 'community_tokens.dart';

class SuggestionCard extends StatelessWidget {
  final String line1;
  final String title;
  final String author;
  final String? coverAsset;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.line1,
    required this.title,
    required this.author,
    this.coverAsset,
    required this.onTap,
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 60,
              height: 80,
              child: coverAsset == null
                  ? Container(
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.menu_book, color: Colors.white),
                    )
                  : Image.asset(coverAsset!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line1, style: const TextStyle(fontSize: 12, color: CommunityTokens.primary, height: 1.2)),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(author, style: const TextStyle(fontSize: 12, color: CommunityTokens.subText)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CommunityTokens.primarySoft,
                foregroundColor: CommunityTokens.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: onTap,
              child: const Text('Xem chi tiết', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
