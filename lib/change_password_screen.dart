import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'viewmodels/change_password_view_model.dart';

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


  @override
  Widget build(BuildContext context) {
     final passwordVM =
      Provider.of<ChangePasswordViewModel>(
    context,
  );
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
              onPressed: passwordVM.isLoading
                  ? null
                  : () async {

                      String message =
                          await passwordVM.changePassword(
                        oldPassword:
                            oldPassController.text.trim(),
                        newPassword:
                            newPassController.text.trim(),
                        confirmPassword:
                            confirmPassController.text.trim(),
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );

                      if (message
                          .toLowerCase()
                          .contains("success")) {
                        Navigator.pop(context);
                      }
                    },
              child: passwordVM.isLoading
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