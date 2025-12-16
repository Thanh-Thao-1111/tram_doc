import 'package:flutter/material.dart';
import 'community_tokens.dart';

class UserBook {
  final String title;
  final String author;
  final String? coverAsset; // có thể null để dùng placeholder

  const UserBook({required this.title, required this.author, this.coverAsset});
}

class UserBookGrid extends StatelessWidget {
  final List<UserBook> books;
  const UserBookGrid({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: books.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (_, i) => _BookItem(book: books[i]),
    );
  }
}

class _BookItem extends StatelessWidget {
  final UserBook book;
  const _BookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.78,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: book.coverAsset == null
                ? Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.menu_book, color: Colors.white, size: 36),
                  )
                : Image.asset(book.coverAsset!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: CommunityTokens.text),
        ),
        const SizedBox(height: 2),
        Text(
          book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: CommunityTokens.subText),
        ),
      ],
    );
  }
}
