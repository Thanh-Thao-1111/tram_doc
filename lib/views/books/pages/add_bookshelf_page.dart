import 'package:flutter/material.dart';

class AddBookPreviewPage extends StatelessWidget {
  const AddBookPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Thêm sách vào kệ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Book cover
            Container(
              height: 200,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Tâm lý học về tiền',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Morgan Housel',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            _ActionButton(
              icon: Icons.bookmark_border,
              label: 'Muốn đọc',
            ),
            _ActionButton(
              icon: Icons.menu_book_outlined,
              label: 'Đang đọc',
            ),
            _ActionButton(
              icon: Icons.check_circle_outline,
              label: 'Đã đọc',
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        onPressed: () {},
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
