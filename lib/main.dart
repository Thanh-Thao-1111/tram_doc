import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/homes/pages/welcome_page.dart';
import 'package:provider/provider.dart';

import 'viewmodels/library_viewmodel.dart';
import 'views/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryGreen = Color(0xFF3BA66B);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trạm Đọc',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.inter().fontFamily,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      /// MÀN HÌNH KHỞI ĐẦU
      home: WelcomeScreen(),
    );
  }
}
