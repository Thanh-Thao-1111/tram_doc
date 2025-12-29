import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/library_book_item.dart';
import 'pages/book_detail_page.dart';
import '../../viewmodels/library_viewmodel.dart';
import '../../models/book_model.dart';
import '../books/add_book_page.dart';

class LibraryPage extends StatefulWidget {
  final int initialTabIndex;
  
  const LibraryPage({super.key, this.initialTabIndex = 0});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, 
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    
    // Load books when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryViewModel>().loadBooks();
    });
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Thư viện',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, size: 28, color: Colors.grey), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50), size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBookPage()),
              );
            },
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
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(viewModel.errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.loadBooks(),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookGrid(
                      books.where((b) => b.readingStatus == ReadingStatus.wantToRead).toList(),
                      viewModel,
                    ),
                    _buildBookGrid(
                      books.where((b) => b.readingStatus == ReadingStatus.reading).toList(),
                      viewModel,
                    ),
                    _buildBookGrid(
                      books.where((b) => b.readingStatus == ReadingStatus.completed).toList(),
                      viewModel,
                    ),
                  ],
                ),
    );
  }

  Widget _buildBookGrid(List<BookModel> books, LibraryViewModel viewModel) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_books, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có sách nào',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddBookPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm sách'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadBooks(),
      child: Padding(
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
      ),
    );
  }
}
