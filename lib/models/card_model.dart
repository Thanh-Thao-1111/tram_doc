// lib/models/card_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardData {
  final String id;
  final String question;
  final String answer;
  final String? noteId;
  final double easeFactor;
  final int reviewInterval;
  final DateTime nextReviewDate;

  FlashcardData({
    required this.id,
    required this.question,
    required this.answer,
    this.noteId,
    required this.easeFactor,
    required this.reviewInterval,
    required this.nextReviewDate,
  });

  // Chuyển từ Firestore Document sang Object
  factory FlashcardData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FlashcardData(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      noteId: data['noteId'],
      easeFactor: (data['easeFactor'] ?? 2.5).toDouble(),
      reviewInterval: data['reviewInterval'] ?? 1,
      nextReviewDate: (data['nextReviewDate'] as Timestamp).toDate(),
    );
  }
}