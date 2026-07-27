import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/views/feedback_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'subcategory_screen.dart';
import 'service_list.dart';
import 'booking_list_screen.dart';
import 'favourite_screen.dart';
import 'change_password_screen.dart';
import 'profile_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() =>
      _AppDrawerState();
}

class _AppDrawerState
    extends State<AppDrawer> {
  String name = "";
  String email = "";
  String photo = "";
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

 Future<void> loadUserData() async {
  final prefs =
      await SharedPreferences.getInstance();
  print("user_name = ${prefs.getString("user_name")}");
  print("user_email = ${prefs.getString("user_email")}");
  print("user_photo = ${prefs.getString("user_photo")}");
  setState(() {
    name =
        prefs.getString("user_name") ?? "";

    email =
        prefs.getString("user_email") ?? "";

    photo =
        prefs.getString("user_photo") ?? "";
  });
}

  Future<void> logout() async {
      
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: AppColors.bg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
         UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.card,
            ),
            accountName: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  photo.isNotEmpty
                      ? NetworkImage(photo)
                      : null,
              child: photo.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.home),
            iconColor: Colors.white,
            title: const Text("Home"),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HomeScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading:
                const Icon(Icons.category),
            iconColor: Colors.white,
            title:
                const Text("Categories"),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CategoryScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading:
                const Icon(Icons.folder),
            iconColor: Colors.white,
            title: const Text(
                "Sub Categories"),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SubCategoryScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(
                Icons.design_services),
            iconColor: Colors.white,
            title:
                const Text("Services"),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ServiceListScreen(
                    subCategoryId: "",
                  ),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(
                Icons.calendar_month),
            iconColor: Colors.white,
            title: const Text(
                "My Bookings"),
             textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const BookingListScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading:
                const Icon(Icons.favorite),
            iconColor: Colors.white,
            title:
                const Text("Favourites"),
             textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FavouriteScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.feedback,
              color: Colors.white,
            ),
            title: const Text(
              "Feedbacks",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FeedbackListScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            iconColor: Colors.white,
            title: const Text("Change Password"),
             textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ChangePasswordScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            iconColor: Colors.white,
            title: const Text("Profile"),
           textColor: Colors.white,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.logout),
            iconColor: Colors.red,
            title:
                const Text("Logout"),
             textColor: Colors.red,
            onTap: logout,
          ),
        ],
      ),
    );
  }
}