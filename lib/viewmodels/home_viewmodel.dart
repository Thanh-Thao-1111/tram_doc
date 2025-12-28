
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
          'https://upload.wikimedia.org/wikipedia/vi/6/6f/%C4%90%E1%BA%AFc_Nh%C3%A2n_T%C3%A2m.jpg',
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
      title: 'The Power of Habit',
      author: 'Charles Duhigg',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/71sBtM3Yi5L.jpg',
    ),
    BookModel(
      title: 'Deep Work',
      author: 'Cal Newport',
      imageUrl:
          'https://bizweb.dktcdn.net/100/370/339/products/khong-gia-dinh.jpg',
    ),
  ];
}
