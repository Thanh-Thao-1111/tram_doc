import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../services/friend_service.dart';
import '../../../models/friend_model.dart';
import '../../../models/community_post_model.dart';
import '../../../viewmodels/review_viewmodel.dart';
import '../../../viewmodels/community_viewmodel.dart';
import '../../review/pages/flashcard_player_page.dart';

const Color notificationBgColor = Color(0xFFF7F7F7);
const Color primaryGreen = Color(0xFF3BA66B);

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FriendService _friendService = FriendService();

  @override
  Widget build(BuildContext context) {
    final reviewVm = context.watch<ReviewDashboardViewModel>();
    final communityVm = context.watch<CommunityViewModel>();
    
    return Scaffold(
      backgroundColor: notificationBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<List<FriendRequest>>(
        stream: _friendService.getFriendRequestsStream(),
        builder: (context, snapshot) {
          final requests = snapshot.data ?? [];
          final cardsToReview = reviewVm.cardsToReview;
          final friendPosts = communityVm.posts.take(5).toList();
          
          // Check if there are any notifications
          final hasReviewReminder = cardsToReview > 0;
          final hasFriendRequests = requests.isNotEmpty;
          final hasFriendActivity = friendPosts.isNotEmpty;
          
          if (!hasReviewReminder && !hasFriendRequests && !hasFriendActivity) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có thông báo nào',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              // === NHẮC NHỞ ÔN TẬP ===
              if (hasReviewReminder) ...[
                _buildSectionHeader('Nhắc nhở ôn tập', Icons.schedule, Colors.orange),
                _ReviewReminderItem(cardsToReview: cardsToReview),
              ],
              
              // === LỜI MỜI KẾT BẠN ===
              if (hasFriendRequests) ...[
                _buildSectionHeader('Lời mời kết bạn', Icons.person_add, primaryGreen),
                ...requests.map((request) => _FriendRequestNotificationItem(
                  request: request,
                  onAccept: () => _handleAccept(request),
                  onReject: () => _handleReject(request),
                )),
              ],
              
              // === HOẠT ĐỘNG TỪ BẠN BÈ ===
              if (hasFriendActivity) ...[
                _buildSectionHeader('Hoạt động từ bạn bè', Icons.groups, Colors.blue),
                ...friendPosts.map((post) => _FriendActivityItem(post: post)),
              ],
              
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept(FriendRequest request) async {
    try {
      await _friendService.acceptFriendRequest(request.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã chấp nhận lời mời của ${request.fromUserName}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleReject(FriendRequest request) async {
    try {
      await _friendService.rejectFriendRequest(request.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã từ chối lời mời'), backgroundColor: Colors.grey),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// === NHẮC NHỞ ÔN TẬP ===
class _ReviewReminderItem extends StatelessWidget {
  final int cardsToReview;

  const _ReviewReminderItem({required this.cardsToReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đã đến giờ ôn tập!',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bạn có $cardsToReview thẻ cần ôn tập hôm nay',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FlashcardPlayerPage(mode: "Ngẫu nhiên"),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Ôn tập'),
          ),
        ],
      ),
    );
  }
}

// === LỜI MỜI KẾT BẠN ===
class _FriendRequestNotificationItem extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _FriendRequestNotificationItem({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final timeAgo = _formatTimeAgo(request.createdAt);
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFFFF0E5),
            backgroundImage: request.fromUserAvatar != null
                ? NetworkImage(request.fromUserAvatar!)
                : null,
            child: request.fromUserAvatar == null
                ? Text(
                    request.fromUserName.isNotEmpty
                        ? request.fromUserName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: request.fromUserName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' muốn kết bạn với bạn'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Chấp nhận'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Từ chối', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}

// === HOẠT ĐỘNG TỪ BẠN BÈ ===
class _FriendActivityItem extends StatelessWidget {
  final CommunityPost post;

  const _FriendActivityItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.withOpacity(0.1),
            backgroundImage: post.userAvatar != null
                ? NetworkImage(post.userAvatar!)
                : null,
            child: post.userAvatar == null
                ? const Icon(Icons.person, color: Colors.blue)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${post.actionText}'),
                      if (post.bookTitle != null)
                        TextSpan(
                          text: ' ${post.bookTitle}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.timeAgo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (post.bookCoverUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                post.bookCoverUrl!,
                width: 40,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 40,
                  height: 56,
                  color: Colors.grey[200],
                  child: const Icon(Icons.book, size: 20, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
