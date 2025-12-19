import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/library_viewmodel.dart';
import 'views/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Khởi tạo LibraryViewModel để dùng chung
        ChangeNotifierProvider(create: (_) => LibraryViewModel()),
        
        // Khai báo thêm các ViewModel khác nếu cần
        // ChangeNotifierProvider(create: (_) => HomeViewModel()),
        // ChangeNotifierProvider(create: (_) => MainViewModel()),
      ],
      child: MaterialApp(
        title: 'Trạm Đọc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
      home: MainPage(),
      ),
    );
  }
}
