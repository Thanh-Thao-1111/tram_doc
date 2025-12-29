import 'package:flutter/material.dart';

// ==========================================
// CLASS 1: Menu Dashboard (ReviewPage)
// ==========================================
class ReviewDashboardViewModel extends ChangeNotifier {
  int _cardsToReview = 5; // Giả lập có 5 bài
  int _cardsMistake = 2;

  int get cardsToReview => _cardsToReview;
  int get cardsMistake => _cardsMistake;

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
class FlashcardData {
  final String question;
  final String answer;
  final String source;
  FlashcardData({required this.question, required this.answer, required this.source});
}

class FlashcardPlayerViewModel extends ChangeNotifier {
  final List<FlashcardData> _cards = [
    FlashcardData(question: "Tác giả Đắc Nhân Tâm?", answer: "Dale Carnegie", source: "Sách"),
    FlashcardData(question: "Thủ đô VN?", answer: "Hà Nội", source: "Địa lý"),
    FlashcardData(question: "Flutter dùng ngôn ngữ gì?", answer: "Dart", source: "IT"),
  ];

  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _isFinished = false;

  FlashcardData get currentCard => _cards[_currentIndex];
  int get currentIndex => _currentIndex;
  int get totalCards => _cards.length;
  bool get isFlipped => _isFlipped;
  bool get isFinished => _isFinished;

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void handleRating(String rating) {
    print("User chọn: $rating");
    if (_currentIndex < _cards.length - 1) {
      _currentIndex++;
      _isFlipped = false;
      notifyListeners();
    } else {
      _isFinished = true;
      notifyListeners();
    }
  }
}

// ==========================================
// CLASS 3: Màn hình Chọn sách (SelectBookPage)
// Nhiệm vụ: Chứa danh sách sách giả lập & Logic tìm kiếm
// ==========================================
class SelectBookViewModel extends ChangeNotifier {
  // 1. Data giả lập (Dùng Map như ông yêu cầu)
  final List<Map<String, dynamic>> _allBooks = [
    {
      'title': "Đắc Nhân Tâm",
      'author': "Dale Carnegie",
      'count': 120,
      'color': Colors.blue,
      'image': "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1449557635i/4865.jpg"
    },
    {
      'title': "Nhà Giả Kim",
      'author': "Paulo Coelho",
      'count': 85,
      'color': Colors.purple,
      'image': "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654371463i/18144590.jpg"
    },
    {
      'title': "Atomic Habits",
      'author': "James Clear",
      'count': 200,
      'color': Colors.green,
      'image': "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1655988385i/40121378.jpg"
    },
    {
      'title': "Tâm lý học về tiền",
      'author': "Morgan Housel",
      'count': 45,
      'color': Colors.orange,
      'image': "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1635328224i/59495633.jpg"
    },
    {
      'title': "Nghĩ Giàu Làm Giàu",
      'author': "Napoleon Hill",
      'count': 110,
      'color': Colors.red,
      'image': "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1463241782i/30186948.jpg"
    },
  ];

  // Danh sách hiển thị (đã qua lọc)
  List<Map<String, dynamic>> _filteredBooks = [];
  List<Map<String, dynamic>> get books => _filteredBooks;

  SelectBookViewModel() {
    _filteredBooks = List.from(_allBooks); // Mới vào hiển thị hết
  }

  // LOGIC TÌM KIẾM
  void searchBook(String query) {
    if (query.isEmpty) {
      _filteredBooks = List.from(_allBooks);
    } else {
      _filteredBooks = _allBooks.where((book) {
        final title = book['title'].toString().toLowerCase();
        final author = book['author'].toString().toLowerCase();
        final search = query.toLowerCase();
        return title.contains(search) || author.contains(search);
      }).toList();
    }
    notifyListeners(); // Báo UI update
  }
}