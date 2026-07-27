import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {

  bool isLoading = false;

  String message = "";

  Future<bool> login({

    required String email,
    required String password,

  }) async {

    if (email.isEmpty || password.isEmpty) {

      message = "Enter Email and Password";
      notifyListeners();

      return false;
    }

    try {

      isLoading = true;
      message = "";
      notifyListeners();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-login.php",
        ),
      );

      request.fields["user_email"] = email.trim();
      request.fields["user_password"] = password.trim();

      var response =
          await request.send();

      var result =
          await response.stream.bytesToString();

      var data =
          jsonDecode(result);
      print("LOGIN API RESPONSE:");
      print(data);
      isLoading = false;

      if (data["flag"] == "1") {

        final prefs =
            await SharedPreferences.getInstance();

        await prefs.setString(
          "user_id",
          data["user_id"].toString(),
        );

        await prefs.setString(
          "user_name",
          data["user_name"] ?? "",
        );

        await prefs.setString(
          "user_email",
          data["user_email"] ?? "",
        );
        await prefs.setString(
          "user_photo",
          data["user_photo"] ?? "",
        );
        await prefs.setString(
          "user_mobile",
          data["user_mobile"] ?? "",
        );

        notifyListeners();

        return true;
      }

      message = data["message"] ?? "";

      notifyListeners();

      return false;

    } catch (e) {

      isLoading = false;

      message = "Something went wrong";

      notifyListeners();

      return false;
    }
  }

  Future<bool> signup({

    required String name,
    required String email,
    required String password,
    required String mobile,
    required String address,
    required String gender,

  }) async {

    try {

      isLoading = true;
      message = "";
      notifyListeners();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-signup.php",
        ),
      );

      request.fields["user_name"] = name;
      request.fields["user_email"] = email;
      request.fields["user_password"] = password;
      request.fields["user_mobile"] = mobile;
      request.fields["user_address"] = address;
      request.fields["user_gender"] = gender;

      var response =
          await request.send();

      var result =
          await response.stream.bytesToString();

      var data =
          jsonDecode(result);

      isLoading = false;

      message = data["message"] ?? "";

      notifyListeners();

      return data["flag"] == "1";

    } catch (e) {

      isLoading = false;

      message = "Something went wrong";

      notifyListeners();

      return false;
    }
  }
}