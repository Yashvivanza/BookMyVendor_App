import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/service_list.dart';
import 'package:http/http.dart' as http;
import 'subcategory_model.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

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
    final response = await http.post(
      Uri.parse(
        'https://akashsir.in/atproject/atfinder-web/api/api-list-subcategory.php',
      ),
    );

    final data = jsonDecode(response.body);

    if (data["flag"] == "1") {
      List list = data["sub_category_list"];

      setState(() {
        subCategoryList = list
            .map((e) => SubCategoryModel.fromJson(e))
            .toList();

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
    ),
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: subCategoryList.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final item = subCategoryList[index];

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          item.subCategoryImage,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 60,
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              item.subCategoryName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              item.categoryName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              height: 38,
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
                                          const ServiceListScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View Details",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }