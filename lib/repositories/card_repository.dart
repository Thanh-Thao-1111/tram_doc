import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/card_model.dart';

class CardRepository {
  // KHAI BÁO BIẾN _firestore Ở ĐÂY ĐỂ HẾT LỖI
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy UID của User hiện tại
  String? get _currentUserId => _auth.currentUser?.uid;

  /// 1. Lấy danh sách thẻ đến hạn ôn tập (nextReviewDate <= Now)
  Future<List<FlashcardData>> getDueCards() async {
    if (_currentUserId == null) return [];

    try {
      final now = DateTime.now();
      
      final querySnapshot = await _firestore
          .collection('flashcards')
          // Lọc theo User để đảm bảo bảo mật
          .where('userId', isEqualTo: _currentUserId) 
          // Lọc theo thời gian ôn tập (như trong ảnh Firebase của bạn)
          .where('nextReviewDate', isLessThanOrEqualTo: now)
          .get();

      return querySnapshot.docs
          .map((doc) => FlashcardData.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Không thể tải thẻ ôn tập: $e');
    }
  }

  /// 2. Ghi lịch sử ôn tập vào collection flashcard_reviews
  Future<void> logReview(String cardId, int rating) async {
    if (_currentUserId == null) return;

    try {
      await _firestore.collection('flashcard_reviews').add({
        'flashcardId': cardId,
        'userId': _currentUserId,
        'rating': rating,
        'reviewDate': FieldValue.serverTimestamp(),
      });
      
      // Sau khi log review, bạn có thể thêm logic cập nhật nextReviewDate 
      // cho Flashcard tại đây để hoàn thiện thuật toán Spaced Repetition.
    } catch (e) {
      throw Exception('Không thể lưu lịch sử ôn tập: $e');
    }
  }

  /// 3. Đếm số lượng thẻ cần ôn hôm nay (Cho Dashboard)
  Future<int> getDueCardsCount() async {
    if (_currentUserId == null) return 0;
    
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection('flashcards')
          .where('nextReviewDate', isLessThanOrEqualTo: now)
          .get();
          
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // lib/repositories/card_repository.dart
Future<List<DateTime>> getCompletedDates() async {
  if (_currentUserId == null) return [];
  try {
    // Lấy tất cả các bản ghi review của user này
    final snapshot = await _firestore
        .collection('flashcard_reviews')
        .where('userId', isEqualTo: _currentUserId)
        .get();

    // Chuyển đổi Timestamp thành DateTime và chỉ giữ lại Ngày/Tháng/Năm
    return snapshot.docs.map((doc) {
      DateTime date = (doc.data()['reviewDate'] as Timestamp).toDate();
      return DateTime(date.year, date.month, date.day);
    }).toSet().toList(); // toSet để xóa các thẻ trùng ngày học
  } catch (e) {
    return [];
  }
}
}