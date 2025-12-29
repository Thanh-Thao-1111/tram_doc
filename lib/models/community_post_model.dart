import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String actionText; // "đã ghi chú về...", "vừa hoàn thành đọc", etc.
  final String? bookTitle;
  final String? bookAuthor;
  final String? bookCoverUrl;
  final String? noteContent;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.actionText,
    this.bookTitle,
    this.bookAuthor,
    this.bookCoverUrl,
    this.noteContent,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CommunityPost(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Người dùng',
      userAvatar: data['userAvatar'],
      actionText: data['actionText'] ?? '',
      bookTitle: data['bookTitle'],
      bookAuthor: data['bookAuthor'],
      bookCoverUrl: data['bookCoverUrl'],
      noteContent: data['noteContent'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      if (userAvatar != null) 'userAvatar': userAvatar,
      'actionText': actionText,
      if (bookTitle != null) 'bookTitle': bookTitle,
      if (bookAuthor != null) 'bookAuthor': bookAuthor,
      if (bookCoverUrl != null) 'bookCoverUrl': bookCoverUrl,
      if (noteContent != null) 'noteContent': noteContent,
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': likeCount,
      'commentCount': commentCount,
    };
  }

  /// Format time for display
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
