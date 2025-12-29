import 'package:cloud_firestore/cloud_firestore.dart';

/// Reading status enum
enum ReadingStatus {
  wantToRead,  // Muốn đọc
  reading,     // Đang đọc
  completed,   // Đã đọc
}

class BookModel {
  final String? id;
  final String? isbn;
  final String title;
  final String author;
  final String? description;
  final String imageUrl;
  final int? pageCount;
  final String? publishedDate;
  final List<String>? categories;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int currentPage;
  final ReadingStatus readingStatus;
  // Location fields
  final String? shelfLocation;
  final String? shelfType;
  final String? shelfNumber;

  BookModel({
    this.id,
    this.isbn,
    required this.title,
    required this.author,
    this.description,
    required this.imageUrl,
    this.pageCount,
    this.publishedDate,
    this.categories,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.currentPage = 0,
    this.readingStatus = ReadingStatus.wantToRead,
    this.shelfLocation,
    this.shelfType,
    this.shelfNumber,
  });

  /// Create from Firestore document
  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookModel(
      id: doc.id,
      isbn: data['isbn'],
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'] ?? '',
      pageCount: data['pageCount'],
      publishedDate: data['publishedDate'],
      categories: data['categories'] != null
          ? List<String>.from(data['categories'])
          : null,
      userId: data['userId'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      currentPage: data['currentPage'] ?? 0,
      readingStatus: _parseReadingStatus(data['readingStatus']),
      shelfLocation: data['shelfLocation'],
      shelfType: data['shelfType'],
      shelfNumber: data['shelfNumber'],
    );
  }

  static ReadingStatus _parseReadingStatus(String? status) {
    switch (status) {
      case 'reading':
        return ReadingStatus.reading;
      case 'completed':
        return ReadingStatus.completed;
      default:
        return ReadingStatus.wantToRead;
    }
  }

  static String _statusToString(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.reading:
        return 'reading';
      case ReadingStatus.completed:
        return 'completed';
      default:
        return 'wantToRead';
    }
  }

  /// Create from Google Books API response
  factory BookModel.fromGoogleBooks(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final industryIds = volumeInfo['industryIdentifiers'] as List? ?? [];

    String? isbn;
    for (var id in industryIds) {
      if (id['type'] == 'ISBN_13' || id['type'] == 'ISBN_10') {
        isbn = id['identifier'];
        break;
      }
    }

    return BookModel(
      isbn: isbn,
      title: volumeInfo['title'] ?? 'Unknown Title',
      author: (volumeInfo['authors'] as List?)?.join(', ') ?? 'Unknown Author',
      description: volumeInfo['description'],
      imageUrl: imageLinks['thumbnail']?.replaceAll('http:', 'https:') ?? '',
      pageCount: volumeInfo['pageCount'],
      publishedDate: volumeInfo['publishedDate'],
      categories: volumeInfo['categories'] != null
          ? List<String>.from(volumeInfo['categories'])
          : null,
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      if (isbn != null) 'isbn': isbn,
      'title': title,
      'author': author,
      if (description != null) 'description': description,
      'imageUrl': imageUrl,
      if (pageCount != null) 'pageCount': pageCount,
      if (publishedDate != null) 'publishedDate': publishedDate,
      if (categories != null) 'categories': categories,
      if (userId != null) 'userId': userId,
      'currentPage': currentPage,
      'readingStatus': _statusToString(readingStatus),
      if (shelfLocation != null) 'shelfLocation': shelfLocation,
      if (shelfType != null) 'shelfType': shelfType,
      if (shelfNumber != null) 'shelfNumber': shelfNumber,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Create a copy with updated fields
  BookModel copyWith({
    String? id,
    String? isbn,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    int? pageCount,
    String? publishedDate,
    List<String>? categories,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentPage,
    ReadingStatus? readingStatus,
    String? shelfLocation,
    String? shelfType,
    String? shelfNumber,
  }) {
    return BookModel(
      id: id ?? this.id,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      pageCount: pageCount ?? this.pageCount,
      publishedDate: publishedDate ?? this.publishedDate,
      categories: categories ?? this.categories,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentPage: currentPage ?? this.currentPage,
      readingStatus: readingStatus ?? this.readingStatus,
      shelfLocation: shelfLocation ?? this.shelfLocation,
      shelfType: shelfType ?? this.shelfType,
      shelfNumber: shelfNumber ?? this.shelfNumber,
    );
  }
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
