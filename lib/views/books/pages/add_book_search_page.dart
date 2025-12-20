import 'package:flutter/material.dart';
import 'add_bookshelf_page.dart';

class AddBookSearchPage extends StatelessWidget {
  const AddBookSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thêm Sách Mới',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          ),
        leading: const BackButton(color: Colors.black),
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
