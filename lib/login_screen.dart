import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/views/booking_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? serviceId;
  final String? serviceName;

  const LoginScreen({
    super.key,
    this.serviceId,
    this.serviceName,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  String message = "";

  Future<void> loginUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        message = "Enter Email and Password";
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-login.php",
        ),
      );

      request.fields["user_email"] =
          emailController.text.trim();

      request.fields["user_password"] =
          passwordController.text.trim();

      var response =
          await request.send();

      var responseData =
          await response.stream.bytesToString();

      var data =
          jsonDecode(responseData);

      setState(() {
        isLoading = false;
      });

      if (data["flag"] == "1") {
        final prefs =
            await SharedPreferences
                .getInstance();

        prefs.setString(
          "user_id",
          data["user_id"]
              .toString(),
        );

        prefs.setString(
          "user_name",
          data["user_name"] ??
              "",
        );

        prefs.setString(
          "user_email",
          data["user_email"] ??
              emailController.text,
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Login Successful",
            ),
          ),
        );

        // If user came from Book Now
        if (widget.serviceId != null &&
            widget.serviceName != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BookingScreen(
                userId:
                    data["user_id"]
                        .toString(),
                serviceMasterId:
                    widget.serviceId!,
                serviceName:
                    widget.serviceName!,
              ),
            ),
          );
        } else {
          // Normal Login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const HomeScreen(),
            ),
          );
        }
      } else {
        setState(() {
          message =
              data["message"];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message =
            "Something went wrong";
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
        title:
            const Text("Login", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,),
      )),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                20),
        child: Column(
          children: [

            const SizedBox(
                height: 20),

            TextField(
              style: const TextStyle(color: Colors.white),
              controller:
                  emailController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Email",
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

            const SizedBox(
                height: 15),

            TextField(
              style: const TextStyle(color: Colors.white),
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Password",
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

            const SizedBox(
                height: 20),

            if (message
                .isNotEmpty)
              Text(
                message,
                style:
                    const TextStyle(
                  color:
                      Colors.red,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),

            const SizedBox(
                height: 20),

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : loginUser,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Login",
                      ),
              ),
            ),

            const SizedBox(
                height: 15),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SignupScreen(),
                  ),
                );
              },
              child: const Text(
                "Don't have an account? Register",
              ),
            ),
          ],
        ),
      ),
    );
  }
}