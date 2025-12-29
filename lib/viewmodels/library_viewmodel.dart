import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/note_model.dart';
import '../models/review_model.dart';
import '../repositories/book_repository.dart';
import '../../models/card_model.dart';

class LibraryViewModel extends ChangeNotifier {
  final BookRepository _bookRepo = BookRepository();

  // 1. Trạng thái
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;

  List<BookModel> _libraryBooks = [];
  List<BookModel> _searchedBooks = [];
  List<NoteModel> _notes = [];
  List<ReviewModel> _reviews = [];

  BookModel? _currentBook;
  int _currentPage = 0;

  // Tìm kiếm nội bộ
  String _localSearchQuery = '';

  // ====================== GETTERS ======================
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;

  BookModel? get currentBook => _currentBook;
  int get currentPage => _currentPage;
  int get totalPages => _currentBook?.pageCount ?? 0;

  List<BookModel> get libraryBooks {
    if (_localSearchQuery.isEmpty) return _libraryBooks;
    return _libraryBooks.where((b) => _matchesQuery(b)).toList();
  }

  List<BookModel> get searchedBooks => _searchedBooks;
  List<NoteModel> get notes => _notes;
  List<ReviewModel> get reviews => _reviews;

  List<BookModel> get readingBooks {
    final list = _libraryBooks.where((b) => b.currentPage > 0 && b.currentPage < (b.pageCount ?? 0)).toList();
    if (_localSearchQuery.isEmpty) return list;
    return list.where((b) => _matchesQuery(b)).toList();
  }

  List<BookModel> get finishedBooks {
    final list = _libraryBooks.where((b) => (b.pageCount ?? 0) > 0 && b.currentPage >= (b.pageCount ?? 0)).toList();
    if (_localSearchQuery.isEmpty) return list;
    return list.where((b) => _matchesQuery(b)).toList();
  }

  // ====================== SEARCH HELPERS ======================
  bool _matchesQuery(BookModel book) {
    if (_localSearchQuery.isEmpty) return true;
    final query = _localSearchQuery.toLowerCase();
    return book.title.toLowerCase().contains(query) || book.author.toLowerCase().contains(query);
  }

  void setLocalSearchQuery(String query) {
    _localSearchQuery = query;
    notifyListeners();
  }

  void stopSearching() {
    _isSearching = false;
    _searchedBooks = [];
    _localSearchQuery = '';
    notifyListeners();
  }

  // ====================== BOOK MANAGEMENT ======================
  Future<void> loadBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _libraryBooks = await _bookRepo.getBooks(); // Firestore
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _libraryBooks = await _bookRepo.getBooks();
    } catch (e) {
      print("Lỗi fetchBooks: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      stopSearching();
      return;
    }
    _isSearching = true;
    _isLoading = true;
    notifyListeners();
    try {
      // Filter locally since BookRepository doesn't have searchBooks
      _searchedBooks = _libraryBooks.where((b) =>
        b.title.toLowerCase().contains(query.toLowerCase()) ||
        b.author.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      _searchedBooks = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToLibrary(BookModel book) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _bookRepo.addBook(book);
      await fetchBooks();
      stopSearching();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setCurrentBook(BookModel book) {
    _currentBook = book;
    _currentPage = book.currentPage;
    _notes = [];
    _reviews = [];
    notifyListeners();
  }

  Future<void> updateReadingProgress(int newPage) async {
    if (_currentBook != null && _currentBook!.id != null) {
      _currentPage = newPage;
      
      // Tự động xác định trạng thái đọc dựa trên tiến độ
      final totalPages = _currentBook!.pageCount ?? 0;
      ReadingStatus newStatus;
      
      if (newPage <= 0) {
        // Trang 0 = Muốn đọc
        newStatus = ReadingStatus.wantToRead;
      } else if (totalPages > 0 && newPage >= totalPages) {
        // Đọc hết = Đã đọc
        newStatus = ReadingStatus.completed;
      } else {
        // Đang đọc giữa chừng = Đang đọc
        newStatus = ReadingStatus.reading;
      }
      
      notifyListeners();

      // Cập nhật lên Firestore với cả currentPage và readingStatus
      final statusString = newStatus == ReadingStatus.completed 
          ? 'completed' 
          : (newStatus == ReadingStatus.reading ? 'reading' : 'wantToRead');
      
      await _bookRepo.updateReadingProgress(_currentBook!.id!, newPage, statusString);

      final index = _libraryBooks.indexWhere((b) => b.id == _currentBook!.id);
      if (index != -1) {
        final updatedBook = _currentBook!.copyWith(
          currentPage: newPage,
          readingStatus: newStatus,
        );
        _libraryBooks[index] = updatedBook;
        _currentBook = updatedBook;
      }

      notifyListeners();
    }
  }

  // Delete a book from library
  Future<void> deleteBook(String bookId) async {
    await _bookRepo.deleteBook(bookId);
    _libraryBooks.removeWhere((b) => b.id == bookId);
    if (_currentBook?.id == bookId) {
      _currentBook = null;
    }
    notifyListeners();
  }

  // Update book details
  Future<void> updateBook(String bookId, BookModel book) async {
    await _bookRepo.updateBook(bookId, book);
    final index = _libraryBooks.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      _libraryBooks[index] = book.copyWith(id: bookId);
    }
    if (_currentBook?.id == bookId) {
      _currentBook = book.copyWith(id: bookId);
    }
    notifyListeners();
  }

  // ====================== NOTES & REVIEWS ======================
  // Note: Notes and Reviews are stored locally for now (stub implementation)
  Future<void> fetchNotes() async {
    if (_currentBook == null) return;
    // TODO: Implement notes storage in Firestore
    _notes = [];
    notifyListeners();
  }

  Future<void> addUserNote(String content, int page) async {
    if (_currentBook == null) return;
    // TODO: Implement notes storage in Firestore
    notifyListeners();
  }

  Future<void> fetchReviews() async {
    if (_currentBook == null) return;
    // TODO: Implement reviews storage in Firestore
    _reviews = [];
    notifyListeners();
  }

  Future<void> addUserReview(String comment, int rating) async {
    if (_currentBook == null) return;
    // TODO: Implement reviews storage in Firestore
    notifyListeners();
  }

  // ====================== FLASHCARDS ======================
  
  // TODO: Implement flashcards storage in Firestore
  void createFlashcard(String question, String answer) {
    // Stub implementation - flashcards functionality to be implemented
    print('Creating flashcard: Q: $question, A: $answer');
    notifyListeners();
  }

  // ====================== VALIDATORS ======================
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
}
