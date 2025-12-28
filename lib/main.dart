import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'views/homes/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'views/library/library_page.dart';
import 'viewmodels/library_viewmodel.dart';
import 'views/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAgX559qQVlKV3FbkpLWAzJ1qxkjCaxSog",
        authDomain: "tram-23cb8.firebaseapp.com",
        projectId: "tram-23cb8",
        storageBucket: "tram-23cb8.firebasestorage.app",
        messagingSenderId: "57032892820",
        appId: "1:57032892820:web:d28709088a21831176af81",
        measurementId: "G-7KKJTQ4NR8"
      ),
    );
  } else {
    // Nếu chạy Android/iOS thì nó tự đọc file google-services.json
    await Firebase.initializeApp();
  }
  runApp(
    MultiProvider( 
      providers: [
        ChangeNotifierProvider(create: (_) => LibraryViewModel()),
      ],
      child: const MyApp(),
    ),
  );
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
