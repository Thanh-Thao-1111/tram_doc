import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tram_doc/core/assets/app_images.dart';

import '../../models/book_model.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/library_viewmodel.dart';
import '../../viewmodels/community_viewmodel.dart';
import '../../viewmodels/review_viewmodel.dart';

import '../books/add_book_page.dart';
import '../books/pages/add_bookshelf_page.dart';
import '../library/pages/book_detail_page.dart';
import 'pages/notification_page.dart';
import '../review/pages/flashcard_player_page.dart';

const Color primaryAppColor = Color(0xFF3BA66B);
const Color accentGreenColor = Color(0xFF5CB85C);
const Color descriptionBlueColor = Color(0xFF336699);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel vm = HomeViewModel();
  String _username = '';
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _listenToUserChanges();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Chào buổi sáng';
    } else if (hour < 18) {
      _greeting = 'Chào buổi chiều';
    } else {
      _greeting = 'Chào buổi tối';
    }
  }

  void _listenToUserChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Listen to real-time changes from Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (mounted && doc.exists) {
          final data = doc.data();
          setState(() {
            // Priority: nếu có displayName (tên đã thay đổi) thì hiện displayName
            // Nếu không thì hiện username
            final displayName = data?['displayName'];
            final username = data?['username'];
            
            if (displayName != null && displayName.toString().trim().isNotEmpty) {
              _username = displayName;
            } else if (username != null && username.toString().trim().isNotEmpty) {
              _username = username;
            } else {
              _username = user.displayName ?? 
                          user.email?.split('@').first ?? 
                          'Bạn';
            }
          });
        }
      }, onError: (e) {
        // Fallback to Firebase Auth displayName or email
        if (mounted) {
          setState(() {
            _username = user.displayName ?? user.email?.split('@').first ?? 'Bạn';
          });
        }
      });
    }
  }

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
    final libraryVm = context.watch<LibraryViewModel>();
    final communityVm = context.watch<CommunityViewModel>();
    final reviewVm = context.watch<ReviewDashboardViewModel>();
    
    final hasReadingBooks = libraryVm.readingBooks.isNotEmpty;
    final hasNotes = reviewVm.cardsToReview > 0; // Có ghi chú cần ôn tập
    final hasFriends = communityVm.friends.isNotEmpty; // Có bạn bè
    
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header cố định không scroll
            _header(context),
            // Phần nội dung có thể scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nếu chưa có sách đang đọc → hiện banner "Bắt đầu ngay" và "Sách phổ biến"
                    if (!hasReadingBooks) ...[
                      _welcomeBanner(context),
                      _sectionTitle('Sách phổ biến'),
                      _popularBooks(context),
                    ],
                    // Nếu có sách đang đọc → hiện section "Đang đọc"
                    if (hasReadingBooks) ...[
                      _sectionTitle('Đang đọc'),
                      _currentlyReading(),
                    ],
                    // Chỉ hiện "Ôn tập hôm nay" khi có ghi chú
                    if (hasNotes) _reviewSection(context),
                    // Chỉ hiện "Tin mới từ vòng tròn" khi có bạn bè
                    if (hasFriends) _circleUpdates(),
                    // Luôn hiện "Gợi ý cho bạn"
                    _suggestedBooks(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              _username.isNotEmpty 
                  ? '$_greeting, $_username!' 
                  : '$_greeting!',
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

  // ================= WELCOME BANNER (cho người dùng mới) =================
  Widget _welcomeBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3BA66B), Color(0xFF5CB85C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryAppColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bắt đầu hành trình đọc sách của bạn!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Khám phá hàng nghìn đầu sách, tạo ghi chú thông minh và kết nối với cộng đồng yêu sách.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openAddBook(context),
              icon: const Icon(Icons.menu_book, size: 20),
              label: const Text('Thêm sách ngay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryAppColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= POPULAR BOOKS (cho người dùng mới) =================
  Widget _popularBooks(BuildContext context) {
    final popularBooks = vm.popularBooks;
    
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: popularBooks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final book = popularBooks[index];
          return GestureDetector(
            onTap: () => _openAddToShelf(context, book),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  book.imageUrl,
                  width: 150,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 150,
                    height: 220,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.book, size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
    final libraryVm = context.watch<LibraryViewModel>();
    final readingBooks = libraryVm.readingBooks;
    
    // Section này chỉ hiện khi có sách thật (đã check ở build method)
    return SizedBox(
      height: 190,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: readingBooks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final book = readingBooks[index];
          return GestureDetector(
            onTap: () {
              libraryVm.setCurrentBook(book);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookDetailPage()),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.imageUrl,
                width: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 130,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 40),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= REVIEW =================
  Widget _reviewSection(BuildContext context) {
    final reviewVm = context.watch<ReviewDashboardViewModel>();
    final noteCount = reviewVm.cardsToReview;
    
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
                    'Bạn có $noteCount ghi chú cần ôn lại.',
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
    final communityVm = context.watch<CommunityViewModel>();
    final posts = communityVm.posts.take(3).toList(); // Chỉ lấy 3 bài viết gần nhất
    
    if (posts.isEmpty) {
      return const SizedBox.shrink();
    }
    
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
          // Danh sách tin từ bạn bè
          ...posts.map((post) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 AVATAR (BÊN TRÁI)
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: post.userAvatar != null 
                        ? NetworkImage(post.userAvatar!)
                        : null,
                    child: post.userAvatar == null 
                        ? const Icon(Icons.person, size: 20)
                        : null,
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
                                text: post.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: ' ${post.actionText} '),
                              if (post.bookTitle != null)
                                TextSpan(
                                  text: post.bookTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.timeAgo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 📕 ẢNH SÁCH (BÊN PHẢI)
                  if (post.bookCoverUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        post.bookCoverUrl!,
                        width: 40,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 40,
                          height: 56,
                          color: Colors.grey[300],
                          child: const Icon(Icons.book, size: 20),
                        ),
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
