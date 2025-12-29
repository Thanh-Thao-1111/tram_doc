import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/library_viewmodel.dart';
import '../../../models/book_model.dart';

class BookLocationPage extends StatefulWidget {
  const BookLocationPage({super.key});

  @override
  State<BookLocationPage> createState() => _BookLocationPageState();
}

class _BookLocationPageState extends State<BookLocationPage> {
  static const Color primaryGreen = Color(0xFF2ECC71);

  late TextEditingController _locationController;
  late TextEditingController _shelfTypeController;
  late TextEditingController _shelfNumberController;

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final book = context.read<LibraryViewModel>().currentBook;
    _locationController = TextEditingController(text: book?.shelfLocation ?? '');
    _shelfTypeController = TextEditingController(text: book?.shelfType ?? '');
    _shelfNumberController = TextEditingController(text: book?.shelfNumber ?? '');

    _locationController.addListener(_onChanged);
    _shelfTypeController.addListener(_onChanged);
    _shelfNumberController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _shelfTypeController.dispose();
    _shelfNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveLocation() async {
    if (!_hasChanges) return;

    setState(() => _isLoading = true);

    try {
      final viewModel = context.read<LibraryViewModel>();
      final book = viewModel.currentBook;

      if (book == null || book.id == null) {
        throw Exception('Không tìm thấy sách');
      }

      final updatedBook = book.copyWith(
        shelfLocation: _locationController.text.trim(),
        shelfType: _shelfTypeController.text.trim(),
        shelfNumber: _shelfNumberController.text.trim(),
      );

      await viewModel.updateBook(book.id!, updatedBook);
      viewModel.setCurrentBook(updatedBook.copyWith(id: book.id));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu vị trí sách!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() => _hasChanges = false);
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Vị trí sách',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveLocation,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Lưu',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// CARD: VỊ TRÍ SÁCH
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Vị trí sách',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    decoration: _inputDecoration('Nhập vị trí (VD: Kệ sách phòng khách)'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// CARD: THÔNG TIN THÊM
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin thêm',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Loại kệ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _shelfTypeController,
                    decoration: _inputDecoration('VD: Phòng khách, Phòng ngủ...'),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Số kệ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _shelfNumberController,
                    decoration: _inputDecoration('VD: Kệ 1, Kệ 2...'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading || !_hasChanges ? null : _saveLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Lưu vị trí',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CARD STYLE
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// INPUT DECORATION
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 1.5),
      ),
    );
  }
}
