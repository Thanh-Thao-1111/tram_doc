import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
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
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Cộng đồng', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          titleSpacing: 16,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(46),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.subText,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'Bảng tin'),
                  Tab(text: 'Bạn bè'),
                  Tab(text: 'Gợi ý'),
                ],
              ),
            ),
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
