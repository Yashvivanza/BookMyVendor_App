import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? gender;
  bool isLoading = false;

  String message = "";
  Color messageColor = Colors.green;

  Future<void> signupUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty) {
      setState(() {
        message = "Please fill all fields";
        messageColor = Colors.red;
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-signup.php',
        ),
      );

      request.fields['user_name'] = nameController.text.trim();
      request.fields['user_email'] = emailController.text.trim();
      request.fields['user_password'] = passwordController.text.trim();
      request.fields['user_gender'] = gender!;
      request.fields['user_mobile'] = mobileController.text.trim();
      request.fields['user_address'] = addressController.text.trim();

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      var data = jsonDecode(responseData);

      setState(() {
        isLoading = false;
        message = data["message"];
        messageColor = data["flag"] == "1" ? Colors.green : Colors.red;
      });

      if (data["flag"] == "1") {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            "user_name", nameController.text.trim());
        await prefs.setString(
            "user_email", emailController.text.trim());

        if (!mounted) return;

        Future.delayed(
          const Duration(seconds: 1),
          () {
            if (!mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Something went wrong";
        messageColor = Colors.red;
      });
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
        title: const Text("Sign Up", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
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
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
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
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
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

            DropdownButtonFormField<String>(
              dropdownColor: AppColors.bg,
              initialValue: gender,
              hint: const Text(
                "Select",
                style: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
              iconEnabledColor: Colors.white,
              decoration: const InputDecoration(
                labelText: "Gender",
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
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile",
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
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Address",
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
                onPressed: isLoading ? null : signupUser,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Register"),
              ),
            ),

            const SizedBox(height: 15),

            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: messageColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}