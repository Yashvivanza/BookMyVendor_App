import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'category_model.dart';
import 'subcategory_screen.dart';
import 'app_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryModel> categoryList = [];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-category.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {
        List list = data["category_list"];

        setState(() {
          categoryList =
              list.map((e) => CategoryModel.fromJson(e)).toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: categoryList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
      itemBuilder: (context, index) {
        final item = categoryList[index];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Image.network(
              item.categoryImage,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                debugPrint("FAILED URL = ${item.categoryImage}");
                debugPrint(error.toString());
                return const Icon(Icons.broken_image);
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubCategoryScreen(
                            categoryId: item.categoryId.toString(),
                          ),
                        ),

                      );
                    },
                    child: const Text(
                      "View Subcategory",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
  ),
  
      ),
    );
  } 
}
