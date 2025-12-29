
import '../models/book_model.dart';

class HomeViewModel {
  /// Đang đọc
  final List<String> currentlyReadingCovers = [
    'https://upload.wikimedia.org/wikipedia/vi/9/9c/Nh%C3%A0_gi%E1%BA%A3_kim_%28s%C3%A1ch%29.jpg',
    'https://bizweb.dktcdn.net/100/418/570/products/1-0a8266fb-fa59-4322-82fc-3053ba5c25b4.jpg',
  ];

  /// 🔔 Tin mới từ vòng tròn (CHO BỪA ẢNH)
  final List<UpdateItem> circleUpdates = [
    UpdateItem(
      user: 'Ngọc Anh',
      action: 'vừa đọc xong',
      bookName: 'Đắc Nhân Tâm',
      time: '2 giờ trước',
      avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
      bookCoverUrl:
          'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
    ),
    UpdateItem(
      user: 'Minh Tuấn',
      action: 'đã thêm',
      bookName: 'Muôn Kiếp Nhân Sinh',
      time: 'Hôm qua',
      avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      bookCoverUrl:
          'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
    ),
  ];


  /// Gợi ý sách
  final List<BookModel> suggestedBooks = [
    BookModel(
      id: 'suggest_2',
      title: 'The Power of Habit',
      author: 'Charles Duhigg',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/71sBtM3Yi5L.jpg',
      pageCount: 371,
      publishedDate: '2012-02-28',
      categories: ['Self-Help', 'Psychology'],
      description: 'In The Power of Habit, award-winning business reporter Charles Duhigg takes us to the thrilling edge of scientific discoveries that explain why habits exist and how they can be changed. With penetrating intelligence and an ability to distill vast amounts of information into engrossing narratives, Duhigg brings to life a whole new understanding of human nature and its potential for transformation.',
    ),
    BookModel(
      id: 'suggest_1',
      title: 'Deep Work',
      author: 'Cal Newport',
      imageUrl:
          'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
      pageCount: 296,
      publishedDate: '2016-01-05',
      categories: ['Productivity', 'Self-Help'],
      description: 'One of the most valuable skills in our economy is becoming increasingly rare. If you master this skill, you\'ll achieve extraordinary results. Deep Work is an indispensable guide to anyone seeking focused success in a distracted world.',
    ),
  ];
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
