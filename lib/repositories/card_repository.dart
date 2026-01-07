import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/card_model.dart'; 

class CardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  // =========================================================
  // 1. HÀM THÊM CARD (CÁI BẠN ĐANG THIẾU)
  // =========================================================
  Future<void> addCard({
    required String question,
    required String answer,
    required String bookId,
  }) async {
    if (_currentUserId == null) throw Exception("Chưa đăng nhập");

    // Lưu vào collection 'flashcards'
    await _firestore.collection('flashcards').add({
      'userId': _currentUserId,
      'bookId': bookId,          // Lưu ID sách để lọc
      'front': question,         // Câu hỏi
      'back': answer,            // Câu trả lời
      'createdAt': FieldValue.serverTimestamp(),
      
      // Các trường cho thuật toán Spaced Repetition (SM-2)
      'nextReviewDate': FieldValue.serverTimestamp(), // Học ngay lập tức
      'interval': 0,    // Khoảng cách ngày giữa các lần ôn
      'easeFactor': 2.5, // Độ khó (mặc định 2.5)
      'repetitions': 0, // Số lần lặp lại liên tiếp đúng
    });
  }

  // =========================================================
  // 2. LẤY DANH SÁCH THẺ CẦN ÔN (DUE CARDS)
  // =========================================================
  Future<List<CardModel>> getDueCards() async {
    if (_currentUserId == null) return [];

    try {
      final now = Timestamp.now();
      
      final querySnapshot = await _firestore
          .collection('flashcards')
          .where('userId', isEqualTo: _currentUserId)
          .where('nextReviewDate', isLessThanOrEqualTo: now) // Lấy thẻ đã đến hạn
          .get();

      return querySnapshot.docs
          .map((doc) => CardModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Lỗi tải thẻ ôn tập: $e');
      return [];
    }
  }

  // =========================================================
  // 3. LOG REVIEW & TÍNH NGÀY ÔN TIẾP THEO (SM-2)
  // =========================================================
  Future<void> logReview(String cardId, int rating) async {
    // rating: 1 (Khó/Quên), 3 (Tốt), 5 (Dễ)
    if (_currentUserId == null) return;

    try {
      // B1: Lấy thông tin hiện tại của thẻ
      final cardRef = _firestore.collection('flashcards').doc(cardId);
      final doc = await cardRef.get();
      if (!doc.exists) return;

      final data = doc.data()!;
      int reps = data['repetitions'] ?? 0;
      double ease = (data['easeFactor'] ?? 2.5).toDouble();
      int interval = data['interval'] ?? 0;

      // B2: Tính toán thuật toán SM-2 (SuperMemo-2)
      if (rating >= 3) {
        // Nếu nhớ bài
        if (reps == 0) {
          interval = 1;
        } else if (reps == 1) {
          interval = 6;
        } else {
          interval = (interval * ease).round();
        }
        reps++;
        
        // Điều chỉnh độ khó (Ease Factor)
        ease = ease + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02));
        if (ease < 1.3) ease = 1.3;
      } else {
        // Nếu quên bài -> Reset về đầu
        reps = 0;
        interval = 1;
      }

      // B3: Cập nhật thẻ với ngày ôn mới
      final nextReviewDate = DateTime.now().add(Duration(days: interval));

      await cardRef.update({
        'repetitions': reps,
        'easeFactor': ease,
        'interval': interval,
        'nextReviewDate': Timestamp.fromDate(nextReviewDate),
      });

      // B4: Lưu lịch sử vào 'flashcard_reviews'
      await _firestore.collection('flashcard_reviews').add({
        'flashcardId': cardId,
        'userId': _currentUserId,
        'rating': rating,
        'reviewDate': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      throw Exception('Không thể lưu lịch sử ôn tập: $e');
    }
  }

  // =========================================================
  // 4. LẤY NGÀY ĐÃ HỌC (CHO STREAK)
  // =========================================================
  Future<List<DateTime>> getCompletedDates() async {
    if (_currentUserId == null) return [];
    try {
      // Lấy log học tập của user
      final snapshot = await _firestore
          .collection('flashcard_reviews')
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('reviewDate', descending: true)
          .limit(50) 
          .get();

      // Chuyển đổi sang DateTime
      return snapshot.docs.map((doc) {
        final ts = doc.data()['reviewDate'] as Timestamp?;
        if (ts == null) return DateTime.now();
        final date = ts.toDate();
        return DateTime(date.year, date.month, date.day);
      }).toSet().toList(); // Xóa trùng lặp
    } catch (e) {
      // Có thể lỗi do chưa đánh index trong Firestore, trả về list rỗng tạm thời
      print("Lỗi lấy streak: $e");
      return [];
    }
  }

  Future<List<CardModel>> getCardsByBookId(String bookId) async {
    if (_currentUserId == null) return [];
    
    try {
      // Lấy TẤT CẢ thẻ của cuốn sách này
      // (Bao gồm cả thẻ chưa đến hạn, để người dùng có thể ôn tập bất cứ lúc nào nếu muốn)
      final snapshot = await _firestore
          .collection('flashcards') 
          .where('userId', isEqualTo: _currentUserId)
          .where('bookId', isEqualTo: bookId) // Lọc theo ID sách
          .get();

      return snapshot.docs
          .map((doc) => CardModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Lỗi lấy thẻ theo sách: $e");
      return [];
    }
  }
}