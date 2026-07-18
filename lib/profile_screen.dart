import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  bool isLoading = true;

  File? selectImage;

  String name = "";
  String email = "";
  String mobile = "";
  String gender = "";
  String address = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
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
        String userPhoto =
            data["user_photo"] ?? "";

        await prefs.setString(
          "user_photo",
          userPhoto,
        );

        if (!mounted) return;

        setState(() {
          name = data["user_name"] ?? "";
          email = data["user_email"] ?? "";
          mobile = data["user_mobile"] ?? "";
          gender = data["user_gender"] ?? "";
          address = data["user_address"] ?? "";
          photo = userPhoto;
          isLoading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "Profile not found",
            ),
          ),
        );
      }
    } catch (e) {
      print(e);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      selectImage = File(image.path);

      setState(() {});

      uploadImage();
    }
  }
 Future<void> uploadImage() async {
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
        selectImage!.path,
      ),
    );

    var response = await request.send();

    var result =
        await response.stream.bytesToString();

    var data = jsonDecode(result);

    if (data["flag"] == "1") {
      await getProfile();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data["message"] ?? "",
        ),
      ),
    );
  } catch (e) {
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
        title: const Text("My Profile", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,),
      )),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: selectImage != null
                                ? FileImage(selectImage!)
                                : NetworkImage(photo) as ImageProvider,
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: AppColors.bg,
                      ),
                        title: const Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(email),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: AppColors.bg,
                      ),
                        title: const Text(
                          "Mobile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(mobile),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: AppColors.bg,
                      ),
                        title: const Text(
                          "Gender",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(gender),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: AppColors.bg,
                      ),
                        title: const Text(
                          "Address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(address),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.bg,
                      ),
                      label: const Text("Edit Profile"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              name: name,
                              email: email,
                              mobile: mobile,
                              gender: gender,
                              address: address,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}