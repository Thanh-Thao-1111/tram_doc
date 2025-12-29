import 'package:cloud_firestore/cloud_firestore.dart';

/// Trạng thái lời mời kết bạn
enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
}

/// Model cho người bạn
class FriendModel {
  final String userId;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final DateTime? addedAt;

  FriendModel({
    required this.userId,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.addedAt,
  });

  factory FriendModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FriendModel(
      userId: doc.id,
      displayName: data['displayName'] ?? data['email']?.split('@').first ?? 'Người dùng',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      addedAt: (data['addedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}

/// Model cho lời mời kết bạn
class FriendRequest {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserAvatar;
  final String fromUserEmail;
  final String toUserId;
  final FriendRequestStatus status;
  final DateTime createdAt;

  FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserAvatar,
    required this.fromUserEmail,
    required this.toUserId,
    this.status = FriendRequestStatus.pending,
    required this.createdAt,
  });

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FriendRequest(
      id: doc.id,
      fromUserId: data['fromUserId'] ?? '',
      fromUserName: data['fromUserName'] ?? 'Người dùng',
      fromUserAvatar: data['fromUserAvatar'],
      fromUserEmail: data['fromUserEmail'] ?? '',
      toUserId: data['toUserId'] ?? '',
      status: FriendRequestStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => FriendRequestStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      if (fromUserAvatar != null) 'fromUserAvatar': fromUserAvatar,
      'fromUserEmail': fromUserEmail,
      'toUserId': toUserId,
      'status': status.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
