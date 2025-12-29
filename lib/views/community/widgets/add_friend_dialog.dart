import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/community_viewmodel.dart';
import 'community_tokens.dart';

class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({super.key});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<CommunityViewModel>().clearSearch();
      return;
    }
    
    setState(() => _isSearching = true);
    context.read<CommunityViewModel>().searchUsers(query).then((_) {
      if (mounted) setState(() => _isSearching = false);
    });
  }

  Future<void> _sendRequest(String userId) async {
    final viewModel = context.read<CommunityViewModel>();
    final success = await viewModel.sendFriendRequest(userId);
    
    if (!mounted) return;
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi lời mời kết bạn!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Không thể gửi lời mời'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommunityViewModel>();
    final results = viewModel.searchResults;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thêm bạn bè',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    viewModel.clearSearch();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Search field
            Container(
              decoration: BoxDecoration(
                color: CommunityTokens.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Tìm theo tên hoặc email...',
                  hintStyle: TextStyle(color: CommunityTokens.subText),
                ),
                onChanged: _onSearch,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Results
            Flexible(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : results.isEmpty
                      ? _searchController.text.isEmpty
                          ? const Center(
                              child: Text(
                                'Nhập tên hoặc email để tìm kiếm',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Không tìm thấy người dùng nào',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final user = results[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                backgroundImage: user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : null,
                                child: user.photoURL == null
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                user.effectiveDisplayName,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                user.email,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.person_add, color: CommunityTokens.primary),
                                onPressed: () => _sendRequest(user.uid),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
