import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/category_view_model.dart';

class HomeViewModel extends ChangeNotifier {

  final CategoryViewModel categoryVM =
      CategoryViewModel();

  String name = "";
  String email = "";
  String photo = "";

  List<dynamic> banners = [];

  bool isLoading = false;
  int notificationCount = 0;
  Future<void> loadUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    name =
        prefs.getString("user_name") ?? "";

    email =
        prefs.getString("user_email") ?? "";

    photo =
        prefs.getString("user_photo") ?? "";

    notifyListeners();
  }

  Future<void> fetchBanners() async {

    isLoading = true;
    notifyListeners();

    banners =
        await categoryVM.getCategories();

    isLoading = false;

    notifyListeners();
  }

  Future<void> loadHomeData() async {

    await loadUser();
    await loadNotificationCount();
    await fetchBanners();

  }
  Future<void> loadNotificationCount() async {

  final prefs =
      await SharedPreferences.getInstance();

  notificationCount =
      prefs.getInt(
        "notification_count",
      ) ??
      0;

  notifyListeners();
}
}