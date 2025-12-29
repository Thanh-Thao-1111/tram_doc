import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/friend_model.dart';
import '../models/user_profile.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== SEARCH USERS ====================

  /// Search users by email or name
  Future<List<UserProfile>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final uid = currentUserId;
    if (uid == null) return [];

    final queryLower = query.toLowerCase().trim();

    // Search by email (exact or prefix match)
    final emailResults = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: queryLower)
        .where('email', isLessThan: '${queryLower}z')
        .limit(10)
        .get();

    // Also search by displayName
    final nameResults = await _firestore
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThan: '${query}z')
        .limit(10)
        .get();

    // Combine results and filter out current user
    final Set<String> seenIds = {};
    final List<UserProfile> users = [];

    for (var doc in [...emailResults.docs, ...nameResults.docs]) {
      if (doc.id != uid && !seenIds.contains(doc.id)) {
        seenIds.add(doc.id);
        users.add(UserProfile.fromFirestore(doc));
      }
    }

    return users;
  }

  // ==================== FRIEND REQUESTS ====================

  /// Send a friend request
  Future<void> sendFriendRequest(String toUserId) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Vui lòng đăng nhập';

    // Check if already friends
    final friendDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .doc(toUserId)
        .get();
    
    if (friendDoc.exists) throw 'Đã là bạn bè';

    // Check if request already exists
    final existingRequest = await _firestore
        .collection('users')
        .doc(toUserId)
        .collection('friendRequests')
        .where('fromUserId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'pending')
        .get();

    if (existingRequest.docs.isNotEmpty) throw 'Đã gửi lời mời kết bạn';

    // Get sender info
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    final request = FriendRequest(
      id: '',
      fromUserId: user.uid,
      fromUserName: userData['displayName'] ?? userData['username'] ?? user.email?.split('@').first ?? 'Người dùng',
      fromUserAvatar: userData['photoURL'],
      fromUserEmail: user.email ?? '',
      toUserId: toUserId,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(toUserId)
        .collection('friendRequests')
        .add(request.toFirestore());
  }

  /// Get friend requests for current user
  Stream<List<FriendRequest>> getFriendRequestsStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => FriendRequest.fromFirestore(doc)).toList());
  }

  /// Accept a friend request
  Future<void> acceptFriendRequest(String requestId) async {
    final uid = currentUserId;
    if (uid == null) throw 'Vui lòng đăng nhập';

    // Get the request
    final requestDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .doc(requestId)
        .get();

    if (!requestDoc.exists) throw 'Lời mời không tồn tại';

    final request = FriendRequest.fromFirestore(requestDoc);

    // Get both users' info
    final fromUserDoc = await _firestore.collection('users').doc(request.fromUserId).get();
    final toUserDoc = await _firestore.collection('users').doc(uid).get();

    final fromUserData = fromUserDoc.data() ?? {};
    final toUserData = toUserDoc.data() ?? {};

    // Add to both users' friends lists
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(request.fromUserId)
        .set({
          'displayName': fromUserData['displayName'] ?? fromUserData['username'] ?? request.fromUserName,
          'email': request.fromUserEmail,
          'avatarUrl': fromUserData['photoURL'],
          'addedAt': FieldValue.serverTimestamp(),
        });

    await _firestore
        .collection('users')
        .doc(request.fromUserId)
        .collection('friends')
        .doc(uid)
        .set({
          'displayName': toUserData['displayName'] ?? toUserData['username'] ?? _auth.currentUser?.email?.split('@').first,
          'email': toUserData['email'] ?? _auth.currentUser?.email,
          'avatarUrl': toUserData['photoURL'],
          'addedAt': FieldValue.serverTimestamp(),
        });

    // Update request status
    await requestDoc.reference.update({'status': 'accepted'});
  }

  /// Reject a friend request
  Future<void> rejectFriendRequest(String requestId) async {
    final uid = currentUserId;
    if (uid == null) throw 'Vui lòng đăng nhập';

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .doc(requestId)
        .update({'status': 'rejected'});
  }

  // ==================== FRIENDS ====================

  /// Get friends list
  Stream<List<FriendModel>> getFriendsStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => FriendModel.fromFirestore(doc)).toList());
  }

  /// Remove a friend
  Future<void> removeFriend(String friendUserId) async {
    final uid = currentUserId;
    if (uid == null) throw 'Vui lòng đăng nhập';

    // Remove from both users' friend lists
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(friendUserId)
        .delete();

    await _firestore
        .collection('users')
        .doc(friendUserId)
        .collection('friends')
        .doc(uid)
        .delete();
  }

  /// Get friends count
  Future<int> getFriendsCount() async {
    final uid = currentUserId;
    if (uid == null) return 0;

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// Get books from friends for suggestions
  Future<List<FriendBookSuggestion>> getFriendBooks() async {
    final uid = currentUserId;
    if (uid == null) return [];

    try {
      // Get list of friends
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('friends')
          .get();

      if (friendsSnapshot.docs.isEmpty) return [];

      final List<FriendBookSuggestion> suggestions = [];
      final Set<String> seenBooks = {}; // Avoid duplicates by title

      // Get books from each friend
      for (var friendDoc in friendsSnapshot.docs) {
        final friendId = friendDoc.id;
        final friendData = friendDoc.data();
        final friendName = friendData['displayName'] ?? 'Bạn bè';

        // Get friend's books
        final booksSnapshot = await _firestore
            .collection('books')
            .where('userId', isEqualTo: friendId)
            .limit(5) // Limit per friend
            .get();

        for (var bookDoc in booksSnapshot.docs) {
          final bookData = bookDoc.data();
          final bookTitle = bookData['title'] ?? '';
          
          // Skip if already seen this book
          if (seenBooks.contains(bookTitle.toLowerCase())) continue;
          seenBooks.add(bookTitle.toLowerCase());

          suggestions.add(FriendBookSuggestion(
            bookId: bookDoc.id,
            title: bookTitle,
            author: bookData['author'] ?? '',
            imageUrl: bookData['imageUrl'] ?? '',
            description: bookData['description'],
            pageCount: bookData['pageCount'] ?? 0,
            friendName: friendName,
            friendId: friendId,
          ));
        }

        if (suggestions.length >= 10) break; // Limit total suggestions
      }

      return suggestions;
    } catch (e) {
      print('Error getting friend books: $e');
      return [];
    }
  }

  /// Get books for a specific user (for viewing friend's bookshelf)
  Future<List<Map<String, dynamic>>> getUserBooks(String userId) async {
    try {
      final booksSnapshot = await _firestore
          .collection('books')
          .where('userId', isEqualTo: userId)
          .get();

      return booksSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'author': data['author'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'description': data['description'],
          'pageCount': data['pageCount'] ?? 0,
          'currentPage': data['currentPage'] ?? 0,
          'readingStatus': data['readingStatus'] ?? 'wantToRead',
        };
      }).toList();
    } catch (e) {
      print('Error getting user books: $e');
      return [];
    }
  }

  /// Check if user is a friend
  Future<bool> isFriend(String userId) async {
    final uid = currentUserId;
    if (uid == null) return false;

    final friendDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(userId)
        .get();

    return friendDoc.exists;
  }

  /// Get user profile by ID
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() ?? {};
      return {
        'uid': doc.id,
        'email': data['email'] ?? '',
        'displayName': data['displayName'] ?? data['username'] ?? data['email']?.split('@').first ?? 'Người dùng',
        'photoURL': data['photoURL'],
        'bio': data['bio'],
      };
    } catch (e) {
      return null;
    }
  }
}

/// Model for friend book suggestion
class FriendBookSuggestion {
  final String bookId;
  final String title;
  final String author;
  final String imageUrl;
  final String? description;
  final int pageCount;
  final String friendName;
  final String friendId;

  FriendBookSuggestion({
    required this.bookId,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.description,
    required this.pageCount,
    required this.friendName,
    required this.friendId,
  });
}

