import 'package:flutter/material.dart';
import 'package:flutter_application_88/booking_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service_model.dart';
import 'login_screen.dart';
import 'rating_screen.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
  });

  @override
  State<ServiceDetailsScreen> createState() =>
      _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState
    extends State<ServiceDetailsScreen> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    checkFavourite();
  }

  Future<void> checkFavourite() async {
    final prefs =
        await SharedPreferences.getInstance();

    List<String> favourites =
        prefs.getStringList("favourites") ?? [];

    setState(() {
      isFavourite = favourites.contains(
        widget.service.serviceMasterId.toString(),
      );
    });
  }

  Future<void> toggleFavourite() async {
    final prefs =
        await SharedPreferences.getInstance();

    List<String> favourites =
        prefs.getStringList("favourites") ?? [];

    if (favourites.contains(
      widget.service.serviceMasterId.toString(),
    )) {
      favourites.remove(
        widget.service.serviceMasterId.toString(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Removed from favourites"),
        ),
      );
    } else {
      favourites.add(
        widget.service.serviceMasterId.toString(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Added to favourites"),
        ),
      );
    }

    await prefs.setStringList(
      "favourites",
      favourites,
    );

    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      appBar: AppBar(
        title: Text(service.serviceName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Image.network(
              service.serviceImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            Padding(
              padding:
                  const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    service.serviceName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Category: ${service.subCategoryName}",
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 225, 86, 86),
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${service.servicePrice}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Service Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    service.serviceDetails.isEmpty
                        ? "No details available"
                        : service.serviceDetails,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue,
                            foregroundColor:
                                Colors.white,
                            minimumSize:
                                const Size.fromHeight(
                                    50),
                          ),
                      
                       onPressed: () async {
                            final prefs =
                                await SharedPreferences.getInstance();

                            String userId =
                                prefs.getString("user_id") ?? "";

                            if (userId.isEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingScreen(
                                    userId: userId,
                                    serviceMasterId:
                                        service.serviceMasterId,
                                    serviceName:
                                        service.serviceName,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Book Now",
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child:
                            ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red,
                            foregroundColor:
                                Colors.white,
                            minimumSize:
                                const Size.fromHeight(
                                    50),
                          ),
                          onPressed:
                              toggleFavourite,
                          icon: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons
                                    .favorite_border,
                          ),
                          label: Text(
                            isFavourite
                                ? "Unfavourite"
                                : "Favourite",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.amber,
                        foregroundColor:
                            Colors.black,
                        minimumSize:
                            const Size.fromHeight(
                                55),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RatingScreen(
                              productId: service
                                  .serviceMasterId
                                  .toString(),
                            ),
                          ),
                        );
                      },
                      icon:
                          const Icon(Icons.star),
                      label: const Text(
                        "Rate Service",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
          ),
      ),
    );
  }
}