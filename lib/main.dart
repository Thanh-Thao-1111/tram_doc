import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'views/main_page.dart';
import 'views/stats_page.dart';
import 'views/notification_settings_page.dart';
import 'views/account_page.dart';
import 'views/appearance_page.dart';
import 'views/edit_profile_page.dart';
import 'views/help_support_page.dart';

void main() {
  runApp(const TramDocApp());
}

class TramDocApp extends StatelessWidget {
  const TramDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (_) => const MainPage(),
        StatsPage.route: (_) => const StatsPage(),
        NotificationSettingsPage.route: (_) => const NotificationSettingsPage(),
        AccountPage.route: (_) => const AccountPage(),
        AppearancePage.route: (_) => const AppearancePage(),
        EditProfilePage.route: (_) => const EditProfilePage(),
        HelpSupportPage.route: (_) => const HelpSupportPage(),
      },
    );
  }
}
