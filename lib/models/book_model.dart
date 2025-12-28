// File: lib/models/book_model.dart

class BookModel {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final int pageCount; 

  final int currentPage;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.pageCount,

    this.currentPage = 0,

    
  });

  // 1. Hàm đọc dữ liệu từ Firebase về App
  factory BookModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookModel(
      id: id,
      title: data['title'] ?? 'Không tên',
      author: data['author'] ?? 'Ẩn danh',
      imageUrl: data['imageUrl'] ?? '',
      // Ưu tiên lấy pageCount, nếu không có thì thử lấy page, không có nữa thì bằng 0
      pageCount: int.tryParse((data['pageCount'] ?? data['page']).toString()) ?? 0,
    );
  }

  // 2. Hàm đọc dữ liệu từ API Google Books (Để dùng cho chức năng Tìm kiếm)
  factory BookModel.fromGoogleJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    
    // Xử lý ảnh (Google trả về object imageLinks, cần check null)
    String img = '';
    if (volumeInfo['imageLinks'] != null) {
      img = volumeInfo['imageLinks']['thumbnail'] ?? '';
    }

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Chưa cập nhật tên',
      author: (volumeInfo['authors'] as List?)?.first ?? 'Chưa cập nhật tác giả',
      imageUrl: img,
      pageCount: volumeInfo['pageCount'] ?? 0,
    );
  }
}