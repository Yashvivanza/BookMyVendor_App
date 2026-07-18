import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'core/constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<dynamic> allData = [];
  List<dynamic> filteredData = [];

  bool isLoading = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-category.php',
        ),
      );

      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {
        setState(() {
          allData = data["category_list"];
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  void search(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        isSearching = false;
        filteredData.clear();
      });
      return;
    }

    setState(() {
      isSearching = true;

      filteredData = allData.where((item) {
        return item["category_name"]
            .toString()
            .toLowerCase()
            .contains(
              value.toLowerCase(),
            );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Find Services",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchController,
                onChanged: search,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      "Search Category...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Expanded(
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )

            else if (!isSearching)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 80,
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Search Vendors or Services",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            else if (filteredData.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No Results Found",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              )

            else
              Expanded(
                child: GridView.builder(
                  itemCount:
                      filteredData.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.80,
                  ),

                  itemBuilder:
                      (context, index) {

                    final item =
                        filteredData[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: Column(
                        children: [

                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                top: Radius.circular(
                                  15,
                                ),
                              ),
                              child: Image.network(
                                item[
                                    "category_image"],
                                width:
                                    double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.all(
                              10,
                            ),
                            child: Text(
                              item[
                                  "category_name"],
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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