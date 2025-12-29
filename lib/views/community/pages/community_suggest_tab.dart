import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../viewmodels/community_viewmodel.dart';
import '../../../services/friend_service.dart';
import '../../library/pages/book_detail_page.dart';
import '../widgets/suggestion_card.dart';

class CommunitySuggestTab extends StatefulWidget {
  const CommunitySuggestTab({super.key});

  @override
  State<CommunitySuggestTab> createState() => _CommunitySuggestTabState();
}

class _CommunitySuggestTabState extends State<CommunitySuggestTab> {
  @override
  void initState() {
    super.initState();
    // Load friend books when tab opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityViewModel>().loadFriendBooks();
    });
  }

  void _viewBookDetail(BuildContext context, FriendBookSuggestion suggestion) {
    final libraryViewModel = context.read<LibraryViewModel>();
    
    // Tạo BookModel từ suggestion
    final book = BookModel(
      id: null,
      title: suggestion.title,
      author: suggestion.author,
      imageUrl: suggestion.imageUrl,
      description: suggestion.description,
      pageCount: suggestion.pageCount,
      currentPage: 0,
      readingStatus: ReadingStatus.wantToRead,
    );
    
    // Set current book và điều hướng
    libraryViewModel.setCurrentBook(book);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BookDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommunityViewModel>();
    final suggestions = viewModel.friendBookSuggestions;

    if (suggestions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_stories, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                'Chưa có gợi ý nào',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kết bạn với những người yêu sách để nhận gợi ý sách từ họ!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  // Switch to Friends tab (index 1 in the Community page tabs)
                  DefaultTabController.of(context).animateTo(1);
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Tìm bạn ngay'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadFriendBooks(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return SuggestionCard(
            line1: '${suggestion.friendName} đã đọc',
            title: suggestion.title,
            author: suggestion.author,
            coverUrl: suggestion.imageUrl,
            onTap: () => _viewBookDetail(context, suggestion),
          );
        },
      ),
    );
  }
}
