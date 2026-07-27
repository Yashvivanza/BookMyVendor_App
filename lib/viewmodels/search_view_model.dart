import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchViewModel extends ChangeNotifier {

  List<dynamic> allData = [];
  List<dynamic> filteredData = [];

  bool isLoading = false;
  bool isSearching = false;

  Future<void> fetchData() async {

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

        allData = data["category_list"];

      }

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;

    notifyListeners();
  }

  void search(String value) {

    if (value.trim().isEmpty) {

      isSearching = false;
      filteredData.clear();

      notifyListeners();

      return;
    }

    isSearching = true;

    filteredData = allData.where((item) {

      return item["category_name"]
          .toString()
          .toLowerCase()
          .contains(
            value.toLowerCase(),
          );

    }).toList();

    notifyListeners();
  }
}