import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart'; // Import file gốc ở đây

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({super.key});

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  // 1. Khởi tạo Key quản lý Form
  final _formKey = GlobalKey<FormState>();

  // Biến lưu dữ liệu
  String _question = '';
  String _answer = '';

  // Hàm xử lý Lưu
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gọi hàm từ ViewModel gốc
      context.read<LibraryViewModel>().createFlashcard(_question, _answer);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã tạo thẻ mới thành công!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryViewModel>();
    final book = viewModel.currentBook;

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
          TextButton(
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
                            book?.title ?? "Chưa chọn sách",
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
              const Text("Mặt trước", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  // Gọi validate từ ViewModel
                  validator: (value) => viewModel.validateFlashcardSide(value, "mặt trước"),
                  onSaved: (value) => _question = value!.trim(),
                ),
              ),

              const SizedBox(height: 24),

              // --- INPUT MẶT SAU ---
              const Text("Mặt sau", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  // Gọi validate từ ViewModel
                  validator: (value) => viewModel.validateFlashcardSide(value, "mặt sau"),
                  onSaved: (value) => _answer = value!.trim(),
                ),
              ),

              const SizedBox(height: 40),

              // --- NÚT TẠO ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
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