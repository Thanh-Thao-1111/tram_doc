import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/community_viewmodel.dart';
import '../widgets/community_tokens.dart';
import '../widgets/friend_request_tile.dart';
import '../widgets/friend_tile.dart';
import '../widgets/add_friend_dialog.dart';
import 'friend_profile_page.dart';

class CommunityFriendsTab extends StatefulWidget {
  const CommunityFriendsTab({super.key});

  @override
  State<CommunityFriendsTab> createState() => _CommunityFriendsTabState();
}

class _CommunityFriendsTabState extends State<CommunityFriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _localFilter = '';

  @override
  void initState() {
    super.initState();
    // Initialize streams
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityViewModel>().initStreams();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddFriendDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommunityViewModel>();
    final friends = viewModel.friends;
    final requests = viewModel.friendRequests;

    // Filter friends by local search
    final filteredFriends = _localFilter.isEmpty
        ? friends
        : friends.where((f) =>
            f.displayName.toLowerCase().contains(_localFilter.toLowerCase()) ||
            f.email.toLowerCase().contains(_localFilter.toLowerCase())
          ).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        // Search
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.search),
              hintText: 'Tìm kiếm bạn bè...',
              hintStyle: TextStyle(color: CommunityTokens.subText),
            ),
            onChanged: (value) {
              setState(() => _localFilter = value);
            },
          ),
        ),

        // Friend Requests
        if (requests.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            'Lời mời kết bạn (${requests.length})',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...requests.map((request) => FriendRequestTile(
            name: request.fromUserName,
            email: request.fromUserEmail,
            avatarUrl: request.fromUserAvatar,
            onAccept: () async {
              final success = await viewModel.acceptFriendRequest(request.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã chấp nhận lời mời kết bạn!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            onReject: () async {
              await viewModel.rejectFriendRequest(request.id);
            },
          )),
        ],

        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Text(
                'Bạn bè (${friends.length})',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommunityTokens.primarySoft,
                  foregroundColor: CommunityTokens.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _showAddFriendDialog,
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Thêm bạn', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Friends list
        if (filteredFriends.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.people_outline, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  const Text(
                    'Chưa có bạn bè nào',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _showAddFriendDialog,
                    child: const Text('Tìm bạn ngay'),
                  ),
                ],
              ),
            ),
          )
        else
          ...filteredFriends.map((friend) => FriendTile(
            name: friend.displayName,
            email: friend.email,
            avatarUrl: friend.avatarUrl,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FriendProfilePage(
                    userId: friend.userId,
                    userName: friend.displayName,
                    userEmail: friend.email,
                    userAvatar: friend.avatarUrl,
                  ),
                ),
              );
            },
          )),
      ],
    );
  }
}
