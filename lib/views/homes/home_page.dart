import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/notification_page.dart';
import '../add_book_page.dart';

class UpdateItem {
  final String content;
  final String time;
  final String? bookImageUrl;

  UpdateItem(this.content, this.time, {this.bookImageUrl});
}

class RecommendationItem {
  final String title;
  final String author;
  final String imageUrl;

  RecommendationItem(this.title, this.author, this.imageUrl);
}

final List<String> placeholderBookCovers = [
  'https://upload.wikimedia.org/wikipedia/vi/9/9c/Nh%C3%A0_gi%E1%BA%A3_kim_%28s%C3%A1ch%29.jpg',
  'https://bizweb.dktcdn.net/100/418/570/products/1-0a8266fb-fa59-4322-82fc-3053ba5c25b4.jpg',
  'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
];

final List<UpdateItem> circleUpdates = [
  UpdateItem(
    'Ngọc Anh vừa đọc xong Đắc Nhân Tâm.',
    '2 giờ trước',
    bookImageUrl: 'https://via.placeholder.com/50x80',
  ),
];

final List<RecommendationItem> recommendations = [
  RecommendationItem(
    'Deep Work',
    'Cal Newport',
    'https://via.placeholder.com/80x120',
  ),
];

const Color primaryAppColor = Color(0xFF3BA66B);
const Color accentGreenColor = Color(0xFF5CB85C);
const Color lightGreyBackground = Color(0xFFF7F7F7);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _showNotification = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        onAddBook: _openAddBook,
        onShowNotification: _showNotifications,
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
      MaterialPageRoute(builder: (_) => const AddBookPage()),
    );
  }

  void _showNotifications() {
    setState(() => _showNotification = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showNotification
          ? InlineNotificationPage(
              onClose: () => setState(() => _showNotification = false),
            )
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
            _recommendations(),
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
  const Color accentGreenColor = Color(0xFF4CAF50); // Màu xanh lá cây cho nút
  const Color descriptionBlueColor = Color(0xFF336699); // Màu xanh dương nhạt cho mô tả
  const Color imageBackgroundColor = Color(0xFFC8E6C9); // Màu nền xanh nhạt cho hình minh họa (giả định)

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 0), // Điều chỉnh padding
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền trắng (thay vì lightGreyBackground)
        borderRadius: BorderRadius.circular(8),
        // Thêm shadow nhẹ nếu cần để nổi bật
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần văn bản và nút bấm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  'Ôn tập hôm nay',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800, // Thường là ExtraBold/Black để trông đậm hơn
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Mô tả
                Text(
                  'Bạn có 12 ghi chú cần ôn lại.', // Sửa văn bản và dấu chấm
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: descriptionBlueColor, // Màu xanh dương nhạt
                  ),
                ),
                const SizedBox(height: 16), // Khoảng cách lớn hơn giữa mô tả và nút
                // Nút bấm
                ElevatedButton.icon( // Dùng ElevatedButton.icon để dễ dàng thêm mũi tên
                  onPressed: () {},
                  icon: const Text(
                    'Bắt đầu ngay', // Văn bản đúng
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  label: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentGreenColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Bo góc lớn hơn
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          
          // Phần hình ảnh minh họa
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 90, // Kích thước hình ảnh cố định
              height: 100,
              // Đây là nơi bạn sẽ đặt hình ảnh thực tế. Vì bạn không cung cấp hình ảnh, 
              // tôi sẽ đặt một widget giữ chỗ (placeholder) có màu nền tương tự.
              decoration: BoxDecoration(
                color: imageBackgroundColor, // Màu nền xanh xám/xanh lá nhạt của hình minh họa
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                // Thay thế bằng Image.asset('path/to/illustration.png') 
                // hoặc Image.network('url_to_illustration.png')
                // Hiện tại dùng Sizedbox để giữ chỗ cho hình ảnh
                child: SizedBox.shrink(), 
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
          Text('Tin mới',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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

  Widget _recommendations() {
  final List<Map<String, dynamic>> recommendationsData = [
    {
      'title': 'The Power of Habit',
      'author': 'Charles Duhigg',
      'imageUrl': 'https://example.com/power_of_habit.png', // Thay thế bằng URL ảnh bìa thực tế
    },
    {
      'title': 'Deep Work',
      'author': 'Cal Newport',
      'authorColor': const Color(0xFF336699), // Thêm màu đặc trưng cho tác giả Deep Work
      'imageUrl': 'https://example.com/deep_work.png', // Thay thế bằng URL ảnh bìa thực tế
    },
  ];

  // Màu sắc
  const Color buttonGreen = Color(0xFF4CAF50); // Màu xanh lá cây cho nút
  const Color defaultAuthorColor = Color(0xFF607D8B); // Màu xanh xám mặc định cho tác giả

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Không có tiêu đề 'Gợi ý cho bạn' trong ảnh
        
        // Dùng Column để hiển thị danh sách các mục
        ...recommendationsData.map(
          (r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Khoảng cách giữa các mục
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
              children: [
                // 1. Ảnh bìa sách
                ClipRRect(
                  borderRadius: BorderRadius.circular(4), 
                  child: Image.network(
                    r['imageUrl']!,
                    width: 50,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                
                // 2. Tiêu đề và Tác giả
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        r['title']!,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, 
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r['author']!,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          // Lấy màu từ dữ liệu nếu có, nếu không dùng màu mặc định
                          color: r.containsKey('authorColor') 
                              ? r['authorColor'] as Color 
                              : defaultAuthorColor, 
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 3. Nút bấm
                SizedBox(
                  height: 40, 
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý sự kiện khi bấm nút
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), 
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    child: Text(
                      'Thêm vào kệ', 
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).toList(), // Phải thêm .toList() khi trải dài (spread) Map
      ],
    ),
  );
}
}
