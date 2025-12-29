class ReviewModel {
  final String id;
  final String userName;
  final int rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ReviewModel(
      id: id,
      userName: data['userName'] ?? 'Ẩn danh',
      rating: data['rating'] ?? 5,
      comment: data['comment'] ?? '',
    );
  }
}