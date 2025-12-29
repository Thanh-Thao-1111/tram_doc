class CardModel {
  final String id;
  final String bookId;    // Thuộc về sách nào
  final String question;  // Mặt trước
  final String answer;    // Mặt sau

  CardModel({
    required this.id,
    required this.bookId,
    required this.question,
    required this.answer,
  });

  factory CardModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CardModel(
      id: id,
      bookId: data['bookId'] ?? '',
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
    );
  }
}