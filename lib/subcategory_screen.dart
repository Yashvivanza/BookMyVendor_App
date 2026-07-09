import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/service_list.dart';
import 'package:http/http.dart' as http;
import 'subcategory_model.dart';
import 'app_drawer.dart';

class SubCategoryScreen extends StatefulWidget {
  final String? categoryId;

  const SubCategoryScreen({
    super.key,
    this.categoryId,
  });

  @override
  State<SubCategoryScreen> createState() =>
      _SubCategoryScreenState();
}

class _SubCategoryScreenState
    extends State<SubCategoryScreen> {
 List<SubCategoryModel> subCategoryList = [];

  bool isLoading = true;  
  
  @override
  void initState() {
    super.initState();
    getSubCategories();
  }

  Future<void> getSubCategories() async {
  try {
    String url;

    if (widget.categoryId == null) {
      url =
          'https://akashsir.in/atproject/atfinder-web/api/api-list-subcategory.php';
    } else {
      url =
          'https://akashsir.in/atproject/atfinder-web/api/api-list-subcategory.php?category_id=${widget.categoryId}';
    }

    final response = await http.post(
      Uri.parse(url),
    );

    debugPrint(response.body);

    final data = jsonDecode(response.body);

    if (data["flag"] == "1") {
      List list = data["sub_category_list"];

      setState(() {
        subCategoryList =
            list.map((e) => SubCategoryModel.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    debugPrint(e.toString());

    setState(() {
      isLoading = false;
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Categories"),
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
    
      body: isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: subCategoryList.length,
            itemBuilder: (context, index) {
              final item = subCategoryList[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [

                      Image.network(
                        item.subCategoryImage,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 80,
                          );
                        },
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              item.subCategoryName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              item.categoryName,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.blue,
                                  foregroundColor:
                                      Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ServiceListScreen(
                                            subCategoryId: item.subCategoryId,
                                          ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View Details",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        );
      }
    }