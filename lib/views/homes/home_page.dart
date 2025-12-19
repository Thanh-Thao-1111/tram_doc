import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/notification_page.dart';
import '../books/add_book_page.dart';

class UpdateItem {
  final String content;
  final String time;
  final String? bookImageUrl;

  UpdateItem(this.content, this.time, {this.bookImageUrl});
}

const Color primaryAppColor = Color(0xFF3BA66B);
const Color accentGreenColor = Color(0xFF5CB85C);
const Color descriptionBlueColor = Color(0xFF336699);
const Color imageBackgroundColor = Color(0xFFC8E6C9);

final List<String> placeholderBookCovers = [
  'https://upload.wikimedia.org/wikipedia/vi/9/9c/Nh%C3%A0_gi%E1%BA%A3_kim_%28s%C3%A1ch%29.jpg',
  'https://bizweb.dktcdn.net/100/418/570/products/1-0a8266fb-fa59-4322-82fc-3053ba5c25b4.jpg',
  'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
];

final List<UpdateItem> circleUpdates = [
  UpdateItem(
    'Ngọc Anh vừa đọc xong Đắc Nhân Tâm.',
    '2 giờ trước',
  ),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        onAddBook: _openAddBook,
        onShowNotification: _openNotifications,
      ),
      const Center(child: Text('Thư viện')),
      const Center(child: Text('Ôn tập')),
      const Center(child: Text('Cộng đồng')),
      const Center(child: Text('Hồ sơ')),
    ];
  }

  void _openAddBook() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddBookPage()),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: primaryAppColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Thư viện'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Ôn tập'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Cộng đồng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onAddBook;
  final VoidCallback onShowNotification;

  const HomeScreen({
    super.key,
    required this.onAddBook,
    required this.onShowNotification,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            _currentlyReading(),
            _reviewSection(),
            _circleUpdates(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chào buổi sáng, Nam!',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: primaryAppColor),
            onPressed: onAddBook,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: onShowNotification,
          ),
        ],
      ),
    );
  }

  Widget _currentlyReading() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: placeholderBookCovers.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              placeholderBookCovers[index],
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ôn tập hôm nay',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bạn có 12 ghi chú cần ôn lại.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: descriptionBlueColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Text(
                      'Bắt đầu ngay',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    label: const Icon(Icons.arrow_forward, size: 20),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 90,
                height: 100,
                decoration: BoxDecoration(
                  color: imageBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleUpdates() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tin mới',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...circleUpdates.map(
            (u) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(u.content),
              subtitle: Text(u.time),
            ),
          ),
        ],
      ),
    );
  }
}
