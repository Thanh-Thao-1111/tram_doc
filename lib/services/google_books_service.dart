import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class GoogleBooksService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  /// Search books by query (title, author, etc.)
  Future<List<BookModel>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = '$_baseUrl?q=$encodedQuery&maxResults=20&langRestrict=vi';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];

        return items.map((item) => BookModel.fromGoogleBooks(item)).toList();
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  /// Get book details by ISBN
  Future<BookModel?> getBookByISBN(String isbn) async {
    if (isbn.trim().isEmpty) return null;

    try {
      // Clean ISBN (remove dashes)
      final cleanIsbn = isbn.replaceAll('-', '').replaceAll(' ', '');
      final url = '$_baseUrl?q=isbn:$cleanIsbn';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List?;

        if (items != null && items.isNotEmpty) {
          return BookModel.fromGoogleBooks(items.first);
        }
        return null;
      } else {
        throw Exception('Failed to fetch book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book by ISBN: $e');
    }
  }
}
