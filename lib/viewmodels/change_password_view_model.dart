import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class ChangePasswordViewModel extends ChangeNotifier {

  bool isLoading = false;

  Future<String> changePassword({

    required String oldPassword,
    required String newPassword,
    required String confirmPassword,

  }) async {

    if (oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {

      return "Fill all fields";
    }

    try {

      isLoading = true;
      notifyListeners();

      final prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-change-password.php",
        ),
      );

      request.fields["user_id"] = userId;
      request.fields["opass"] = oldPassword;
      request.fields["npass"] = newPassword;
      request.fields["cpass"] = confirmPassword;

      var response =
          await request.send();

      var result =
          await response.stream.bytesToString();

      var data =
      jsonDecode(result);

      if (data["flag"] == "1") {

        await NotificationService.addNotification(
          title: "🔒 Password Changed",
          message: "Your account password was updated.",
        );
      }

isLoading = false;
notifyListeners();

return data["message"] ?? "Unknown Error";

    } catch (e) {

      isLoading = false;
      notifyListeners();

      return e.toString();
    }
  }
}