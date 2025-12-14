import 'package:flutter/material.dart';
import 'library/library_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final _pages = const [
  //   HomePage(),
   LibraryPage(), 
  //   ReviewPage(),
  //   CommunityPage(),
  //   ProfilePage(),
 ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Thư viện'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Ôn tập'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Cộng đồng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}
