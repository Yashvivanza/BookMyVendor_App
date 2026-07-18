import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressController;

  String? gender;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.name);

    emailController =
        TextEditingController(text: widget.email);

    mobileController =
        TextEditingController(text: widget.mobile);

    addressController =
        TextEditingController(text: widget.address);

    gender = (widget.gender.isNotEmpty) ? widget.gender : null;
  }

  Future<void> updateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

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
      request.fields["user_name"] =
          nameController.text.trim();

      request.fields["user_email"] =
          emailController.text.trim();

      request.fields["user_gender"] = gender ?? "";

      request.fields["user_address"] =
          addressController.text.trim();

      request.fields["user_mobile"] =
          mobileController.text.trim();

      var response = await request.send();

      var result =
          await response.stream.bytesToString();

      var data = jsonDecode(result);

      setState(() {
        isLoading = false;
      });

      if (data["flag"] == "1") {
        await prefs.setString(
          "user_name",
          nameController.text.trim(),
        );

        await prefs.setString(
          "user_email",
          emailController.text.trim(),
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(data["message"]),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(data["message"]),
            backgroundColor: Colors.red,
          ),
        );
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
        title: const Text("Edit Profile", style: TextStyle(
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
              controller: mobileController,
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

            DropdownButtonFormField<String>(
              value: gender,
              hint: const Text(
                "Select",
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: AppColors.bg,
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

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : updateProfile,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Update Profile",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}