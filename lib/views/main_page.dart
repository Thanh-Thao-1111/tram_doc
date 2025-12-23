import 'package:flutter/material.dart';

import 'community/community_page.dart';
import 'profile/profile_page.dart';
import 'library/library_page.dart';
import 'review/review_page.dart';
import 'homes/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  static const Color activeColor = Color(0xFF3BA66B);
  static const Color inactiveColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình
    final List<Widget> pages = [
      const HomeScreen(),      // Index 0
      const LibraryPage(),   // Index 1
      const ReviewPage(),    // Index 2
      const CommunityPage(), // Index 3
      const ProfilePage(),   // Index 4
    ];

    return Scaffold(
      // Giữ trạng thái trang khi chuyển tab
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Dùng setState để cập nhật UI ngay lập tức
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Ôn tập',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Cộng đồng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
