import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/views/booking_screen.dart';
import 'package:flutter_application_88/views/rating_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_88/models/service_model.dart';
import 'login_screen.dart';
import 'package:flutter_application_88/viewmodels/favourite_view_model.dart';

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
      final FavouriteViewModel favouriteVM =
    FavouriteViewModel();
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    checkFavourite();
  }

  Future<void> checkFavourite() async {

  isFavourite =
      await favouriteVM.isFavourite(
    widget.service.serviceMasterId,
  );

  setState(() {});
}

 Future<void> toggleFavourite() async {

  bool result =
      await favouriteVM.toggleFavourite(
    widget.service.serviceMasterId,
  );

  setState(() {
    isFavourite = result;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result
            ? "Added to favourites"
            : "Removed from favourites",
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          service.serviceName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      color: Colors.white,
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
                      color: Colors.white,
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
                      color:Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      Expanded(
                      
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),

                    
                      const SizedBox(width: 9),

                    Expanded(
                      child: SizedBox(
                        height: 47,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed:
                              toggleFavourite,
                          icon: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons
                                    .favorite_border,size:18,
                          ),
                          label: Text(
                            isFavourite
                                ? "Unfavourite"
                                : "Favourite",style: TextStyle(fontSize: 12),
                          ),
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