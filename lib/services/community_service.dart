import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/community_post_model.dart';
import '../models/comment_model.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== POSTS ====================

  /// Stream of community posts (ordered by createdAt desc)
  Stream<List<CommunityPost>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => CommunityPost.fromFirestore(doc)).toList());
  }

  /// Get posts for a specific user
  Stream<List<CommunityPost>> getUserPostsStream(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => CommunityPost.fromFirestore(doc)).toList());
  }

  /// Create a new post
  Future<void> createPost({
    required String actionText,
    String? bookTitle,
    String? bookAuthor,
    String? bookCoverUrl,
    String? noteContent,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Vui lòng đăng nhập để đăng bài';

    // Get user profile for name and avatar
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    final post = CommunityPost(
      id: '',
      userId: user.uid,
      userName: userData['displayName'] ?? userData['username'] ?? user.email?.split('@').first ?? 'Người dùng',
      userAvatar: userData['photoURL'],
      actionText: actionText,
      bookTitle: bookTitle,
      bookAuthor: bookAuthor,
      bookCoverUrl: bookCoverUrl,
      noteContent: noteContent,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('posts').add(post.toFirestore());
  }

  /// Delete a post
  Future<void> deletePost(String postId) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Vui lòng đăng nhập';

    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (!postDoc.exists) throw 'Bài viết không tồn tại';
    
    final postData = postDoc.data()!;
    if (postData['userId'] != user.uid) throw 'Bạn không có quyền xóa bài viết này';

    // Delete all comments first
    final comments = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();
    
    for (var comment in comments.docs) {
      await comment.reference.delete();
    }

    // Delete the post
    await _firestore.collection('posts').doc(postId).delete();
  }

  // ==================== COMMENTS ====================

  /// Stream of comments for a post
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList());
  }

  /// Add a comment to a post
  Future<void> addComment(String postId, String content) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Vui lòng đăng nhập để bình luận';

    // Get user profile
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    final comment = CommentModel(
      id: '',
      postId: postId,
      userId: user.uid,
      userName: userData['displayName'] ?? userData['username'] ?? user.email?.split('@').first ?? 'Người dùng',
      userAvatar: userData['photoURL'],
      content: content,
      createdAt: DateTime.now(),
    );

    // Add comment
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment.toFirestore());

    // Update comment count
    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  /// Delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Vui lòng đăng nhập';

    final commentDoc = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();

    if (!commentDoc.exists) throw 'Bình luận không tồn tại';
    
    final commentData = commentDoc.data()!;
    if (commentData['userId'] != user.uid) throw 'Bạn không có quyền xóa bình luận này';

    await commentDoc.reference.delete();

    // Update comment count
    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(-1),
    });
  }
}
