import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/library_book_item.dart';
import 'pages/book_detail_page.dart';
import '../../../viewmodels/library_viewmodel.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;


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
    final viewModel = context.watch<LibraryViewModel>();
    final books = viewModel.libraryBooks;

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
          _buildBookGrid(books, viewModel),
          _buildBookGrid(books.take(2).toList(), viewModel), 
          _buildBookGrid(books.skip(2).toList(), viewModel),
        ],
      ),
    );
  }

  Widget _buildBookGrid(List<Book> books, LibraryViewModel viewModel) {
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
              viewModel.setCurrentBook(book);
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

