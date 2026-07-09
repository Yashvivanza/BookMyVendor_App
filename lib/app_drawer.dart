import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import 'subcategory_screen.dart';
import 'service_list.dart';
import 'booking_list_screen.dart';
import 'favourite_screen.dart';
import 'ratings_list_screen.dart';

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

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      name =
          prefs.getString("user_name") ??
              "";

      email =
          prefs.getString("user_email") ??
              "";
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(
            accountName: Text(
              name.isEmpty
                  ? "Guest User"
                  : name,
            ),
            accountEmail: Text(
              email.isEmpty
                  ? "guest@gmail.com"
                  : email,
            ),
            currentAccountPicture:
                const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
          ),

          ListTile(
            leading:
                const Icon(Icons.home),
            title: const Text("Home"),
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
            title:
                const Text("Categories"),
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
            title: const Text(
                "Sub Categories"),
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
            title:
                const Text("Services"),
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
                Icons.book_online),
            title: const Text(
                "My Bookings"),
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
            title:
                const Text("Favourites"),
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

      

          const Divider(),

          ListTile(
            leading:
                const Icon(Icons.logout),
            title:
                const Text("Logout"),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}