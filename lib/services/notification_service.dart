import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {

  static Future<void> addNotification({
    required String title,
    required String message,
  }) async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> notifications =
        prefs.getStringList("notifications") ?? [];

    notifications.insert(
      0,
      jsonEncode({
        "title": title,
        "message": message,
        "time": DateTime.now().toString(),
      }),
    );

    await prefs.setStringList(
      "notifications",
      notifications,
    );

    final count =
        prefs.getInt("notification_count") ?? 0;

    await prefs.setInt(
      "notification_count",
      count + 1,
    );
  }
}