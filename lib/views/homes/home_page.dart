import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tram_doc/core/assets/app_images.dart';

import '../books/add_book_page.dart';
import '../books/pages/add_bookshelf_page.dart';
import 'pages/notification_page.dart';

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
/// HOME SCREEN
/// =====================

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            _currentlyReading(),
            _reviewSection(),
            _circleUpdates(),
            _suggestedBooks(context),
          ],
        ),
      ),
    );
  }

  /// =====================
  /// WIDGETS
  /// =====================

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chào buổi sáng!',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: primaryAppColor),
            onPressed: () => _openAddBook(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: primaryAppColor),
            onPressed: () => _openNotifications(context),
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
            borderRadius: BorderRadius.circular(6),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8,
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Bắt đầu ngay'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(
              AppImages.review,
              width: 90,
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
                borderRadius: BorderRadius.circular(12),
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
                    onPressed: () => _openAddToShelf(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
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
