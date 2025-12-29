import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../repositories/book_repository.dart';

class LibraryViewModel extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Books list
  List<BookModel> _libraryBooks = [];
  List<BookModel> get libraryBooks => _libraryBooks;

  // Current book being viewed
  BookModel? _currentBook;
  BookModel? get currentBook => _currentBook;

  // Getters for current book progress
  int get currentPage => _currentBook?.currentPage ?? 0;
  int get totalPages => _currentBook?.pageCount ?? 0;

  /// Load books from Firestore
  Future<void> loadBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _libraryBooks = await _bookRepository.getBooks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Listen to books stream for real-time updates
  void listenToBooks() {
    _bookRepository.getBooksStream().listen((books) {
      _libraryBooks = books;
      notifyListeners();
    });
  }

  /// Set current book for detail view
  void setCurrentBook(BookModel book) {
    _currentBook = book;
    notifyListeners();
  }

  /// Add a new book
  Future<bool> addBook(BookModel book) async {
    try {
      await _bookRepository.addBook(book);
      await loadBooks();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update an existing book
  Future<bool> updateBook(String id, BookModel book) async {
    try {
      await _bookRepository.updateBook(id, book);
      if (_currentBook?.id == id) {
        _currentBook = book.copyWith(id: id);
      }
      await loadBooks();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update reading progress
  Future<void> updateReadingProgress(int newPage) async {
    if (_currentBook == null || _currentBook!.id == null) return;

    try {
      await _bookRepository.updateReadingProgress(_currentBook!.id!, newPage);
      _currentBook = _currentBook!.copyWith(currentPage: newPage);
      
      // Update in the list as well
      final index = _libraryBooks.indexWhere((b) => b.id == _currentBook!.id);
      if (index != -1) {
        _libraryBooks[index] = _currentBook!;
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Delete a book
  Future<bool> deleteBook(String id) async {
    try {
      await _bookRepository.deleteBook(id);
      _libraryBooks.removeWhere((b) => b.id == id);
      if (_currentBook?.id == id) {
        _currentBook = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- Form Validators ---

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