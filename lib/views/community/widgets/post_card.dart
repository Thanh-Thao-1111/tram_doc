import 'package:flutter/material.dart';
import 'community_tokens.dart';
import '../../../models/community_post_model.dart';
import '../pages/comments_page.dart';

class PostCard extends StatelessWidget {
  // For static data (backwards compatibility)
  final String? name;
  final String? time;
  final String? actionText;
  final String? avatarAsset;
  final String? bookTitle;
  final String? bookAuthor;
  final String? bookCoverAsset;
  final String? note;
  
  // For dynamic data from Firestore
  final CommunityPost? post;
  final int? commentCount;

  const PostCard({
    super.key,
    this.name,
    this.time,
    this.actionText,
    this.avatarAsset,
    this.bookTitle,
    this.bookAuthor,
    this.bookCoverAsset,
    this.note,
    this.post,
    this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    // Use post data if available, otherwise use static props
    final displayName = post?.userName ?? name ?? 'Người dùng';
    final displayTime = post?.timeAgo ?? time ?? '';
    final displayAction = post?.actionText ?? actionText ?? '';
    final displayNote = post?.noteContent ?? note;
    final displayBookTitle = post?.bookTitle ?? bookTitle;
    final displayBookAuthor = post?.bookAuthor ?? bookAuthor;
    final displayBookCover = post?.bookCoverUrl ?? bookCoverAsset;
    final displayCommentCount = commentCount ?? post?.commentCount ?? 0;

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
                backgroundImage: _getAvatarImage(),
                child: _shouldShowDefaultAvatar() 
                    ? const Icon(Icons.person, color: Colors.white) 
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: CommunityTokens.text, fontSize: 12),
                    children: [
                      TextSpan(text: displayName, style: const TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: ' $displayAction'),
                    ],
                  ),
                ),
              ),
              Text(displayTime, style: const TextStyle(fontSize: 11, color: CommunityTokens.subText)),
            ],
          ),

          if (displayNote != null && displayNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '"$displayNote"',
              style: const TextStyle(color: CommunityTokens.subText, height: 1.4),
            ),
          ],

          if (displayBookTitle != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: _buildBookCover(displayBookCover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayBookTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(displayBookAuthor ?? '', style: const TextStyle(color: CommunityTokens.subText, fontSize: 12)),
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
                onPressed: post != null 
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(post: post!),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: Text(
                  displayCommentCount > 0 ? 'Bình luận ($displayCommentCount)' : 'Bình luận',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getAvatarImage() {
    if (post?.userAvatar != null) {
      return NetworkImage(post!.userAvatar!);
    } else if (avatarAsset != null) {
      return AssetImage(avatarAsset!);
    }
    return null;
  }

  bool _shouldShowDefaultAvatar() {
    return post?.userAvatar == null && avatarAsset == null;
  }

  Widget _buildBookCover(String? coverUrl) {
    if (coverUrl == null) {
      return Container(
        color: const Color(0xFFE5E7EB),
        child: const Icon(Icons.menu_book, color: Colors.white),
      );
    }
    
    // Check if it's a network URL or asset
    if (coverUrl.startsWith('http')) {
      return Image.network(
        coverUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFE5E7EB),
          child: const Icon(Icons.menu_book, color: Colors.white),
        ),
      );
    } else {
      return Image.asset(coverUrl, fit: BoxFit.cover);
    }
  }
}
