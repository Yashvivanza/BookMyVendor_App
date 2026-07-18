import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final oldPassController =
      TextEditingController();

  final newPassController =
      TextEditingController();

  final confirmPassController =
      TextEditingController();

  bool isLoading = false;

  Future<void> changePassword() async {
    if (oldPassController.text.isEmpty ||
        newPassController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill all fields"),
        ),
      );
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    String userId =
        prefs.getString("user_id") ?? "";

    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-change-password.php",
        ),
      );

      request.fields["user_id"] = userId;
      request.fields["opass"] =
          oldPassController.text;
      request.fields["npass"] =
          newPassController.text;
      request.fields["cpass"] =
          confirmPassController.text;

      var response = await request.send();

      var result =
          await response.stream.bytesToString();

      var data = jsonDecode(result);

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
        ),
      );

      if (data["flag"] == "1") {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Change Password", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: oldPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Old Password",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: confirmPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : changePassword,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Change Password",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}