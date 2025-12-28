import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../repositories/book_repository.dart';
import '../models/note_model.dart';
import '../models/review_model.dart';

class LibraryViewModel extends ChangeNotifier {
  
  // 1. Khởi tạo Repository
  final BookRepository _bookRepo = BookRepository();

  // 2. Trạng thái (State)
  List<BookModel> _libraryBooks = [];   
  List<BookModel> _searchedBooks = [];  
  
  List<NoteModel> _notes = [];          
  List<ReviewModel> _reviews = [];      
  
  bool _isLoading = false;
  bool _isSearching = false;            
  
  BookModel? _currentBook;
  int _currentPage = 0;              

  // 🔥 THÊM MỚI: Biến lưu từ khóa tìm kiếm nội bộ
  String _localSearchQuery = '';

  // 3. Getter
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  BookModel? get currentBook => _currentBook;
  
  int get currentPage => _currentPage; 
  int get totalPages => _currentBook?.pageCount ?? 0;
  
  List<NoteModel> get notes => _notes;       
  List<ReviewModel> get reviews => _reviews; 
  List<BookModel> get searchedBooks => _searchedBooks;

  // 🔥🔥🔥 PHẦN 1: LOGIC CHIA TAB TỰ ĐỘNG + LỌC TÌM KIẾM 🔥🔥🔥

  // Helper function: Kiểm tra sách có khớp từ khóa không
  bool _matchesQuery(BookModel book) {
    if (_localSearchQuery.isEmpty) return true;
    final query = _localSearchQuery.toLowerCase();
    return book.title.toLowerCase().contains(query) || 
           book.author.toLowerCase().contains(query);
  }

  // Tab 1: Tất cả sách (Đã thêm logic lọc)
  List<BookModel> get libraryBooks {
    if (_localSearchQuery.isEmpty) return _libraryBooks;
    return _libraryBooks.where((book) => _matchesQuery(book)).toList();
  }

  // Tab 2: Đang đọc (Tiến độ > 0 và chưa xong + Lọc)
  List<BookModel> get readingBooks {
    // Lấy danh sách đang đọc gốc
    final list = _libraryBooks.where((book) {
      return book.currentPage > 0 && book.currentPage < book.pageCount;
    }).toList();

    // Áp dụng bộ lọc tìm kiếm
    if (_localSearchQuery.isEmpty) return list;
    return list.where((book) => _matchesQuery(book)).toList();
  }

  // Tab 3: Đã đọc (Tiến độ >= tổng số trang + Lọc)
  List<BookModel> get finishedBooks {
    // Lấy danh sách đã đọc gốc
    final list = _libraryBooks.where((book) {
      return book.pageCount > 0 && book.currentPage >= book.pageCount;
    }).toList();

    // Áp dụng bộ lọc tìm kiếm
    if (_localSearchQuery.isEmpty) return list;
    return list.where((book) => _matchesQuery(book)).toList();
  }

  // 🔥 THÊM MỚI: Hàm để UI gọi khi gõ vào ô tìm kiếm
  void setLocalSearchQuery(String query) {
    _localSearchQuery = query;
    notifyListeners(); // Báo UI vẽ lại danh sách ngay lập tức
  }

  // --- CÁC HÀM LẤY DỮ LIỆU ---
  
  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _libraryBooks = await _bookRepo.getLibraryBooks();
    } catch (e) {
      print("Lỗi fetchBooks: $e");
    }
    _isLoading = false;
    notifyListeners(); 
  }

  // (Hàm này giờ ít dùng nếu bạn chỉ tìm nội bộ, nhưng cứ giữ lại để dùng cho tính năng Thêm sách Online sau này)
  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      stopSearching();
      return;
    }
    _isSearching = true;
    _isLoading = true;
    notifyListeners();

    try {
      _searchedBooks = await _bookRepo.searchBooks(query);
    } catch (e) {
      _searchedBooks = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToLibrary(BookModel book) async {
    _isLoading = true;
    notifyListeners();
    bool success = await _bookRepo.addBookToLibrary(book);
    if (success) {
      await fetchBooks(); 
      stopSearching(); 
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  // --- GHI CHÚ & ĐÁNH GIÁ ---
  
  Future<void> fetchNotes() async {
    if (_currentBook == null) return;
    _notes = await _bookRepo.getNotes(_currentBook!.id);
    notifyListeners();
  }

  Future<void> addUserNote(String content, int page) async {
    if (_currentBook == null) return;
    bool success = await _bookRepo.addNote(_currentBook!.id, content, page);
    if (success) await fetchNotes(); 
  }

  Future<void> fetchReviews() async {
    if (_currentBook == null) return;
    _reviews = await _bookRepo.getReviews(_currentBook!.title);
    notifyListeners();
  }

  Future<void> addUserReview(String comment, int rating) async {
    if (_currentBook == null) return;
    bool success = await _bookRepo.addReview(_currentBook!.title, comment, rating);
    if (success) await fetchReviews();
  }

  // --- TIỆN ÍCH ---

  void stopSearching() {
    _isSearching = false;
    _searchedBooks = [];
    _localSearchQuery = ''; // Reset cả tìm kiếm nội bộ
    notifyListeners();
  }

  void setCurrentBook(BookModel book) {
    _currentBook = book;
    _currentPage = book.currentPage; 
    _notes = [];
    _reviews = [];
    notifyListeners();
  }

  // 🔥🔥🔥 PHẦN 2: CẬP NHẬT TIẾN ĐỘ & LƯU FIREBASE 🔥🔥🔥
  Future<void> updateReadingProgress(int newPage) async {
    if (_currentBook != null) {
      _currentPage = newPage;
      notifyListeners();

      await _bookRepo.updateBookProgress(_currentBook!.id, newPage);

      final index = _libraryBooks.indexWhere((b) => b.id == _currentBook!.id);
      if (index != -1) {
        final updatedBook = BookModel(
          id: _currentBook!.id,
          title: _currentBook!.title,
          author: _currentBook!.author,
          imageUrl: _currentBook!.imageUrl,
          pageCount: _currentBook!.pageCount,
          currentPage: newPage,
        );

        _libraryBooks[index] = updatedBook;
        _currentBook = updatedBook;
      }

      notifyListeners(); 
    }
  }

  // --- VALIDATE ---

  String? validatePageNumber(String? value, {int? maxPage}) {
    final limit = maxPage ?? totalPages; 
    if (value == null || value.isEmpty) return 'Nhập số trang';
    final n = int.tryParse(value);
    if (n == null) return 'Phải là số';
    if (n < 0) return 'Không thể âm';
    if (limit > 0 && n > limit) return 'Vượt quá $limit';
    return null;
  }

  String? validateFlashcardSide(String? value, String side) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập $side';
    return null;
  }

  String? validateContent(String? value, {int minLength = 1, String fieldName = "Nội dung"}) {
    if (value == null || value.trim().isEmpty) return '$fieldName trống';
    if (value.trim().length < minLength) return '$fieldName quá ngắn';
    return null;
  }

  void createFlashcard(String question, String answer) {
    print("Tạo Flashcard: $question - $answer");
    notifyListeners();
  }
}