import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
// Import các file cần thiết
import '../../../viewmodels/library_viewmodel.dart';
import '../../../models/book_model.dart';
import '../widgets/note_item.dart';
import '../widgets/rating_star.dart';
import '../../books/pages/book_address_page.dart';
import 'add_note_page.dart';
import 'review_book_page.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    // 🔥 QUAN TRỌNG: Tự động tải dữ liệu khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final vm = context.read<LibraryViewModel>();
        vm.fetchNotes();
        vm.fetchReviews();
      }
    });
  }

  // --- HELPER METHODS ---
  IconData _getStatusIcon(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.wantToRead: return Icons.bookmark_border;
      case ReadingStatus.reading: return Icons.menu_book;
      case ReadingStatus.completed: return Icons.check_circle_outline;
    }
  }

  String _getStatusText(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.wantToRead: return 'Muốn đọc';
      case ReadingStatus.reading: return 'Đang đọc';
      case ReadingStatus.completed: return 'Đã đọc';
    }
  }

  // --- DIALOGS ---
  void _showUpdateProgressDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final viewModel = context.read<LibraryViewModel>();
    
    int current = viewModel.currentPage;
    int total = viewModel.totalPages;
    int newPage = current;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cập nhật tiến độ"),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: current.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Số trang đang đọc",
              border: OutlineInputBorder(),
              suffixText: "Trang",
            ),
            validator: (value) => viewModel.validatePageNumber(value, maxPage: total),
            onSaved: (value) => newPage = int.tryParse(value ?? '0') ?? 0,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                viewModel.updateReadingProgress(newPage);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã cập nhật tiến độ đọc!")));
              }
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final viewModel = context.read<LibraryViewModel>();
    final book = viewModel.currentBook;

    if (book == null || book.id == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa sách"),
        content: Text("Bạn có chắc muốn xóa '${book.title}' khỏi thư viện?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isDeleting = true);
              try {
                await viewModel.deleteBook(book.id!);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xóa sách khỏi thư viện!"), backgroundColor: Colors.green),
                );
                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
                );
                setState(() => _isDeleting = false);
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryViewModel>();
    final book = viewModel.currentBook;
    const Color primaryColor = Color(0xFF4CAF50);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
        body: const Center(child: Text("Không tìm thấy sách")),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Chi tiết Sách', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
             // Chỉ hiện nút xóa nếu sách đã có trong thư viện (có ID)
            if (book.id != null && !viewModel.isSearching)
              IconButton(
                icon: _isDeleting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.delete, color: Colors.red),
                onPressed: _isDeleting ? null : () => _showDeleteConfirmation(context),
              ),
          ],
        ),
        body: Column(
          children: [
            // --- HEADER SÁCH ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: book.imageUrl.isNotEmpty
                          ? Image.network(book.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]))
                          : Container(color: Colors.grey[200], child: const Icon(Icons.book, color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(book.author, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 12),
                        Row(children: [
                          Icon(_getStatusIcon(book.readingStatus), size: 16, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(_getStatusText(book.readingStatus), style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
                        ]),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => const BookLocationPage()));
                            setState(() {});
                          },
                          child: Row(children: [
                            const Icon(Icons.location_on, size: 16, color: primaryColor),
                            const SizedBox(width: 4),
                            Text(book.shelfLocation?.isNotEmpty == true ? book.shelfLocation! : 'Vị trí sách', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const TabBar(
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              tabs: [Tab(text: 'Muốn đọc'), Tab(text: 'Ghi chú'), Tab(text: 'Cộng đồng')],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildInfoTab(context, viewModel, primaryColor),
                  _buildNotesTab(context, viewModel),
                  _buildCommunityTab(context, viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: THÔNG TIN (ĐÃ FIX TRÙNG LẶP) ---
  Widget _buildInfoTab(BuildContext context, LibraryViewModel viewModel, Color primaryColor) {
    final book = viewModel.currentBook;
    int current = viewModel.currentPage;
    int total = viewModel.totalPages;
    double progress = (total == 0) ? 0 : (current / total);
    if (progress > 1) progress = 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mô tả sách
          if (book?.description != null) ...[
            Text(
              book!.description!,
              style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
              maxLines: 6, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
          ] else ...[
             const Text("Chưa có mô tả.", style: TextStyle(color: Colors.grey)),
             const SizedBox(height: 24),
          ],
          
          const Divider(),
          const SizedBox(height: 24),

          // Logic hiển thị nút bấm
          if (viewModel.isSearching) ...[
            // 1. Đang tìm kiếm -> Chỉ hiện nút Thêm
            Center(
              child: SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton.icon(
                  onPressed: viewModel.isLoading 
                    ? null 
                    : () async {
                        if (book != null) await viewModel.addToLibrary(book);
                        if (mounted) Navigator.pop(context);
                      },
                  icon: const Icon(Icons.bookmark_add, color: Colors.white),
                  label: const Text("Muốn đọc", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ),
          ] else ...[
            // Đã có trong tủ -> Hiện tiến độ (1 dòng duy nhất)
            // 2. Đã có trong tủ -> Hiện Tiến độ + Nút Cập nhật
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Đã đọc ${(progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                Text("$current / $total trang", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: primaryColor, minHeight: 10),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showUpdateProgressDialog(context),
                icon: const Icon(Icons.edit, color: Colors.green),
                label: const Text("Cập nhật tiến độ", style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8F5E9), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ]
        ],
      ),
    );
  }

  // --- TAB 2: GHI CHÚ ---
  Widget _buildNotesTab(BuildContext context, LibraryViewModel viewModel) {
    final notes = viewModel.notes; // Lấy danh sách thật
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNotePage())),
              icon: const Icon(Icons.edit_note),
              label: const Text("Viết ghi chú mới"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
            ),
          ),
        ),
        Expanded(
          child: notes.isEmpty 
          ? const Center(child: Text("Chưa có ghi chú nào.", style: TextStyle(color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteItem(
                  page: "Trang ${note.pageNumber}",
                  date: DateFormat('dd/MM/yyyy').format(note.date),
                  content: note.content,
                  onTap: () {},
                );
              },
            ),
        ),
      ],
    );
  }

  // --- TAB 3: CỘNG ĐỒNG (DÙNG DATA THẬT) ---
  Widget _buildCommunityTab(BuildContext context, LibraryViewModel viewModel) {
    final reviews = viewModel.reviews; // Lấy review thật
    double averageRating = 0;
    if (reviews.isNotEmpty) {
      final totalStars = reviews.fold(0, (sum, item) => sum + item.rating);
      averageRating = totalStars / reviews.length;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Text(averageRating == 0 ? "0.0" : averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RatingStar(rating: averageRating.round(), size: 20),
            const SizedBox(height: 4),
            Text("${reviews.length} đánh giá", style: const TextStyle(color: Colors.grey)),
          ]),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewBookPage())),
            icon: const Icon(Icons.rate_review, color: Color(0xFF4CAF50)),
            label: const Text("Viết đánh giá", style: TextStyle(color: Color(0xFF4CAF50))),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4CAF50)), padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
        const Divider(height: 32),
        if (reviews.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Chưa có đánh giá nào.", style: TextStyle(color: Colors.grey))))
        else
          ...reviews.map((review) => _buildReviewItem(
            review.userName, review.rating, review.comment, review.date
          )).toList(),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment, DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.black87)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(DateFormat('dd/MM/yyyy').format(date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]),
                const SizedBox(height: 2),
                RatingStar(rating: rating, size: 14),
                const SizedBox(height: 6),
                Text(comment, style: const TextStyle(color: Colors.black87, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}