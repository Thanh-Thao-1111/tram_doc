import 'package:flutter/material.dart';
import 'add_bookshelf_page.dart';

class AddBookSearchPage extends StatelessWidget {
  const AddBookSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm sách'),
        leading: const BackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Harry Potter tập ${index + 1}'),
            subtitle: const Text('J.K. Rowling'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddBookPreviewPage(),
                  ),
                );
              },
              child: const Text('Thêm'),
            ),
          );
        },
      ),
    );
  }
}
