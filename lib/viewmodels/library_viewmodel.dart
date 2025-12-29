import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/note_model.dart';
import '../models/review_model.dart';
import '../repositories/book_repository.dart';

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
    final list = _libraryBooks.where((b) => b.currentPage > 0 && b.currentPage < b.pageCount).toList();
    if (_localSearchQuery.isEmpty) return list;
    return list.where((b) => _matchesQuery(b)).toList();
  }

  List<BookModel> get finishedBooks {
    final list = _libraryBooks.where((b) => b.pageCount > 0 && b.currentPage >= b.pageCount).toList();
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
      _libraryBooks = await _bookRepo.getLibraryBooks(); // Repo cũ
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

  void setCurrentBook(BookModel book) {
    _currentBook = book;
    _currentPage = book.currentPage;
    _notes = [];
    _reviews = [];
    notifyListeners();
  }

  Future<void> updateReadingProgress(int newPage) async {
    if (_currentBook != null) {
      _currentPage = newPage;
      notifyListeners();

      await _bookRepo.updateBookProgress(_currentBook!.id, newPage);

      final index = _libraryBooks.indexWhere((b) => b.id == _currentBook!.id);
      if (index != -1) {
        final updatedBook = _currentBook!.copyWith(currentPage: newPage);
        _libraryBooks[index] = updatedBook;
        _currentBook = updatedBook;
      }

      notifyListeners();
    }
  }

  // ====================== NOTES & REVIEWS ======================
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
