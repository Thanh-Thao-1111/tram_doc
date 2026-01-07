import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../repositories/card_repository.dart'; // <--- Import Repository để lưu thẻ

class CreateFlashcardPage extends StatefulWidget {
  final BookModel? book; // <--- 1. Thêm biến book để nhận từ trang trước

  const CreateFlashcardPage({super.key, this.book}); // <--- 2. Thêm vào constructor

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Gọi Repository để xử lý lưu vào Firebase
  final _cardRepo = CardRepository(); 

  String _question = '';
  String _answer = '';
  bool _isSaving = false; // Biến để hiện vòng xoay khi đang lưu

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Lấy ID sách (Ưu tiên lấy từ tham số truyền vào, nếu null thì lấy từ ViewModel)
      final vmBook = context.read<LibraryViewModel>().currentBook;
      final targetBook = widget.book ?? vmBook;

      if (targetBook == null || targetBook.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi: Không xác định được sách để thêm thẻ!")),
        );
        return;
      }

      setState(() => _isSaving = true);

      try {
        // --- GỌI API LƯU THẺ VÀO FIREBASE ---
        await _cardRepo.addCard(
          question: _question,
          answer: _answer,
          bookId: targetBook.id!, // Truyền ID sách vào đây
        );

        if (!mounted) return;
        
        Navigator.pop(context); // Đóng trang
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đã tạo Flashcard thành công!"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ưu tiên hiển thị sách được truyền vào (widget.book), nếu không có thì lấy sách đang chọn (viewModel)
    final viewModel = context.watch<LibraryViewModel>();
    final displayBook = widget.book ?? viewModel.currentBook;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Tạo Flashcard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          _isSaving 
          ? const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
          : TextButton(
            onPressed: _submitForm,
            child: const Text(
              "Lưu",
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BANNER SÁCH ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.book, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tạo thẻ cho sách:",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayBook?.title ?? "Chưa chọn sách",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- INPUT MẶT TRƯỚC ---
              const Text("Mặt trước (Câu hỏi)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  minLines: 3,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Nhập câu hỏi...",
                    border: InputBorder.none,
                  ),
                  // Gọi validate từ ViewModel hoặc tự check
                  validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập mặt trước" : null,
                  onSaved: (value) => _question = value!.trim(),
                ),
              ),

              const SizedBox(height: 24),

              // --- INPUT MẶT SAU ---
              const Text("Mặt sau (Đáp án)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  minLines: 3,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Nhập câu trả lời...",
                    border: InputBorder.none,
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập mặt sau" : null,
                  onSaved: (value) => _answer = value!.trim(),
                ),
              ),

              const SizedBox(height: 40),

              // --- NÚT TẠO ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Tạo Flashcard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}