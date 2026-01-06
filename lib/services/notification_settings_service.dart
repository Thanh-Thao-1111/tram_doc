import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service quản lý cài đặt thông báo
/// Lưu trữ và đọc cài đặt từ SharedPreferences
/// Sử dụng Singleton pattern để đảm bảo chỉ có 1 instance
class NotificationSettingsService {
  // Singleton instance
  static final NotificationSettingsService _instance = NotificationSettingsService._internal();
  factory NotificationSettingsService() => _instance;
  NotificationSettingsService._internal();

  static const String _keyPush = 'notification_push';
  static const String _keyRemind = 'notification_remind';
  static const String _keyAchievement = 'notification_achievement';
  static const String _keyCommunity = 'notification_community';
  static const String _keyComment = 'notification_comment';

  SharedPreferences? _prefs;

  /// Khởi tạo SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Đảm bảo prefs đã được khởi tạo
  Future<SharedPreferences> get _preferences async {
    await init();
    return _prefs!;
  }

  // === GETTERS ===

  /// Thông báo đẩy - Nhận thông báo trên thiết bị
  Future<bool> get isPushEnabled async {
    final prefs = await _preferences;
    return prefs.getBool(_keyPush) ?? true;
  }

  /// Nhắc nhở đọc sách - Nhắc bạn đọc mỗi ngày
  Future<bool> get isRemindEnabled async {
    final prefs = await _preferences;
    return prefs.getBool(_keyRemind) ?? true;
  }

  /// Thành tích mới - Khi bạn đạt thành tích
  Future<bool> get isAchievementEnabled async {
    final prefs = await _preferences;
    return prefs.getBool(_keyAchievement) ?? true;
  }

  /// Hoạt động cộng đồng - Cập nhật từ cộng đồng
  Future<bool> get isCommunityEnabled async {
    final prefs = await _preferences;
    return prefs.getBool(_keyCommunity) ?? true;
  }

  /// Bình luận và thảo luận - Khi có người phản hồi
  Future<bool> get isCommentEnabled async {
    final prefs = await _preferences;
    return prefs.getBool(_keyComment) ?? true;
  }

  // === SETTERS ===

  Future<void> setPushEnabled(bool value) async {
    debugPrint('Saving push = $value');
    final prefs = await _preferences;
    await prefs.setBool(_keyPush, value);
    debugPrint('Saved push = $value');
  }

  Future<void> setRemindEnabled(bool value) async {
    debugPrint('Saving remind = $value');
    final prefs = await _preferences;
    await prefs.setBool(_keyRemind, value);
    debugPrint('Saved remind = $value');
  }

  Future<void> setAchievementEnabled(bool value) async {
    debugPrint('Saving achievement = $value');
    final prefs = await _preferences;
    await prefs.setBool(_keyAchievement, value);
    debugPrint('Saved achievement = $value');
  }

  Future<void> setCommunityEnabled(bool value) async {
    debugPrint('Saving community = $value');
    final prefs = await _preferences;
    await prefs.setBool(_keyCommunity, value);
    debugPrint('Saved community = $value');
  }

  Future<void> setCommentEnabled(bool value) async {
    debugPrint('Saving comment = $value');
    final prefs = await _preferences;
    await prefs.setBool(_keyComment, value);
    debugPrint('Saved comment = $value');
  }

  // === BULK LOAD ===

  /// Load tất cả settings cùng lúc
  Future<Map<String, bool>> loadAllSettings() async {
    final prefs = await _preferences;
    return {
      'push': prefs.getBool(_keyPush) ?? true,
      'remind': prefs.getBool(_keyRemind) ?? true,
      'achievement': prefs.getBool(_keyAchievement) ?? true,
      'community': prefs.getBool(_keyCommunity) ?? true,
      'comment': prefs.getBool(_keyComment) ?? true,
    };
  }
}
