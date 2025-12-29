import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/book_model.dart'; 
import '../repositories/card_repository.dart';
import '../repositories/book_repository.dart'; 

// ==========================================
// CLASS 1: Menu Dashboard (ReviewPage)
// ==========================================
class ReviewDashboardViewModel extends ChangeNotifier {
  final CardRepository _repository = CardRepository();

  int _cardsToReview = 0; 
  int _cardsMistake = 0;
  bool _isLoading = true;
  List<DateTime> _completedDates = []; // Lưu danh sách ngày đã học thật

  int get cardsToReview => _cardsToReview;
  int get cardsMistake => _cardsMistake;
  bool get isLoading => _isLoading;
  List<DateTime> get completedDates => _completedDates; // UI sẽ gọi cái này
  
  ReviewDashboardViewModel() {
    refreshCounts();
  }

  /// Tải số lượng thẻ và chuỗi ngày thực tế từ Firebase
  Future<void> refreshCounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Lấy danh sách thẻ đến hạn từ Repository
      final dueCards = await _repository.getDueCards();
      _cardsToReview = dueCards.length;
      
      // 2. Lấy dữ liệu ngày đã ôn tập để hiển thị Streak (Đã sửa ở đây)
      _completedDates = await _repository.getCompletedDates();
      
      // Giả sử logic cho cardsMistake (có thể mở rộng sau)
      _cardsMistake = 0; 
      
    } catch (e) {
      debugPrint("Lỗi khi cập nhật Dashboard: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? validateBeforeNavigating(String mode) {
    if (mode == "DAILY_REVIEW" && _cardsToReview <= 0) {
      return "Hết bài ôn tập hôm nay rồi!";
    }
    if (mode == "MISTAKE_REVIEW" && _cardsMistake <= 0) {
      return "Không có thẻ sai nào.";
    }
    return null;
  }

  void debugSetData({int? reviewCount}) {
    if (reviewCount != null) _cardsToReview = reviewCount;
    notifyListeners();
  }
}

// ==========================================
// CLASS 2: Màn hình Player (FlashcardPlayerPage)
// ==========================================
class FlashcardPlayerViewModel extends ChangeNotifier {
  final CardRepository _repository = CardRepository();

  List<FlashcardData> _cards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _isFinished = false;
  bool _isLoading = true;

  int _easyCount = 0;
  int _goodCount = 0;
  int _hardCount = 0;

  List<FlashcardData> get cards => _cards;
  FlashcardData get currentCard => _cards[_currentIndex];
  int get currentIndex => _currentIndex;
  int get totalCards => _cards.length;
  bool get isFlipped => _isFlipped;
  bool get isFinished => _isFinished;
  bool get isLoading => _isLoading;

  int get easyCount => _easyCount;
  int get goodCount => _goodCount;
  int get hardCount => _hardCount;

  FlashcardPlayerViewModel() {
    fetchCardsFromFirebase();
  }

  Future<void> fetchCardsFromFirebase() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cards = await _repository.getDueCards();
    } catch (e) {
      debugPrint("Lỗi khi tải cards: $e");
    } finally {
      _isLoading = false;
      if (_cards.isEmpty) _isFinished = true;
      notifyListeners();
    }
  }

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  Future<void> handleRating(String ratingLabel) async {
    if (ratingLabel == "Dễ") {
      _easyCount++;
    } else if (ratingLabel == "Tốt") {
      _goodCount++;
    } else {
      _hardCount++;
    }

    int ratingValue = ratingLabel == "Dễ" ? 5 : (ratingLabel == "Tốt" ? 3 : 1);
    try {
      await _repository.logReview(currentCard.id, ratingValue);
    } catch (e) {
      debugPrint("Lỗi khi lưu review: $e");
    }

    if (_currentIndex < _cards.length - 1) {
      _currentIndex++;
      _isFlipped = false;
    } else {
      _isFinished = true;
    }
    notifyListeners();
  }
}

// ==========================================
// CLASS 3: Màn hình Chọn sách (SelectBookPage)
// ==========================================
class SelectBookViewModel extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();

  List<BookModel> _allBooks = []; 
  List<BookModel> _filteredBooks = [];
  bool _isLoading = true;

  List<BookModel> get books => _filteredBooks;
  bool get isLoading => _isLoading;

  SelectBookViewModel() {
    fetchUserBooks();
  }

  Future<void> fetchUserBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allBooks = await _bookRepository.getBooks();
      _filteredBooks = List.from(_allBooks);
    } catch (e) {
      debugPrint("Lỗi khi tải sách: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchBook(String query) {
    if (query.isEmpty) {
      _filteredBooks = List.from(_allBooks);
    } else {
      _filteredBooks = _allBooks.where((book) {
        final title = book.title.toLowerCase();
        final author = book.author.toLowerCase();
        final search = query.toLowerCase();
        return title.contains(search) || author.contains(search);
      }).toList();
    }
    notifyListeners();
  }
}