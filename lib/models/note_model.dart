import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String content;
  final int pageNumber;
  final DateTime date;

  NoteModel({
    required this.id,
    required this.content,
    required this.pageNumber,
    required this.date,
  });

  // Từ Firebase về App
  factory NoteModel.fromFirestore(Map<String, dynamic> data, String id) {
    DateTime noteDate = DateTime.now();
    if (data['date'] != null && data['date'] is Timestamp) {
      noteDate = (data['date'] as Timestamp).toDate();
    }
    
    return NoteModel(
      id: id,
      content: data['content'] ?? '',
      pageNumber: data['page'] ?? 0,
      date: noteDate,
    );
  }
}