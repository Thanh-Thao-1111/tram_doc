import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/library_book_item.dart';
import 'pages/book_detail_page.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../models/book_model.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  // Biến trạng thái: true = đang mở ô tìm kiếm
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryViewModel>().fetchBooks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Hàm xử lý tắt tìm kiếm
  void _closeSearch(LibraryViewModel viewModel) {
    setState(() {
      _showSearchBar = false;       // 1. Ẩn ô input
      _searchController.clear();    // 2. Xóa chữ
      
      // 🔥 THAY ĐỔI: Reset bộ lọc nội bộ về rỗng (hiện tất cả sách)
      viewModel.setLocalSearchQuery(""); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryViewModel>();

    // 1. Chặn nút Back vật lý
    return PopScope(
      canPop: !_showSearchBar, 
      onPopInvoked: (didPop) {
        if (didPop) return;
        _closeSearch(viewModel);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          
          // Tắt nút Back tự động
          automaticallyImplyLeading: false, 

          // Tự vẽ nút Back thủ công
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (_showSearchBar) {
                _closeSearch(viewModel); // Tắt tìm kiếm
              } else {
                Navigator.pop(context); // Thoát trang
              }
            },
          ),

          // --- Phần Tiêu đề ---
          title: _showSearchBar
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Lọc tìm sách trong tủ...', // Sửa text cho hợp lý
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(color: Colors.black),
                  // 🔥 QUAN TRỌNG: Dùng onChanged để lọc ngay khi gõ
                  onChanged: (value) {
                    viewModel.setLocalSearchQuery(value);
                  },
                )
              : const Text(
                  'Thư viện',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                ),
          
          // --- Phần Nút bên phải ---
          actions: [
            IconButton(
              icon: Icon(_showSearchBar ? Icons.close : Icons.search, size: 28, color: Colors.grey),
              onPressed: () {
                if (_showSearchBar) {
                  _closeSearch(viewModel);
                } else {
                  setState(() {
                    _showSearchBar = true;
                  });
                }
              },
            ),
            if (!_showSearchBar)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50), size: 28),
                onPressed: () {
                   // Logic thêm sách (nếu có)
                },
              ),
            const SizedBox(width: 8),
          ],

          // 🔥 SỬA: Luôn hiện TabBar để lọc theo từng trạng thái
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

        // 🔥 SỬA: Luôn hiện TabBarView chứa danh sách sách (ViewModel tự lọc)
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildBookGrid(viewModel.libraryBooks, viewModel),
                  _buildBookGrid(viewModel.readingBooks, viewModel),
                  _buildBookGrid(viewModel.finishedBooks, viewModel),
                ],
              ),
      ),
    );
  }

  Widget _buildBookGrid(List<BookModel> books, LibraryViewModel viewModel) {
    if (books.isEmpty) {
      return const Center(
        child: Text(
          "Không tìm thấy sách nào",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
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