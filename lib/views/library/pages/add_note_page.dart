import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../viewmodels/community_viewmodel.dart';
import 'ocr_capture_page.dart'; 
import 'create_flashcard_page.dart'; 

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  String _content = '';
  int? _pageNumber;
  bool _publishToCommunity = false; // NEW: Option để đăng lên community
  bool _isSaving = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    final libraryViewModel = context.read<LibraryViewModel>();
    final book = libraryViewModel.currentBook;

    // Save note locally
    libraryViewModel.addUserNote(_content, _pageNumber ?? 0);

    // Publish to community if checked
    if (_publishToCommunity && book != null) {
      final communityViewModel = context.read<CommunityViewModel>();
      final success = await communityViewModel.createPost(
        actionText: 'đã ghi chú về ${book.title}',
        bookTitle: book.title,
        bookAuthor: book.author,
        bookCoverUrl: book.imageUrl,
        noteContent: _content,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã lưu ghi chú và đăng lên cộng đồng!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(communityViewModel.errorMessage ?? 'Không thể đăng lên cộng đồng'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu ghi chú!')),
      );
    }

    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Lấy dữ liệu sách đang chọn từ ViewModel
    final viewModel = context.watch<LibraryViewModel>();
    final book = viewModel.currentBook;

    // Check an toàn
    if (book == null) return const Scaffold(body: Center(child: Text("Lỗi: Không tìm thấy sách")));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Huỷ", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
        centerTitle: true,
        title: const Text(
          "Tạo Ghi chú Mới",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _saveNote,
                  child: const Text("Lưu", style: TextStyle(color: Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
        ],
      ),
      body: Column(
        children: [
          // --- PHẦN HIỂN THỊ THÔNG TIN SÁCH ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[50],
            child: Row(
              children: [
                Container(
                  width: 30, height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(book.imageUrl.isNotEmpty ? book.imageUrl : 'https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ghi chú cho:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- FORM NHẬP LIỆU ---
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: "Nhập ghi chú của bạn...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 18),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (value) => value!.isEmpty ? "Nội dung không được trống" : null,
                      onSaved: (value) => _content = value!.trim(),
                    ),
                    const Spacer(),
                    
                    // Input số trang
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Nhập số trang",
                          border: InputBorder.none,
                          icon: Icon(Icons.bookmarks_outlined, color: Colors.grey, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            _pageNumber = int.parse(value);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // NEW: Option đăng lên cộng đồng
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _publishToCommunity ? const Color(0xFFE8F5E9) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: _publishToCommunity 
                            ? Border.all(color: const Color(0xFF4CAF50), width: 1.5)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _publishToCommunity ? Icons.public : Icons.public_off,
                            color: _publishToCommunity ? const Color(0xFF4CAF50) : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Đăng lên cộng đồng",
                              style: TextStyle(
                                color: _publishToCommunity ? const Color(0xFF4CAF50) : Colors.grey[700],
                                fontWeight: _publishToCommunity ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          Switch(
                            value: _publishToCommunity,
                            onChanged: (value) => setState(() => _publishToCommunity = value),
                            activeColor: const Color(0xFF4CAF50),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- TOOLBAR CHỨC NĂNG (OCR, FLASHCARD) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -2), blurRadius: 10)],
            ),
            child: Column(
              children: [
                // NÚT OCR
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Chuyển sang trang chụp ảnh OCR
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OcrCapturePage()),
                      );
                      if (result != null && result is String) {
                        setState(() {
                          _contentController.text = result;
                          _content = result;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                    label: const Text("Chụp & trích xuất chữ (OCR)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                
                // CÁC NÚT PHỤ
                Row(
                  children: [
                    Expanded(child: _buildOutlineButton(Icons.format_size, "Ý chính", () {})),
                    const SizedBox(width: 12),
                    Expanded(child: _buildOutlineButton(Icons.style, "Tạo Flashcard", () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateFlashcardPage()));
                    })),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.black87),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}