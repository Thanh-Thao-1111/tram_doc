import 'package:flutter/material.dart';
import 'widgets/library_book_item.dart';
import 'pages/book_detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dữ liệu giả lập 
  final List<_BookUi> dummyBooks = [
    _BookUi('Nhà Giả Kim', 'Paulo Coelho', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1483412266i/865.jpg'),
    _BookUi('Tâm lý học về tiền', 'Morgan Housel', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg'),
    _BookUi('Đắc Nhân Tâm', 'Dale Carnegie', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1442726934i/4865.jpg'),
    _BookUi('Cánh buồm đỏ thắm', 'Alexander Grin', 'https://cdn0.fahasa.com/media/catalog/product/c/a/canh-buom-do-tham_1_1.jpg'),
    _BookUi('Không gia đình', 'Hector Malot', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Sans_famille_1889.jpg/250px-Sans_famille_1889.jpg'),
    _BookUi('Harry Potter', 'J.K. Rowling', 'https://m.media-amazon.com/images/I/71Xq+KUVw0L._AC_UF1000,1000_QL80_.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thư viện',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, size: 28, color: Colors.grey), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50), size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4CAF50),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4CAF50),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: 'Muốn đọc'),
            Tab(text: 'Đang đọc'),
            Tab(text: 'Đã đọc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookGrid(dummyBooks),
          _buildBookGrid(dummyBooks.sublist(0, 3)),
          _buildBookGrid(dummyBooks.sublist(3, 6)),
        ],
      ),
    );
  }

  Widget _buildBookGrid(List<_BookUi> books) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final book = books[index];
          return LibraryBookItem(
            title: book.title,
            author: book.author,
            imageUrl: book.imageUrl,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookDetailPage()),
              );
            },
          );
        },
      ),
    );
  }
}

// Class nội bộ dùng tạm cho UI
class _BookUi {
  final String title;
  final String author;
  final String imageUrl;

  _BookUi(this.title, this.author, this.imageUrl);
}