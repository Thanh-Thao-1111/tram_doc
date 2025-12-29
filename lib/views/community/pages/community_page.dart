import 'package:flutter/material.dart';
import '../widgets/community_tokens.dart';
import 'community_feed_tab.dart';
import 'community_friends_tab.dart';
import 'community_suggest_tab.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: CommunityTokens.bg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          title: const Text('Cộng đồng', style: TextStyle(fontWeight: FontWeight.w900, color: CommunityTokens.text)),
          bottom: const TabBar(
            indicatorColor: CommunityTokens.primary,
            labelColor: CommunityTokens.primary,
            unselectedLabelColor: CommunityTokens.subText,
            labelStyle: TextStyle(fontWeight: FontWeight.w900),
            tabs: [
              Tab(text: 'Bảng tin'),
              Tab(text: 'Bạn bè'),
              Tab(text: 'Gợi ý'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CommunityFeedTab(),
            CommunityFriendsTab(),
            CommunitySuggestTab(),
          ],
        ),
      ),
    );
  }
}
