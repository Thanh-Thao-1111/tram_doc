import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tram_doc/core/assets/app_images.dart';

import '../../models/book_model.dart';
import '../../viewmodels/home_viewmodel.dart';

import '../books/add_book_page.dart';
import '../books/pages/add_bookshelf_page.dart';
import 'pages/notification_page.dart';
import '../review/pages/flashcard_player_page.dart';

const Color primaryAppColor = Color(0xFF3BA66B);
const Color accentGreenColor = Color(0xFF5CB85C);
const Color descriptionBlueColor = Color(0xFF336699);

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeViewModel vm = HomeViewModel();

  void _openAddBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddBookPage()),
    );
  }

  void _openAddToShelf(BuildContext context, BookModel book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddBookPreviewPage(book: book)),
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
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              _sectionTitle('Đang đọc'),
              _currentlyReading(),
              _reviewSection(context),
              _circleUpdates(),
              _suggestedBooks(context),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            child: Icon(Icons.person, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chào buổi sáng, Nam!',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: primaryAppColor),
            onPressed: () => _openAddBook(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: primaryAppColor),
            onPressed: () => _openNotifications(context),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  // ================= CURRENTLY READING =================
  Widget _currentlyReading() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: vm.currentlyReadingCovers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            vm.currentlyReadingCovers[index],
            width: 130,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // ================= REVIEW =================
  Widget _reviewSection(BuildContext context) {
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
                      color: Colors.black,
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
                    onPressed: () {
                      // Chuyển sang trang ôn tập ngẫu nhiên
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FlashcardPlayerPage(mode: "Ngẫu nhiên"),
                        ),
                      );
                    },
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

  // ================= CIRCLE UPDATES =================
  Widget _circleUpdates() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề
        Text(
          'Tin mới từ vòng tròn',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        // Danh sách tin
        ...vm.circleUpdates.map((u) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 AVATAR (BÊN TRÁI)
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(u.avatarUrl),
              ),

              const SizedBox(width: 12),

              // 📝 TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: u.user,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' ${u.action} '),
                          TextSpan(
                            text: u.bookName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      u.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // 📕 ẢNH SÁCH (BÊN PHẢI)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  u.bookCoverUrl,
                  width: 40,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      }),
      ],
    ),
  );
}



  // ================= SUGGESTED BOOKS =================
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
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...vm.suggestedBooks.map<Widget>((BookModel b) {
            return Container(
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
                            color: Colors.black,
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
                    onPressed: () => _openAddToShelf(context, b),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGreenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Thêm'),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
