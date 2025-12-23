import 'package:flutter/material.dart';

class LibraryViewModel extends ChangeNotifier {
  

  // Sách đang được chọn xem chi tiết
  Book? _currentBook;
  Book? get currentBook => _currentBook;

  // Danh sách sách (Giả lập Database)
  final List<Book> _libraryBooks = [
     Book('Nhà Giả Kim', 'Paulo Coelho', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1483412266i/865.jpg', 200, 100),
     Book('Tâm lý học về tiền', 'Morgan Housel', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg', 300, 50),
     Book('Đắc Nhân Tâm', 'Dale Carnegie', 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1442726934i/4865.jpg', 320, 0),
     Book('Harry Potter', 'J.K. Rowling', 'https://m.media-amazon.com/images/I/71Xq+KUVw0L._AC_UF1000,1000_QL80_.jpg', 500, 0),
     Book('Không gia đình', 'Hector Malot', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Sans_famille_1889.jpg/250px-Sans_famille_1889.jpg', 400, 10),
     Book('Cánh buồm đỏ thắm', 'Alexander Grin', 'https://cdn0.fahasa.com/media/catalog/product/c/a/canh-buom-do-tham_1_1.jpg', 150, 0),
  ];

  // Getter để bên ngoài lấy danh sách sách
  List<Book> get libraryBooks => _libraryBooks;

  // Lấy thông tin từ sách đang chọn (nếu null thì trả về 0)
  int get currentPage => _currentBook?.currentPage ?? 0;
  int get totalPages => _currentBook?.pageCount ?? 0;


  String? validateContent(String? value, {int minLength = 1, String fieldName = "Nội dung"}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    if (value.trim().length < minLength) {
      return '$fieldName quá ngắn (tối thiểu $minLength ký tự)';
    }
    return null;
  }

  String? validatePageNumber(String? value, {int? maxPage}) {
    // Lấy giới hạn trang từ sách đang chọn
    final limit = maxPage ?? totalPages; 

    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số trang';
    }
    final n = int.tryParse(value);
    if (n == null) return 'Phải nhập số nguyên';
    if (n < 0) return 'Số trang không thể âm';
    
    if (limit > 0 && n > limit) {
      return 'Vượt quá tổng số trang ($limit)';
    }
    return null;
  }

  String? validateFlashcardSide(String? value, String side) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $side';
    }
    return null;
  }

  bool validateRating(int rating) {
    return rating > 0;
  }
  //Hàm chọn sách ---
  void setCurrentBook(Book book) {
    _currentBook = book;
    notifyListeners();
  }

  // Cập nhật tiến độ đọc (Lưu thẳng vào object sách)
  void updateReadingProgress(int newPage) {
    if (_currentBook != null) {
      _currentBook!.currentPage = newPage;
      print("LOGIC: Đã cập nhật sách '${_currentBook!.title}' lên trang $newPage");
      notifyListeners();
    }
  }

  void addNote(String content, int? page) {
    print("LOGIC: Lưu Note cho sách '${_currentBook?.title}' -> '$content'");
    notifyListeners();
  }

  void createFlashcard(String question, String answer) {
    print("LOGIC: Tạo Flashcard -> '$question' - '$answer'");
    notifyListeners();
  }

  void submitReview(int rating, String content) {
    print("LOGIC: Gửi Review -> $rating sao, nội dung: '$content'");
    notifyListeners();
  }
}

class Book {
  final String title;
  final String author;
  final String imageUrl;
  int pageCount;   // Tổng số trang
  int currentPage; // Trang đang đọc

  Book(this.title, this.author, this.imageUrl, this.pageCount, this.currentPage);
}