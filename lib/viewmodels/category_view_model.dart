import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_88/models/category_model.dart';

class CategoryViewModel extends ChangeNotifier {

  List<CategoryModel> categories = [];

  bool isLoading = false;

  Future<void> loadCategories() async {

    isLoading = true;
    notifyListeners();

    try {

      final response = await http.get(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-category.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {

        categories =
            (data["category_list"] as List)
                .map(
                  (e) => CategoryModel.fromJson(e),
                )
                .toList();
      }

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;
    notifyListeners();
  }
  Future<List<dynamic>> getCategories() async {
  try {
    final response = await http.get(
      Uri.parse(
        'https://akashsir.in/atproject/atfinder-web/api/api-list-category.php',
      ),
    );

    final data = jsonDecode(response.body);

    if (data["flag"] == "1") {
      return data["category_list"];
    }

    return [];
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
}