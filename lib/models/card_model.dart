import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final String id;
  final String userId;
  final String bookId; // Quan trọng: Để lọc thẻ theo sách
  final String front;  // Mặt trước (thay cho question)
  final String back;   // Mặt sau (thay cho answer)
  
  // Các trường cho thuật toán Spaced Repetition (SM-2)
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime? nextReview;

  CardModel({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.front,
    required this.back,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    this.nextReview,
  });

  // Chuyển từ Firestore Document sang Object
  factory CardModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CardModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      bookId: data['bookId'] ?? '',
      
      // Hỗ trợ cả tên cũ (question) và tên mới (front) để không bị lỗi dữ liệu cũ
      front: data['front'] ?? data['question'] ?? '',
      back: data['back'] ?? data['answer'] ?? '',
      
      easeFactor: (data['easeFactor'] ?? 2.5).toDouble(),
      interval: data['interval'] ?? 0,
      repetitions: data['repetitions'] ?? 0,
      
      // Chuyển đổi Timestamp an toàn
      nextReview: data['nextReviewDate'] != null 
          ? (data['nextReviewDate'] as Timestamp).toDate() 
          : null,
    );
  }
}