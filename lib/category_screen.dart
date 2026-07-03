import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'category_model.dart';
import 'subcategory_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    for (var item in categoryList) {
      print(item.categoryImage);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category List"),
      ),
      body: Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
  itemCount: categoryList.length,
  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 0.65,
  ),
  itemBuilder: (context, index) {
    final item = categoryList[index];

    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Image.network(
            item.categoryImage,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              print("FAILED URL = ${item.categoryImage}");
              print(error);
              return const Icon(Icons.broken_image);
            },
          )   
          ), 
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SubCategoryScreen(),
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