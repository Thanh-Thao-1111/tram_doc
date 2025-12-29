import 'package:flutter/material.dart';
import '../../../models/book_model.dart';
import '../../../repositories/book_repository.dart';
import '../../library/library_page.dart';
import '../../main_page.dart';

class AddBookPreviewPage extends StatefulWidget {
  final BookModel book;

  const AddBookPreviewPage({super.key, required this.book});

  @override
  State<AddBookPreviewPage> createState() => _AddBookPreviewPageState();
}

class _AddBookPreviewPageState extends State<AddBookPreviewPage> {
  final BookRepository _bookRepository = BookRepository();
  bool _isLoading = false;
  String? _loadingShelf;

  static const Color greenColor = Color(0xFF5CB85C);
  static const Color blueColor = Color(0xFF5BC0DE);
  static const Color purpleColor = Color(0xFF9B59B6);

  Future<void> _addBookWithStatus(ReadingStatus status, String shelfName) async {
    setState(() {
      _isLoading = true;
      _loadingShelf = shelfName;
    });

    try {
      // Check if book already exists
      if (widget.book.isbn != null) {
        final exists = await _bookRepository.bookExists(widget.book.isbn!);
        if (exists) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sách này đã có trong thư viện của bạn'),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            _isLoading = false;
            _loadingShelf = null;
          });
          return;
        }
      }

      final bookWithStatus = widget.book.copyWith(readingStatus: status);
      await _bookRepository.addBook(bookWithStatus);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm sách vào kệ "$shelfName"!'),
          backgroundColor: Colors.green,
        ),
      );

      // Get tab index based on reading status
      int tabIndex = 0;
      switch (status) {
        case ReadingStatus.wantToRead:
          tabIndex = 0;
          break;
        case ReadingStatus.reading:
          tabIndex = 1;
          break;
        case ReadingStatus.completed:
          tabIndex = 2;
          break;
      }

      // Navigate to LibraryPage with correct tab
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LibraryPage(initialTabIndex: tabIndex),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingShelf = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Xem Trước Sách',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book Cover
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.book.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.book.imageUrl,
                        width: 180,
                        height: 270,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              widget.book.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Author
            Text(
              widget.book.author,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Book Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.book.pageCount != null)
                  _buildInfoChip(Icons.menu_book, '${widget.book.pageCount} trang'),
                if (widget.book.publishedDate != null) ...[
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.calendar_today, widget.book.publishedDate!),
                ],
              ],
            ),

            if (widget.book.categories != null && widget.book.categories!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: widget.book.categories!.take(3).map((cat) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: const TextStyle(color: greenColor, fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ],

            // Description
            if (widget.book.description != null) ...[
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mô tả',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.book.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 32),

            // Section Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Thêm vào kệ sách',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3 Shelf Buttons
            _buildShelfButton(
              icon: Icons.bookmark_border,
              label: 'Muốn đọc',
              color: greenColor,
              status: ReadingStatus.wantToRead,
            ),

            const SizedBox(height: 12),

            _buildShelfButton(
              icon: Icons.menu_book,
              label: 'Đang đọc',
              color: greenColor,
              status: ReadingStatus.reading,
            ),

            const SizedBox(height: 12),

            _buildShelfButton(
              icon: Icons.check_circle_outline,
              label: 'Đã đọc',
              color: greenColor,
              status: ReadingStatus.completed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShelfButton({
    required IconData icon,
    required String label,
    required Color color,
    required ReadingStatus status,
  }) {
    final isLoadingThis = _loadingShelf == label;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : () => _addBookWithStatus(status, label),
        icon: isLoadingThis
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 180,
      height: 270,
      color: Colors.grey[200],
      child: const Icon(Icons.book, size: 64, color: Colors.grey),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
