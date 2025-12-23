import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tram_doc/core/assets/app_images.dart';

import '../books/add_book_page.dart';
import '../books/pages/add_bookshelf_page.dart';
import 'pages/notification_page.dart';

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

const Color primaryAppColor = Color(0xFF3BA66B);
const Color accentGreenColor = Color(0xFF5CB85C);
const Color descriptionBlueColor = Color(0xFF336699);

final List<String> placeholderBookCovers = [
  'https://upload.wikimedia.org/wikipedia/vi/9/9c/Nh%C3%A0_gi%E1%BA%A3_kim_%28s%C3%A1ch%29.jpg',
  'https://bizweb.dktcdn.net/100/418/570/products/1-0a8266fb-fa59-4322-82fc-3053ba5c25b4.jpg',
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddBookPage()),
    );
  }

  void _openAddToShelf(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddBookPreviewPage()),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              _sectionTitle('Đang đọc'),
              _currentlyReading(),
              _reviewSection(),
              _circleUpdates(),
              _suggestedBooks(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chào buổi sáng, Nam!',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: primaryAppColor),
            onPressed: () => _openAddBook(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: primaryAppColor),
            onPressed: () => _openNotifications(context),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// ================= CURRENTLY READING =================
  Widget _currentlyReading() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: placeholderBookCovers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            placeholderBookCovers[index],
            width: 130,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// ================= REVIEW =================
  Widget _reviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bạn có 12 ghi chú cần ôn lại.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: descriptionBlueColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Bắt đầu ngay'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(AppImages.review, width: 80),
          ],
        ),
      ),
    );
  }

  /// ================= CIRCLE UPDATES =================
  Widget _circleUpdates() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
              leading: const CircleAvatar(radius: 16),
              title: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 13),
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
              subtitle: Text(u.time, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SUGGESTED BOOKS =================
  Widget _suggestedBooks(BuildContext context) {
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _openAddToShelf(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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
