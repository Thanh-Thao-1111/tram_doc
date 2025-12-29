import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../models/note_model.dart';
import '../models/review_model.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Lấy sách từ Firebase 
  Future<List<BookModel>> getLibraryBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      return snapshot.docs.map((doc) {
        return BookModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Lỗi lấy sách Firebase: $e");
      return [];
    }
  }

  // 2. Tìm sách từ Google Books (NÂNG CẤP XỬ LÝ ẢNH)
  Future<List<BookModel>> searchBooks(String query) async {
    if (query.isEmpty) return [];
    
    print("🚀 ĐANG GỌI GOOGLE API TÌM: $query"); 

    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        return items.map((item) {
          final volumeInfo = item['volumeInfo'];
          final imageLinks = volumeInfo['imageLinks'] ?? {};

          // 🔥 LOGIC LẤY ẢNH MỚI: 
          // 1. Ưu tiên lấy ảnh thumbnail, nếu không có thì lấy smallThumbnail
          String rawImageUrl = imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'] ?? '';

          // 2. Xử lý link ảnh
          if (rawImageUrl.isNotEmpty) {
            // Đổi http thành https
            rawImageUrl = rawImageUrl.replaceFirst('http://', 'https://');
            
            // Xóa hiệu ứng "cong góc sách" (edge=curl) gây lỗi hiển thị
            rawImageUrl = rawImageUrl.replaceAll('&edge=curl', '');
            
            // (Tùy chọn) Thử zoom=1 để ảnh rõ hơn nếu cần
            // rawImageUrl = rawImageUrl.replaceAll('&zoom=1', '&zoom=2'); 
          }

          // In ra link ảnh để kiểm tra (Click vào link trong Console xem có ra ảnh không)
          print("Link ảnh: $rawImageUrl");

          return BookModel(
            id: item['id'], 
            title: volumeInfo['title'] ?? 'Không có tên',
            author: (volumeInfo['authors'] as List<dynamic>?)?.first ?? 'Ẩn danh',
            imageUrl: rawImageUrl, 
            pageCount: volumeInfo['pageCount'] ?? 0,
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Lỗi tìm sách Google: $e");
      return [];
    }
  }

  // --- 3. THÊM SÁCH VÀO THƯ VIỆN (MỚI) ---
  Future<bool> addBookToLibrary(BookModel book) async {
    try {
      // Tạo dữ liệu để gửi lên Firebase
      // 🔥 LƯU Ý: Tên trường (key) phải khớp y hệt database nhóm bạn
      final data = {
        'title': book.title,
        'author': book.author,
        'imageUrl': book.imageUrl,
        'pageCount': book.pageCount, 
        'source': 'google_books', 
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('books').add(data);
      print("Đã thêm sách '${book.title}' vào Firebase!");
      return true; // Báo thành công
    } catch (e) {
      print("Lỗi thêm sách: $e");
      return false; // Báo thất bại
    }
  }

  Future<void> updateBookProgress(String bookId, int newPage) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'currentPage': newPage,
      });
    } catch (e) {
      print("Lỗi update progress: $e");
    }
  }

  // --- PHẦN GHI CHÚ (Lưu trong sub-collection của sách) ---
  
  // 1. Lấy danh sách ghi chú
  Future<List<NoteModel>> getNotes(String bookId) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('notes')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("❌ Lỗi lấy ghi chú: $e");
      return [];
    }
  }

  // 2. Thêm ghi chú mới
  Future<bool> addNote(String bookId, String content, int page) async {
    try {
      await _firestore.collection('books').doc(bookId).collection('notes').add({
        'content': content,
        'page': page,
        'date': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- PHẦN CỘNG ĐỒNG (Lưu trong collection 'reviews' chung) ---

  // 3. Lấy đánh giá của sách này (Dựa theo tên sách cho đơn giản)
  Future<List<ReviewModel>> getReviews(String bookTitle) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('bookTitle', isEqualTo: bookTitle)
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("❌ Lỗi lấy đánh giá: $e");
      return [];
    }
  }

  // 4. Thêm đánh giá
  Future<bool> addReview(String bookTitle, String comment, int rating) async {
    try {
      await _firestore.collection('reviews').add({
        'bookTitle': bookTitle,
        'userName': 'Tôi', // Tạm thời để cứng, sau này lấy từ User Auth
        'rating': rating,
        'comment': comment,
        'date': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}