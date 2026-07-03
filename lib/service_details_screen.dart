import 'package:flutter/material.dart';
import 'service_model.dart';
import 'booking_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    service.serviceName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Category: ${service.subCategoryName}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 225, 86, 86),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${service.servicePrice}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Service Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

                  SizedBox(
                    width: double.infinity,
                    height: 50,
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
                            builder: (context) => BookingScreen(
                              userId: "1", // Replace with actual user ID
                              serviceMasterId: service.serviceMasterId,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Book Now",
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
  }
}