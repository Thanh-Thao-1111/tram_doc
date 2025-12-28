class BookModel {
  final String title;
  final String author;
  final String imageUrl;

  BookModel({
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}

class UpdateItem {
  final String user;
  final String action;
  final String bookName;
  final String time;
  final String avatarUrl;
  final String bookCoverUrl;

  UpdateItem({
    required this.user,
    required this.action,
    required this.bookName,
    required this.time,
    required this.avatarUrl,
    required this.bookCoverUrl,
  });
}
