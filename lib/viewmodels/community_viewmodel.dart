import 'package:flutter/material.dart';
import '../models/community_post_model.dart';
import '../models/comment_model.dart';
import '../models/friend_model.dart';
import '../models/user_profile.dart';
import '../services/community_service.dart';
import '../services/friend_service.dart';

class CommunityViewModel extends ChangeNotifier {
  final CommunityService _communityService = CommunityService();
  final FriendService _friendService = FriendService();

  // State
  bool _isLoading = false;
  String? _errorMessage;

  // Posts
  List<CommunityPost> _posts = [];
  List<CommentModel> _comments = [];

  // Friends
  List<FriendModel> _friends = [];
  List<FriendRequest> _friendRequests = [];
  List<UserProfile> _searchResults = [];
  String _searchQuery = '';

  // Friend book suggestions
  List<FriendBookSuggestion> _friendBookSuggestions = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CommunityPost> get posts => _posts;
  List<CommentModel> get comments => _comments;
  List<FriendModel> get friends => _friends;
  List<FriendRequest> get friendRequests => _friendRequests;
  List<UserProfile> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  List<FriendBookSuggestion> get friendBookSuggestions => _friendBookSuggestions;

  // ==================== POSTS ====================

  /// Initialize streams
  void initStreams() {
    _communityService.getPostsStream().listen((posts) {
      _posts = posts;
      notifyListeners();
    });

    _friendService.getFriendsStream().listen((friends) {
      _friends = friends;
      notifyListeners();
      // Reload friend books when friends list changes
      loadFriendBooks();
    });

    _friendService.getFriendRequestsStream().listen((requests) {
      _friendRequests = requests;
      notifyListeners();
    });

    // Load friend book suggestions
    loadFriendBooks();
  }

  /// Load books from friends for suggestions
  Future<void> loadFriendBooks() async {
    try {
      _friendBookSuggestions = await _friendService.getFriendBooks();
      notifyListeners();
    } catch (e) {
      print('Error loading friend books: $e');
    }
  }


  /// Create a new post
  Future<bool> createPost({
    required String actionText,
    String? bookTitle,
    String? bookAuthor,
    String? bookCoverUrl,
    String? noteContent,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _communityService.createPost(
        actionText: actionText,
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
        bookCoverUrl: bookCoverUrl,
        noteContent: noteContent,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a post
  Future<bool> deletePost(String postId) async {
    try {
      await _communityService.deletePost(postId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== COMMENTS ====================

  /// Load comments for a post
  void loadComments(String postId) {
    _comments = [];
    notifyListeners();
    
    _communityService.getCommentsStream(postId).listen((comments) {
      _comments = comments;
      notifyListeners();
    });
  }

  /// Add a comment
  Future<bool> addComment(String postId, String content) async {
    if (content.trim().isEmpty) {
      _errorMessage = 'Vui lòng nhập nội dung bình luận';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _communityService.addComment(postId, content);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a comment
  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      await _communityService.deleteComment(postId, commentId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== FRIENDS ====================

  /// Search users
  Future<void> searchUsers(String query) async {
    _searchQuery = query;
    
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _friendService.searchUsers(query);
    } catch (e) {
      _searchResults = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  /// Send friend request
  Future<bool> sendFriendRequest(String toUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _friendService.sendFriendRequest(toUserId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Accept friend request
  Future<bool> acceptFriendRequest(String requestId) async {
    try {
      await _friendService.acceptFriendRequest(requestId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Reject friend request
  Future<bool> rejectFriendRequest(String requestId) async {
    try {
      await _friendService.rejectFriendRequest(requestId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove friend
  Future<bool> removeFriend(String friendUserId) async {
    try {
      await _friendService.removeFriend(friendUserId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
