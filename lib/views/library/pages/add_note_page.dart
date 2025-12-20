import 'package:flutter/material.dart';
import 'ocr_capture_page.dart';
import 'create_flashcard_page.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart';

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

  @override
  void dispose() {
    _contentController.dispose(); // Nhớ dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LibraryViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Huỷ",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Tạo Ghi chú Mới",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                viewModel.addNote(_content, _pageNumber);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã lưu ghi chú!')),
                );
              }
            },
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
      body: Column(
        children: [
          // Phần hiển thị sách đang chọn (Read-only)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[50],
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ghi chú cho:",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "Tâm lý học về tiền",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Vùng nhập liệu nội dung
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: "Nhập ghi chú của bạn...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                        errorStyle: TextStyle(color: Colors.redAccent),
                      ),
                      style: TextStyle(fontSize: 18),
                      maxLines: null, // Cho phép xuống dòng thoải mái
                      keyboardType: TextInputType.multiline,

                      validator: (value) => viewModel.validateContent(
                        value,
                        fieldName: "Ghi chú",
                      ),
                      onSaved: (value) => _content = value!.trim(),
                      onChanged: (value) => _content = value,
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
                        decoration: InputDecoration(
                          hintText: "Nhập số trang",
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.bookmarks_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        keyboardType: TextInputType.number,

                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          return viewModel.validatePageNumber(value);
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            _pageNumber = int.parse(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Toolbar các nút chức năng bên dưới
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // Nút OCR lớn màu xanh
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OcrCapturePage(),
                        ),
                      );
                      if (result != null && result is String) {
                        setState(() {
                          _contentController.text = result; // Điền vào ô nhập
                          _content = result; // Cập nhật biến
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Đã trích xuất văn bản!"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Chụp & trích xuất chữ (OCR)",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Các nút phụ
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.format_size,
                          size: 18,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          "Ý chính",
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateFlashcardPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.style,
                          size: 18,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          "Tạo Flashcard",
                          style: TextStyle(color: Colors.black87),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
