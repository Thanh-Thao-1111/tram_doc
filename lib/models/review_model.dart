import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ReviewModel(
      id: id,
      userName: data['userName'] ?? 'Ẩn danh',
      rating: data['rating'] ?? 5,
      comment: data['comment'] ?? '',
      date: data['date'] != null 
          ? (data['date'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}