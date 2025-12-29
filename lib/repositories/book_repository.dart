import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book_model.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Collection reference
  CollectionReference get _booksCollection => _firestore.collection('books');

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Add a new book to the user's library
  Future<String> addBook(BookModel book) async {
    if (_currentUserId == null) {
      throw Exception('Bạn cần đăng nhập để thêm sách');
    }

    try {
      final bookWithUser = book.copyWith(userId: _currentUserId);
      final docRef = await _booksCollection.add(bookWithUser.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Không thể thêm sách: $e');
    }
  }

  /// Get all books for current user
  Future<List<BookModel>> getBooks() async {
    if (_currentUserId == null) {
      return [];
    }

    try {
      final querySnapshot = await _booksCollection
          .where('userId', isEqualTo: _currentUserId)
          .get();

      final books = querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
      
      // Sort by createdAt on client side to avoid needing composite index
      books.sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
      return books;
    } catch (e) {
      throw Exception('Không thể tải danh sách sách: $e');
    }
  }

  /// Get books as a stream for real-time updates
  Stream<List<BookModel>> getBooksStream() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _booksCollection
        .where('userId', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
          final books = snapshot.docs
              .map((doc) => BookModel.fromFirestore(doc))
              .toList();
          // Sort by createdAt on client side
          books.sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
          return books;
        });
  }

  /// Get a single book by ID
  Future<BookModel?> getBookById(String id) async {
    try {
      final doc = await _booksCollection.doc(id).get();
      if (doc.exists) {
        return BookModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Không thể tải thông tin sách: $e');
    }
  }

  /// Update an existing book
  Future<void> updateBook(String id, BookModel book) async {
    if (_currentUserId == null) {
      throw Exception('Bạn cần đăng nhập để cập nhật sách');
    }

    try {
      final data = book.toFirestore();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _booksCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Không thể cập nhật sách: $e');
    }
  }

  /// Update reading progress and status
  Future<void> updateReadingProgress(String id, int currentPage, String readingStatus) async {
    try {
      await _booksCollection.doc(id).update({
        'currentPage': currentPage,
        'readingStatus': readingStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Không thể cập nhật tiến độ đọc: $e');
    }
  }

  /// Delete a book
  Future<void> deleteBook(String id) async {
    if (_currentUserId == null) {
      throw Exception('Bạn cần đăng nhập để xóa sách');
    }

    try {
      await _booksCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Không thể xóa sách: $e');
    }
  }

  /// Check if book already exists in user's library (by ISBN)
  Future<bool> bookExists(String isbn) async {
    if (_currentUserId == null) return false;

    try {
      final querySnapshot = await _booksCollection
          .where('userId', isEqualTo: _currentUserId)
          .where('isbn', isEqualTo: isbn)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // =================== NOTES ===================
  
  /// Add a note to a book
  Future<String> addNote(String bookId, String content, int pageNumber) async {
    if (_currentUserId == null) {
      throw Exception('Bạn cần đăng nhập để thêm ghi chú');
    }

    try {
      final noteRef = await _booksCollection.doc(bookId).collection('notes').add({
        'content': content,
        'page': pageNumber,
        'date': FieldValue.serverTimestamp(),
        'userId': _currentUserId,
      });
      return noteRef.id;
    } catch (e) {
      throw Exception('Không thể thêm ghi chú: $e');
    }
  }

  /// Get all notes for a book
  Future<List<Map<String, dynamic>>> getNotes(String bookId) async {
    try {
      final querySnapshot = await _booksCollection
          .doc(bookId)
          .collection('notes')
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      // If orderBy fails due to missing index, try without ordering
      try {
        final querySnapshot = await _booksCollection
            .doc(bookId)
            .collection('notes')
            .get();

        final notes = querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        
        // Sort on client side
        notes.sort((a, b) {
          final dateA = a['date'] as Timestamp?;
          final dateB = b['date'] as Timestamp?;
          if (dateA == null || dateB == null) return 0;
          return dateB.compareTo(dateA);
        });
        
        return notes;
      } catch (e2) {
        throw Exception('Không thể tải ghi chú: $e2');
      }
    }
  }

  /// Delete a note
  Future<void> deleteNote(String bookId, String noteId) async {
    try {
      await _booksCollection.doc(bookId).collection('notes').doc(noteId).delete();
    } catch (e) {
      throw Exception('Không thể xóa ghi chú: $e');
    }
  }
}
