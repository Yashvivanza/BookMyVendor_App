import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {

  bool isLoading = false;

  File? selectedImage;

  String name = "";
  String email = "";
  String mobile = "";
  String gender = "";
  String address = "";
  String photo = "";

  Future<void> getProfile() async {

    isLoading = true;
    notifyListeners();

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-user-profile.php",
        ),
      );

      request.fields["user_id"] = userId;

      var response = await request.send();

      var result =
          await response.stream.bytesToString();

      var data = jsonDecode(result);

      if (data["flag"] == "1") {

        photo =
            data["user_photo"] ?? "";

        name =
            data["user_name"] ?? "";

        email =
            data["user_email"] ?? "";

        mobile =
            data["user_mobile"] ?? "";

        gender =
            data["user_gender"] ?? "";

        address =
            data["user_address"] ?? "";

        await prefs.setString(
          "user_photo",
          photo,
        );
      }

    } catch (e) {

      debugPrint(e.toString());

    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> pickImage() async {

    final picker = ImagePicker();

    final image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    selectedImage =
        File(image.path);

    notifyListeners();

    await uploadImage();
  }

  Future<void> uploadImage() async {

    if (selectedImage == null) return;

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String userId =
          prefs.getString("user_id") ?? "";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-user-photo-change.php",
        ),
      );

      request.fields["user_id"] = userId;

      request.files.add(
        await http.MultipartFile.fromPath(
          "user_photo",
          selectedImage!.path,
        ),
      );

      await request.send();

      await getProfile();

    } catch (e) {

      debugPrint(e.toString());

    }
  }

  Future<bool> updateProfile({

    required String name,
    required String email,
    required String mobile,
    required String gender,
    required String address,

  }) async {

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
          "https://akashsir.in/atproject/atfinder-web/api/api-user-update.php",
        ),
      );

      request.fields["user_id"] = userId;
      request.fields["user_name"] = name;
      request.fields["user_email"] = email;
      request.fields["user_mobile"] = mobile;
      request.fields["user_gender"] = gender;
      request.fields["user_address"] = address;

      var response =
          await request.send();

      var result =
          await response.stream.bytesToString();

      var data =
          jsonDecode(result);

      isLoading = false;
      notifyListeners();

      if (data["flag"] == "1") {

        await prefs.setString(
          "user_name",
          name,
        );

        await prefs.setString(
          "user_email",
          email,
        );

        return true;
      }

      return false;

    } catch (e) {

      isLoading = false;
      notifyListeners();

      return false;
    }
  }
}