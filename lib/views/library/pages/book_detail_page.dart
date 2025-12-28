import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import '../../../viewmodels/library_viewmodel.dart';
import '../widgets/note_item.dart';
import '../widgets/rating_star.dart';
import 'add_note_page.dart';
import 'review_book_page.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<LibraryViewModel>();
      vm.fetchNotes();
      vm.fetchReviews();
    });
  }

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
            decoration: const InputDecoration(labelText: "Số trang đang đọc", border: OutlineInputBorder(), suffixText: "trang"),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryViewModel>();
    final book = viewModel.currentBook;
    const Color primaryColor = Color(0xFF4CAF50);

    if (book == null) return const Scaffold(body: Center(child: Text("Lỗi: Không tìm thấy sách")));

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
        ),
        body: Column(
          children: [
            // HEADER SÁCH
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80, height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(book.imageUrl.isNotEmpty ? book.imageUrl : 'https://via.placeholder.com/150'),
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(book.author, style: const TextStyle(color: Colors.grey)),
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
              tabs: [
                // 🔥 SỬA: Đổi tên Tab 1 thành "Muốn đọc" theo yêu cầu
                Tab(text: 'Muốn đọc'), 
                Tab(text: 'Ghi chú'),
                Tab(text: 'Cộng đồng')
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildWantToReadTab(context, viewModel, primaryColor), // Tab 1
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

  // 🔥 TAB 1: MUỐN ĐỌC (Tên cũ là _buildInfoTab)
  Widget _buildWantToReadTab(BuildContext context, LibraryViewModel viewModel, Color primaryColor) {
    final book = viewModel.currentBook!;
    int current = viewModel.currentPage;
    int total = viewModel.totalPages;
    double progress = (total == 0) ? 0 : (current / total);
    if (progress > 1) progress = 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Giới thiệu
          const Text("Giới thiệu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "Cuốn sách '${book.title}' của ${book.author}. $total trang. Hãy thêm vào danh sách 'Muốn đọc' để bắt đầu nhé!",
            style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // 2. Nút Bấm
          if (viewModel.isSearching) ...[
            // Đang tìm kiếm -> Nút "Muốn đọc" (để thêm vào tủ)
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: viewModel.isLoading 
                    ? null 
                    : () async {
                        await viewModel.addToLibrary(book);
                        if (mounted) Navigator.pop(context);
                      },
                  icon: const Icon(Icons.bookmark_add, color: Colors.white),
                  // 🔥 SỬA: Tên nút thành "Muốn đọc"
                  label: const Text("Muốn đọc", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ),
          ] else ...[
            // Đã có trong tủ -> Hiện tiến độ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Đã đọc ${(progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                Text("$current / $total trang", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: primaryColor, minHeight: 10),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
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

  // Tab 2 & 3 giữ nguyên
  Widget _buildNotesTab(BuildContext context, LibraryViewModel viewModel) {
    final notes = viewModel.notes;
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
        Expanded(child: notes.isEmpty ? const Center(child: Text("Chưa có ghi chú", style: TextStyle(color: Colors.grey))) : ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: notes.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (context, index) { final note = notes[index]; return NoteItem(page: "Trang ${note.pageNumber}", date: DateFormat('dd/MM/yyyy').format(note.date), content: note.content, onTap: () {}); })),
      ],
    );
  }

  Widget _buildCommunityTab(BuildContext context, LibraryViewModel viewModel) {
    final reviews = viewModel.reviews;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewBookPage())), icon: const Icon(Icons.rate_review, color: Color(0xFF4CAF50)), label: const Text("Viết đánh giá", style: TextStyle(color: Color(0xFF4CAF50))))),
        ),
        Expanded(child: reviews.isEmpty ? const Center(child: Text("Chưa có đánh giá", style: TextStyle(color: Colors.grey))) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: reviews.length, itemBuilder: (context, index) { final review = reviews[index]; return _buildReviewItem(review.userName, review.rating, review.comment); })),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(backgroundColor: Colors.grey[200], child: Text(name[0])), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), RatingStar(rating: rating, size: 14), Text(comment)]))]));
  }
}