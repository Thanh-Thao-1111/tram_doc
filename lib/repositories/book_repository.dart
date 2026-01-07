import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book_model.dart';
import '../models/review_model.dart';

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

  /// Update a note
  Future<void> updateNote(String bookId, String noteId, String content, int pageNumber) async {
    if (_currentUserId == null) {
      throw Exception('Bạn cần đăng nhập để sửa ghi chú');
    }

    try {
      await _booksCollection
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .update({
            'content': content,
            'page': pageNumber,
            'updatedAt': FieldValue.serverTimestamp(), // Thêm thời gian sửa đổi nếu cần
          });
    } catch (e) {
      throw Exception('Không thể cập nhật ghi chú: $e');
    }
  }
  // Trong BookRepository

  Future<void> addReview({required String bookId, required String comment, required int rating}) async {
    if (_currentUserId == null) throw Exception("Cần đăng nhập");

    final bookRef = _firestore.collection('books').doc(bookId);
    
    // Lấy thông tin user từ Firestore để có tên chính xác
    final userDoc = await _firestore.collection('users').doc(_currentUserId).get();
    final userData = userDoc.data() ?? {};
    final userName = userData['displayName'] ?? 
                     userData['username'] ?? 
                     _auth.currentUser?.displayName ?? 
                     _auth.currentUser?.email?.split('@').first ?? 
                     'Người dùng';

    // 1. Chạy Transaction để đảm bảo tính toán chính xác
    await _firestore.runTransaction((transaction) async {
      // Lấy thông tin sách hiện tại để biết đang có bao nhiêu đánh giá
      final bookSnapshot = await transaction.get(bookRef);
      if (!bookSnapshot.exists) throw Exception("Sách không tồn tại");

      final bookData = bookSnapshot.data() as Map<String, dynamic>;
      
      // Lấy số liệu cũ (nếu chưa có thì coi là 0)
      double currentRating = (bookData['rating'] ?? 0).toDouble();
      int ratingCount = (bookData['ratingCount'] ?? 0);

      // Tính toán trung bình mới
      // Công thức: ((Trung bình cũ * Số lượng cũ) + Điểm mới) / (Số lượng cũ + 1)
      double newRating = ((currentRating * ratingCount) + rating) / (ratingCount + 1);
      
      // Thêm review vào collection con
      final reviewRef = bookRef.collection('reviews').doc();
      transaction.set(reviewRef, {
        'userId': _currentUserId,
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'date': FieldValue.serverTimestamp(),
      });

      // Cập nhật lại số sao trung bình cho sách (để hiển thị ở header)
      transaction.update(bookRef, {
        'rating': newRating,
        'ratingCount': ratingCount + 1,
      });
    });
  }


  // Đảm bảo bạn đã có hàm getReviews khớp với cấu trúc trên
  Future<List<ReviewModel>> getReviews(String bookId) async {
    try {
      // Lấy danh sách bạn bè
      final friendIds = <String>{};
      if (_currentUserId != null) {
        friendIds.add(_currentUserId!); // Thêm chính mình
        
        final friendsSnapshot = await _firestore
            .collection('users')
            .doc(_currentUserId)
            .collection('friends')
            .get();
        
        for (var doc in friendsSnapshot.docs) {
          friendIds.add(doc.id);
        }
      }
      
      final snapshot = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('reviews')
          .orderBy('date', descending: true)
          .get();
      
      // Filter reviews: chỉ lấy của bạn bè và chính mình
      final allReviews = snapshot.docs.map((doc) {
        return ReviewModel.fromFirestore(doc.data(), doc.id);
      }).toList();
      
      // Nếu có danh sách bạn bè, filter theo đó
      if (friendIds.isNotEmpty) {
        return allReviews.where((review) => friendIds.contains(review.userId)).toList();
      }
      
      return allReviews;
    } catch (e) {
      print("LỖI LẤY REVIEW: $e");
      return [];
    }
  }
}
