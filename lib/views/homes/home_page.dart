import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tram_doc/core/assets/app_images.dart';

import 'pages/notification_page.dart';
import '../books/add_book_page.dart';
import '../books/pages/add_bookshelf_page.dart';

/// =====================
/// MODELS
/// =====================

class UpdateItem {
  final String user;
  final String action;
  final String bookName;
  final String time;

  UpdateItem({
    required this.user,
    required this.action,
    required this.bookName,
    required this.time,
  });
}

class SuggestedBook {
  final String title;
  final String author;
  final String imageUrl;

  SuggestedBook(this.title, this.author, this.imageUrl);
}

/// =====================
/// CONSTANTS & DATA
/// =====================

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
    user: 'Ngọc Anh',
    action: 'vừa đọc xong',
    bookName: 'Đắc Nhân Tâm',
    time: '2 giờ trước',
  ),
  UpdateItem(
    user: 'Minh Tuấn',
    action: 'đã thêm',
    bookName: 'Muôn Kiếp Nhân Sinh',
    time: 'Muốn đọc',
  ),
];

final List<SuggestedBook> suggestedBooks = [
  SuggestedBook(
    'The Power of Habit',
    'Charles Duhigg',
    'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
  ),
  SuggestedBook(
    'Deep Work',
    'Cal Newport',
    'https://images-na.ssl-images-amazon.com/images/I/71sBtM3Yi5L.jpg',
  ),
];

/// =====================
/// MAIN SCREEN
/// =====================

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
        onAddToShelf: _openAddBookShelf,
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
      MaterialPageRoute(builder: (_) =>  AddBookPage()),
    );
  }

  void _openAddBookShelf() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddBookPreviewPage()),
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

/// =====================
/// HOME SCREEN
/// =====================

class HomeScreen extends StatelessWidget {
  final VoidCallback onAddBook;
  final VoidCallback onShowNotification;
  final VoidCallback onAddToShelf;

  const HomeScreen({
    super.key,
    required this.onAddBook,
    required this.onShowNotification,
    required this.onAddToShelf,
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
            _suggestedBooks(),
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
            icon: const Icon(Icons.notifications_outlined, color: primaryAppColor),
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
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Bắt đầu ngay'),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
                width: 90,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    AppImages.review,
                    fit: BoxFit.contain,
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
            'Tin mới từ vòng tròn',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...circleUpdates.map(
            (u) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(color: Colors.black),
                  children: [
                    TextSpan(
                      text: u.user,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: ' ${u.action} '),
                    TextSpan(
                      text: u.bookName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              subtitle: Text(u.time),
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestedBooks() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gợi ý cho bạn',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...suggestedBooks.map(
            (b) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      b.imageUrl,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          b.author,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onAddToShelf,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Thêm vào kệ'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
