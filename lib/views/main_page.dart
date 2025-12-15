import 'package:flutter/material.dart';
import 'home_page.dart';
import 'library_page.dart';
import 'review_page.dart';
import 'community_page.dart';
import 'profile_page.dart';
import '../core/theme/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    LibraryPage(),
    ReviewPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.subText,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Thư viện'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), label: 'Ôn tập'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Cộng đồng'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}
