import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
class RatingViewModel extends ChangeNotifier{
  List ratings = [];

  bool isLoading = false;

  Future<void> loadRatings(String productId) async {
    try {
      SharedPreferences prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-list-rating.php",
        ),
      );

      request.fields["user_id"] = userId;
      request.fields["product_id"] = productId;

      var response = await request.send();

      var result =
          await response.stream.bytesToString();

      var data = jsonDecode(result);

      if (data["flag"] == "1") {
        ratings = data["rate_list"] ?? [];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> submitRating({
    required String productId,
    required int rating,
    required String name,
    required String review,
  }) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("user_id") ?? "";

    if (userId.isEmpty) {
      return "Please login first";
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "https://akashsir.in/atproject/atfinder-web/api/api-add-rating.php",
      ),
    );

    request.fields["user_id"] = userId;
    request.fields["product_id"] = productId;
    request.fields["rating_number"] =
        rating.toString();
    request.fields["rating_name"] = name;
    request.fields["rating_message"] = review;

    var response = await request.send();

    var result =
        await response.stream.bytesToString();

    var data = jsonDecode(result);

    return data["message"];
  }
}