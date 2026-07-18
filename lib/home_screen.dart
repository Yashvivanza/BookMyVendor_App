import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/quick_booking_screen.dart';
import 'package:flutter_application_88/search_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'app_drawer.dart';
import 'core/constants/app_colors.dart';
import 'package:flutter_application_88/viewmodels/category_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryViewModel categoryVM =
  CategoryViewModel();
  String name = "";
  String email = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    loadUser();
    fetchBanners();
  }


  Widget _quickAction(
  IconData icon,
  String title,
  VoidCallback onTap,
  ) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 95,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

  List<dynamic> banners = [];
  Future<void> loadUser() async {
    final prefs =
        await SharedPreferences.getInstance();

    print("PHOTO IN HOME = ${prefs.getString("user_photo")}");

    setState(() {
      name =
          prefs.getString("user_name") ?? "";

      email =
          prefs.getString("user_email") ?? "";

      photo =
          prefs.getString("user_photo") ?? "";
    });
    print("Home Photo URL = $photo");
  } 

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
  Future<void> fetchBanners() async {

    final categories =
        await categoryVM.getCategories();

    setState(() {
      banners = categories;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor:AppColors.bg,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text("Home",
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
    ),),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        photo.isNotEmpty
                            ? NetworkImage(photo)
                            : null,
                    child: photo.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $name 👋",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          "Ahmedabad, Gujarat",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
              
              

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Quick Actions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  Expanded(
                    child: _quickAction(
                      Icons.search,
                      "Find",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _quickAction(
                      Icons.calendar_month,
                      "Book",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const QuickBookingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quickAction(
                      Icons.star,
                      "Top Rated",
                      () {
                        
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _quickAction(
                      Icons.person,
                      "Profile",
                      () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const SizedBox(height: 15),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Popular Categories",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          color: AppColors.card,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    banners[index]["category_image"],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(8.0),
                                child: Text(
                                  banners[index]["category_name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}