import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_88/core/constants/app_colors.dart';
import 'package:flutter_application_88/service_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_88/models/service_model.dart';

class QuickBookingScreen extends StatefulWidget {
  const QuickBookingScreen({super.key});

  @override
  State<QuickBookingScreen> createState() =>
      _QuickBookingScreenState();
}

class _QuickBookingScreenState
    extends State<QuickBookingScreen> {

  List<ServiceModel> serviceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    try {

      final response = await http.post(
        Uri.parse(
          'https://akashsir.in/atproject/atfinder-web/api/api-list-service.php',
        ),
      );

      final data =
          jsonDecode(response.body);

      if (data["flag"] == "1") {

        List list =
            data["service_list"];

        setState(() {

          serviceList = list
              .map(
                (e) =>
                    ServiceModel.fromJson(e),
              )
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

      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.bg,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Quick Booking",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : GridView.builder(

              padding:
                  const EdgeInsets.all(15),

              itemCount:
                  serviceList.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),

              itemBuilder:
                  (context, index) {

                final item =
                    serviceList[index];

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ServiceDetailsScreen(
                          service: item,
                        ),
                      ),
                    );
                  },

                  child: Card(

                    color:
                        AppColors.card,

                    shape:
                        RoundedRectangleBorder(
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
                              top:
                                  Radius.circular(
                                15,
                              ),
                            ),
                            child:
                                Image.network(
                              item.serviceImage,
                              width:
                                  double.infinity,
                              fit:
                                  BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.all(
                            8,
                          ),
                          child: Column(
                            children: [

                              Text(
                                item.serviceName,
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                textAlign:
                                    TextAlign
                                        .center,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                "₹ ${item.servicePrice}",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.green,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              Container(
                                width:
                                    double.infinity,
                                height: 35,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.blue,
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child:
                                    const Center(
                                  child: Text(
                                    "Book Now",
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white,
                                    ),
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
            ),
    );
  }
}