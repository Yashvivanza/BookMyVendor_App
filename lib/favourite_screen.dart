import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List favouriteServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      List<String> favouriteIds =
          prefs.getStringList("favourites") ?? [];

      final response = await http.post(
        Uri.parse(
          "https://akashsir.in/atproject/atfinder-web/api/api-list-service.php",
        ),
      );
      
      final data = jsonDecode(response.body);

      if (data["flag"] == "1") {
        List services = data["service_list"];

        favouriteServices = services.where((item) {
          return favouriteIds.contains(
            item["service_master_id"].toString(),
          );
        }).toList();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Future<void> removeFavourite(String serviceName) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> favourites =
      prefs.getStringList("favourites") ?? [];

  favourites.remove(serviceName);

  await prefs.setStringList(
    "favourites",
    favourites,
  );

  setState(() {
    favouriteServices.removeWhere(
      (item) =>
          item["service_master_id"].toString() ==
          serviceName,
    );
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Removed from favourites"),
    ),
  );
}

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });

    await loadFavourites();
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
        title: const Text("My Favourites", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,),
      )),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : favouriteServices.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No favourites added",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: refreshData,
                  child: ListView.builder(
                    itemCount:
                        favouriteServices.length,
                    itemBuilder: (context, index) {
                      final item =
                          favouriteServices[index];

                      return Card(
                        elevation: 4,
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(
                                  10),
                          leading: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    8),
                            child: Image.network(
                              item["service_image"],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context,
                                      error,
                                      stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 70,
                                );
                              },
                            ),
                          ),
                          title: Text(
                            item["service_name"],
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "₹ ${item["service_price"]}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              removeFavourite(
                                item["service_master_id"]
                                    .toString(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}