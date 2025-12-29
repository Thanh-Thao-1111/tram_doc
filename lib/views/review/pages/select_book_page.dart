// lib/views/review/pages/select_book_page.dart
import 'package:flutter/material.dart';
import 'flashcard_player_page.dart'; 
import '../../../viewmodels/review_viewmodel.dart';
import '../../../models/book_model.dart';

class SelectBookPage extends StatefulWidget {
  const SelectBookPage({super.key});

  @override
  State<SelectBookPage> createState() => _SelectBookPageState();
}

class _SelectBookPageState extends State<SelectBookPage> {
  final SelectBookViewModel _viewModel = SelectBookViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Chọn sách ôn tập", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) => _viewModel.searchBook(value),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Tìm tên sách hoặc tác giả...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Danh sách sách từ Firebase
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                if (_viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final books = _viewModel.books;

                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text("Chưa có sách nào trong thư viện", 
                          style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return _buildBookListItem(context, book);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookListItem(BuildContext context, BookModel book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardPlayerPage(mode: "Ôn: ${book.title}"),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Ảnh bìa sách từ URL Firebase/Google Books
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.imageUrl,
                width: 60,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60, height: 90, color: Colors.grey[200],
                  child: const Icon(Icons.book, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(book.author,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 12),
                  // Trạng thái đọc
                  Text(
                    book.readingStatus == ReadingStatus.completed ? "Đã hoàn thành" : "Đang đọc",
                    style: TextStyle(
                      color: book.readingStatus == ReadingStatus.completed ? Colors.green : Colors.blue,
                      fontSize: 12, fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}