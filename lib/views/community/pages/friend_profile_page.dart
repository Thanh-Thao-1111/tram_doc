import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/friend_service.dart';
import '../../../viewmodels/community_viewmodel.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../models/book_model.dart';
import '../../library/pages/book_detail_page.dart';
import '../widgets/community_tokens.dart';
import '../widgets/stat_tile.dart';

class FriendProfilePage extends StatefulWidget {
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userAvatar;

  const FriendProfilePage({
    super.key,
    this.userId,
    this.userName,
    this.userEmail,
    this.userAvatar,
  });

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final FriendService _friendService = FriendService();
  
  bool _isLoading = true;
  bool _isFriend = false;
  bool _isProcessing = false;
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _userBooks = [];
  
  int get _booksRead => _userBooks.where((b) => b['readingStatus'] == 'finished').length;
  int get _totalBooks => _userBooks.length;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Load user profile
      _userProfile = await _friendService.getUserProfile(widget.userId!);
      
      // Check if friend
      _isFriend = await _friendService.isFriend(widget.userId!);
      
      // Load user's books
      _userBooks = await _friendService.getUserBooks(widget.userId!);
    } catch (e) {
      print('Error loading friend profile: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _toggleFollow() async {
    if (widget.userId == null || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      if (_isFriend) {
        // Hủy kết bạn
        await _friendService.removeFriend(widget.userId!);
        if (mounted) {
          setState(() => _isFriend = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã hủy theo dõi')),
          );
        }
      } else {
        // Gửi lời mời kết bạn
        await _friendService.sendFriendRequest(widget.userId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã gửi lời mời kết bạn!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }

    if (mounted) setState(() => _isProcessing = false);
  }

  void _viewBookDetail(Map<String, dynamic> bookData) {
    final libraryViewModel = context.read<LibraryViewModel>();
    
    final book = BookModel(
      id: bookData['id'],
      title: bookData['title'] ?? '',
      author: bookData['author'] ?? '',
      imageUrl: bookData['imageUrl'] ?? '',
      description: bookData['description'],
      pageCount: bookData['pageCount'] ?? 0,
      currentPage: bookData['currentPage'] ?? 0,
      readingStatus: ReadingStatus.wantToRead,
    );
    
    libraryViewModel.setCurrentBook(book);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BookDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _userProfile?['displayName'] ?? widget.userName ?? 'Người dùng';
    final photoUrl = _userProfile?['photoURL'] ?? widget.userAvatar;
    final email = _userProfile?['email'] ?? widget.userEmail ?? '';

    return Scaffold(
      backgroundColor: CommunityTokens.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: CommunityTokens.text),
        title: const Text(
          'Hồ sơ',
          style: TextStyle(fontWeight: FontWeight.w900, color: CommunityTokens.text),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                // Header user
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: CommunityTokens.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFE5E7EB),
                        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                        child: photoUrl == null 
                            ? const Icon(Icons.person, color: Colors.white, size: 28) 
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email.isNotEmpty ? email : '$_totalBooks cuốn sách',
                              style: const TextStyle(color: CommunityTokens.subText, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      _buildFollowButton(),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        value: '$_booksRead',
                        label: 'Sách đã đọc',
                        valueColor: CommunityTokens.primary,
                        bg: CommunityTokens.primarySoft,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        value: '$_totalBooks',
                        label: 'Tổng số sách',
                        valueColor: CommunityTokens.orange,
                        bg: CommunityTokens.orangeSoft,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                Text(
                  'Tủ sách của $displayName',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: CommunityTokens.text),
                ),
                const SizedBox(height: 12),

                // Books grid
                _userBooks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.library_books_outlined, size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              const Text(
                                'Chưa có sách nào',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _userBooks.length,
                        itemBuilder: (context, index) {
                          final book = _userBooks[index];
                          return _buildBookItem(book);
                        },
                      ),
              ],
            ),
    );
  }

  Widget _buildFollowButton() {
    return GestureDetector(
      onTap: _isProcessing ? null : _toggleFollow,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _isFriend ? const Color(0xFFE5E7EB) : CommunityTokens.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: _isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  _isFriend ? 'Đang theo dõi' : 'Theo dõi',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _isFriend ? CommunityTokens.subText : Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBookItem(Map<String, dynamic> book) {
    final imageUrl = book['imageUrl'] ?? '';
    final title = book['title'] ?? '';
    final author = book['author'] ?? '';

    return GestureDetector(
      onTap: () => _viewBookDetail(book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE5E7EB),
                        child: const Icon(Icons.menu_book, color: Colors.white),
                      ),
                    )
                  : Container(
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.menu_book, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            author,
            style: const TextStyle(color: CommunityTokens.subText, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
